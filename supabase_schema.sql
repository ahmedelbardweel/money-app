-- ==============================================================================
-- AMWAL PLATFORM (منصة أموال) - SUPABASE DATABASE SCHEMA
-- ==============================================================================
-- Description: Production-ready PostgreSQL schema with RLS, Triggers, and Roles
-- Roles: Investor (مستثمر), Company (شركة / صاحب فرصة), Admin (مسؤول)
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. CUSTOM TYPES & ENUMS
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('investor', 'company', 'admin');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE opportunity_status AS ENUM ('pending', 'approved', 'rejected', 'completed');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE investment_status AS ENUM ('active', 'completed', 'cancelled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 3. PROFILES TABLE (ملفات المستخدمين)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role user_role NOT NULL DEFAULT 'investor',
    full_name TEXT,
    phone TEXT,
    company_name TEXT,
    cr_number TEXT,
    representative_name TEXT,
    admin_key TEXT,
    avatar_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 4. OPPORTUNITIES TABLE (الفرص التمويلية والصكوك)
CREATE TABLE IF NOT EXISTS public.opportunities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    min_budget NUMERIC(15, 2) NOT NULL DEFAULT 300.00 CHECK (min_budget >= 0),
    target_amount NUMERIC(15, 2) NOT NULL DEFAULT 10000.00 CHECK (target_amount > 0),
    raised_amount NUMERIC(15, 2) NOT NULL DEFAULT 0.00 CHECK (raised_amount >= 0),
    expected_return NUMERIC(5, 2) NOT NULL DEFAULT 12.00 CHECK (expected_return >= 0),
    duration_months INTEGER NOT NULL DEFAULT 12 CHECK (duration_months > 0),
    risk_level TEXT NOT NULL DEFAULT 'متوسط', -- منخفض، متوسط، مرتفع
    experience_level TEXT NOT NULL DEFAULT 'متوسط', -- منخفض، متوسط، مرتفع
    official_source_url TEXT,
    status opportunity_status NOT NULL DEFAULT 'pending',
    rejection_reason TEXT,
    approved_by UUID REFERENCES public.profiles(id),
    approved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Safe migration additions if table already exists
ALTER TABLE public.opportunities ADD COLUMN IF NOT EXISTS min_budget NUMERIC(15, 2) DEFAULT 300.00;
ALTER TABLE public.opportunities ADD COLUMN IF NOT EXISTS risk_level TEXT DEFAULT 'متوسط';
ALTER TABLE public.opportunities ADD COLUMN IF NOT EXISTS experience_level TEXT DEFAULT 'متوسط';
ALTER TABLE public.opportunities ADD COLUMN IF NOT EXISTS official_source_url TEXT;
ALTER TABLE public.opportunities ALTER COLUMN company_id DROP NOT NULL;


-- 5. INVESTMENTS TABLE (الاستثمارات وعمليات التمويل)
CREATE TABLE IF NOT EXISTS public.investments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    investor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    opportunity_id UUID NOT NULL REFERENCES public.opportunities(id) ON DELETE CASCADE,
    amount NUMERIC(15, 2) NOT NULL CHECK (amount > 0),
    status investment_status NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 6. AUTOMATED TRIGGER: SYNC NEW AUTH USER TO PUBLIC.PROFILES
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER 
LANGUAGE plpgsql 
SECURITY DEFINER 
SET search_path = public, auth, pg_temp
AS $$
DECLARE
    user_role_val public.user_role := 'investor';
BEGIN
    -- Extract role safely from metadata
    IF (NEW.raw_user_meta_data->>'role') = 'company' THEN
        user_role_val := 'company';
    ELSIF (NEW.raw_user_meta_data->>'role') = 'admin' THEN
        user_role_val := 'admin';
    ELSE
        user_role_val := 'investor';
    END IF;

    -- Insert into public.profiles
    INSERT INTO public.profiles (
        id,
        role,
        full_name,
        phone,
        company_name,
        cr_number,
        representative_name,
        admin_key,
        created_at,
        updated_at
    ) VALUES (
        NEW.id,
        user_role_val,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'phone',
        NEW.raw_user_meta_data->>'company_name',
        NEW.raw_user_meta_data->>'cr_number',
        NEW.raw_user_meta_data->>'representative_name',
        NEW.raw_user_meta_data->>'admin_key',
        NOW(),
        NOW()
    )
    ON CONFLICT (id) DO UPDATE
    SET 
        role = EXCLUDED.role,
        full_name = COALESCE(EXCLUDED.full_name, public.profiles.full_name),
        phone = COALESCE(EXCLUDED.phone, public.profiles.phone),
        updated_at = NOW();

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Catch any error so auth.users insertion never fails
        RAISE WARNING 'handle_new_user notice: %', SQLERRM;
        RETURN NEW;
END;
$$;

-- Bind Trigger to auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Permissions grant
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO postgres, anon, authenticated, service_role;

-- 7. AUTOMATED TRIGGER: UPDATE OPPORTUNITY RAISED AMOUNT ON NEW INVESTMENT
CREATE OR REPLACE FUNCTION public.handle_new_investment()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.opportunities
    SET raised_amount = raised_amount + NEW.amount,
        updated_at = NOW()
    WHERE id = NEW.opportunity_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_investment_created ON public.investments;
CREATE TRIGGER on_investment_created
    AFTER INSERT ON public.investments
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_investment();

-- 8. ROW LEVEL SECURITY (RLS) POLICIES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.investments ENABLE ROW LEVEL SECURITY;

-- Helper function: Check if current user is Admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- PROFILES POLICIES:
-- 1. Users can view their own profile
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id OR public.is_admin());

-- 2. Users and admins can update profile (e.g. verification by admin)
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users and admins can update profile" ON public.profiles;
CREATE POLICY "Users and admins can update profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id OR public.is_admin());

-- OPPORTUNITIES POLICIES:
-- 1. Everyone can view approved opportunities
DROP POLICY IF EXISTS "Anyone can view approved opportunities" ON public.opportunities;
CREATE POLICY "Anyone can view approved opportunities"
    ON public.opportunities FOR SELECT
    USING (status = 'approved' OR company_id = auth.uid() OR public.is_admin());

-- 2. Companies can insert new opportunities ONLY if verified by Admin, and Admins can insert any opportunity
DROP POLICY IF EXISTS "Companies can insert opportunities" ON public.opportunities;
DROP POLICY IF EXISTS "Companies and admins can insert opportunities" ON public.opportunities;
CREATE POLICY "Companies and admins can insert opportunities"
    ON public.opportunities FOR INSERT
    WITH CHECK (
        public.is_admin() OR (
            company_id = auth.uid() AND
            EXISTS (
                SELECT 1 FROM public.profiles 
                WHERE id = auth.uid() AND role = 'company' AND is_verified = TRUE
            )
        )
    );


-- 3. Companies can update their own pending opportunities
DROP POLICY IF EXISTS "Companies can update own pending opportunities" ON public.opportunities;
CREATE POLICY "Companies can update own pending opportunities"
    ON public.opportunities FOR UPDATE
    USING (company_id = auth.uid() AND status = 'pending')
    WITH CHECK (company_id = auth.uid() AND status = 'pending');

-- 4. Admins can update any opportunity (Approve / Reject)
DROP POLICY IF EXISTS "Admins can update all opportunities" ON public.opportunities;
CREATE POLICY "Admins can update all opportunities"
    ON public.opportunities FOR UPDATE
    USING (public.is_admin());

-- 5. Admins can delete opportunities
DROP POLICY IF EXISTS "Admins can delete opportunities" ON public.opportunities;
CREATE POLICY "Admins can delete opportunities"
    ON public.opportunities FOR DELETE
    USING (public.is_admin());

-- INVESTMENTS POLICIES:
-- 1. Investors can view their own investments
DROP POLICY IF EXISTS "Investors can view own investments" ON public.investments;
CREATE POLICY "Investors can view own investments"
    ON public.investments FOR SELECT
    USING (
        investor_id = auth.uid() OR
        public.is_admin() OR
        EXISTS (
            SELECT 1 FROM public.opportunities o
            WHERE o.id = investments.opportunity_id AND o.company_id = auth.uid()
        )
    );

-- 2. Investors can insert their own investments into approved opportunities
DROP POLICY IF EXISTS "Investors can insert investments" ON public.investments;
CREATE POLICY "Investors can insert investments"
    ON public.investments FOR INSERT
    WITH CHECK (
        investor_id = auth.uid() AND
        EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'investor') AND
        EXISTS (SELECT 1 FROM public.opportunities WHERE id = opportunity_id AND status = 'approved')
    );

