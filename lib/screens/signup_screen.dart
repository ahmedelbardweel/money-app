import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_widgets.dart';
import 'signup/widgets/account_step2_form.dart';
import 'signup/widgets/company_step1_form.dart';
import 'signup/widgets/investor_step1_form.dart';
import 'signup/widgets/step_progress_bar.dart';

class SignupScreen extends StatefulWidget {
  final UserRole initialRole;

  const SignupScreen({
    super.key,
    this.initialRole = UserRole.investor,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  late UserRole _selectedRole;
  int _currentStep = 1;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _crNumberController = TextEditingController();
  final TextEditingController _representativeNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole == UserRole.admin
        ? UserRole.investor
        : widget.initialRole;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _crNumberController.dispose();
    _representativeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (_step1FormKey.currentState?.validate() ?? false) {
      setState(() => _currentStep = 2);
    }
  }

  void _goToStep1() {
    setState(() => _currentStep = 1);
  }

  Future<void> _handleSignup() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الموافقة على الشروط والأحكام للمتابعة.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!(_step2FormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final metadata = <String, dynamic>{
      'phone': _phoneController.text.trim(),
    };

    if (_selectedRole == UserRole.investor) {
      metadata['full_name'] = _nameController.text.trim();
    } else if (_selectedRole == UserRole.company) {
      metadata['company_name'] = _companyNameController.text.trim();
      metadata['cr_number'] = _crNumberController.text.trim();
      metadata['representative_name'] =
          _representativeNameController.text.trim();
    }

    try {
      await AuthService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        metadata: metadata,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الحساب بنجاح! مرحباً بك في أموال.'),
          backgroundColor: AppColors.ink,
          behavior: SnackBarBehavior.floating,
        ),
      );

      AuthService.navigateToRoleDashboard(context, _selectedRole);
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
          content: Text('حدث خطأ أثناء إنشاء الحساب: $e'),
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
    final isCompany = _selectedRole == UserRole.company;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(
          backgroundColor: AppColors.canvas,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: () {
              if (_currentStep == 2) {
                _goToStep1();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            _currentStep == 1 ? 'إنشاء حساب جديد' : 'إكمال بيانات الحساب',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),

                // Step progress bar
                StepProgressBar(
                  currentStep: _currentStep,
                  totalSteps: 2,
                  stepTitle: _currentStep == 1
                      ? (isCompany ? 'بيانات المنشأة والنشاط' : 'المعلومات الشخصية')
                      : 'بيانات الحساب والأمان',
                ),

                const SizedBox(height: AppSpacing.lg),

                // Role selector (Only in Step 1)
                if (_currentStep == 1) ...[
                  Text(
                    'نوع الحساب',
                    style: AppTypography.label.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppRoleSelector(
                    roles: const [UserRole.investor, UserRole.company],
                    selectedRole: _selectedRole,
                    onRoleChanged: (role) {
                      setState(() {
                        _selectedRole = role;
                      });
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
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Step 1 Form
                if (_currentStep == 1) ...[
                  Form(
                    key: _step1FormKey,
                    child: isCompany
                        ? CompanyStep1Form(
                            companyNameController: _companyNameController,
                            crNumberController: _crNumberController,
                            representativeNameController:
                                _representativeNameController,
                            phoneController: _phoneController,
                          )
                        : InvestorStep1Form(
                            nameController: _nameController,
                            phoneController: _phoneController,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: 'المتابعة إلى بيانات الحساب ⬅',
                    onPressed: _goToStep2,
                  ),
                ],

                // Step 2 Form
                if (_currentStep == 2) ...[
                  Form(
                    key: _step2FormKey,
                    child: AccountStep2Form(
                      isCompany: isCompany,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      agreeToTerms: _agreeToTerms,
                      onTermsChanged: (val) {
                        setState(() => _agreeToTerms = val);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: 'إنشاء الحساب.',
                    isLoading: _isLoading,
                    onPressed: _handleSignup,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppOutlineButton(
                    label: 'الرجوع للخطوة السابقة',
                    onPressed: _goToStep1,
                  ),
                ],

                const SizedBox(height: AppSpacing.xxl),

                // Login prompt
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'تسجيل الدخول.',
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
    );
  }
}
