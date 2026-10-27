import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../theme/app_theme.dart';

class RoleBadge extends StatelessWidget {
  final UserRole role;
  final bool inverted;

  const RoleBadge({
    super.key,
    required this.role,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: inverted ? AppColors.ink : AppColors.canvasSoft,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: inverted
            ? null
            : Border.all(color: AppColors.hairlineSoft, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: inverted ? AppColors.onPrimary : AppColors.ink,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            role.titleAr,
            style: AppTypography.label.copyWith(
              color: inverted ? AppColors.onPrimary : AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
