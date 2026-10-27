import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BrandFooter extends StatelessWidget {
  const BrandFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أموال.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.onPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'منصة التمويل والاستثمار الرقمي المرخصة والآمنة.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textFaint,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '© ${DateTime.now().year} Amwal Platform. All rights reserved.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textFaint.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
