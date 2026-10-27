import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_widgets.dart';

class AccountStep2Form extends StatefulWidget {
  final bool isCompany;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool agreeToTerms;
  final ValueChanged<bool> onTermsChanged;

  const AccountStep2Form({
    super.key,
    required this.isCompany,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.agreeToTerms,
    required this.onTermsChanged,
  });

  @override
  State<AccountStep2Form> createState() => _AccountStep2FormState();
}

class _AccountStep2FormState extends State<AccountStep2Form> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: widget.isCompany ? 'البريد الرسمي للمراسلات' : 'البريد الإلكتروني',
          hint: 'name@example.com',
          controller: widget.emailController,
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
            if (!val.contains('@') || !val.contains('.')) {
              return 'صيغة البريد الإلكتروني غير صحيحة';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'كلمة المرور',
          hint: '••••••••',
          controller: widget.passwordController,
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
              return 'يجب أن لا تقل كلمة المرور عن 6 خانات';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'تأكيد كلمة المرور',
          hint: '••••••••',
          controller: widget.confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          prefixIcon: const Icon(
            Icons.lock_outline,
            size: 20,
            color: AppColors.textMuted,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
            onPressed: () {
              setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
          ),
          validator: (val) {
            if (val != widget.passwordController.text) {
              return 'كلمتا المرور غير متطابقتين';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: widget.agreeToTerms,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (val) {
                  widget.onTermsChanged(val ?? false);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'أوافق على ',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textMuted,
                  ),
                  children: const [
                    TextSpan(
                      text: 'الشروط والأحكام',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' و '),
                    TextSpan(
                      text: 'سياسة الخصوصية التمويلية.',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
