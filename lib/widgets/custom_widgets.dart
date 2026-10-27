import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../theme/app_theme.dart';

/// Mobbin Primary Button: Stadium pill, Ink (#141414) fill, On-Primary (#FFFFFF) text, 0 shadow.
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.inkSoft.withValues(alpha: 0.6),
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.link.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(icon, size: 18, color: AppColors.onPrimary),
                  ],
                ],
              ),
      ),
    );
  }
}

/// Mobbin Outline Button: Stadium pill, Canvas (#FFFFFF) fill, 1px Hairline (#E0E0E0) border.
class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;

  const AppOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.canvas,
          foregroundColor: AppColors.ink,
          elevation: 0,
          side: const BorderSide(color: AppColors.hairline, width: 1),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.link.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mobbin Form Text Input: Field (#F0F0F0) fill, 16px radius, no border at rest, 2px ink focus ring.
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: AppTypography.body.copyWith(color: AppColors.ink),
          cursorColor: AppColors.ink,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textFaint),
            filled: true,
            fillColor: AppColors.field,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(color: AppColors.ink, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

/// Mobbin Segmented Control Role Selector:
/// Canvas-Soft (#F3F3F3) track with stadium pill active toggle.
class AppRoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;
  final List<UserRole>? roles;

  const AppRoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.roles,
  });

  @override
  Widget build(BuildContext context) {
    final displayRoles = roles ?? UserRole.values;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvasSoft,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: displayRoles.map((role) {
          final isSelected = role == selectedRole;
          return Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.canvas : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: isSelected
                      ? Border.all(color: AppColors.hairlineSoft, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    role.titleAr,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTypography.label.copyWith(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                          )
                        : AppTypography.label.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
