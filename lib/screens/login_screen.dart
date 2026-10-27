import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole = UserRole.investor;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final res = await AuthService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Determine true role from Supabase public.profiles table
      final user = res.user;
      UserRole resolvedRole = _selectedRole;
      if (user != null) {
        resolvedRole = await AuthService.fetchUserRole(user.id);
      }

      if (!mounted) return;
      AuthService.navigateToRoleDashboard(context, resolvedRole);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.ink,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تسجيل الدخول: $e'),
          backgroundColor: AppColors.ink,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(
          backgroundColor: AppColors.canvas,
          elevation: 0,
          leading: null,
          title: const Text(
            'أموال',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
              },
              child: Text(
                'حساب جديد',
                style: AppTypography.link.copyWith(color: AppColors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // Header with Mobbin declarative style
                  const Text('تسجيل الدخول.', style: AppTypography.heading1),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'أهلاً بك مجدداً. اختر صفتك وسجّل الدخول للمتابعة.',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Role selector (Segmented control)
                  Text(
                    'صفة الدخول',
                    style: AppTypography.label.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppRoleSelector(
                    selectedRole: _selectedRole,
                    onRoleChanged: (role) {
                      setState(() => _selectedRole = role);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _selectedRole.descriptionAr,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Email input
                  AppTextField(
                    label: _selectedRole == UserRole.company
                        ? 'البريد الإلكتروني للشركة'
                        : 'البريد الإلكتروني',
                    hint: 'name@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      if (!val.contains('@')) {
                        return 'صيغة البريد الإلكتروني غير صحيحة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Password input
                  AppTextField(
                    label: 'كلمة المرور',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) {
                        return 'كلمة المرور يجب أن لا تقل عن 6 خانات';
                      }
                      return null;
                    },
                  ),


                  const SizedBox(height: AppSpacing.sm),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'سيتم إرسال رابط استعادة كلمة المرور إلى بريدك.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMuted,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Primary CTA Button
                  AppPrimaryButton(
                    label: 'تسجيل الدخول.',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Guest action
                  AppOutlineButton(
                    label: 'المتابعة كزائر',
                    onPressed: () {
                      AuthService.navigateToRoleDashboard(
                        context,
                        UserRole.investor,
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Sign up prompt
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب بعد؟',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SignupScreen(
                                  initialRole: _selectedRole == UserRole.admin
                                      ? UserRole.investor
                                      : _selectedRole,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'إنشاء حساب.',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
