import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final bool isFilled;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isFilled ? AppColors.canvasSoft : AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isFilled
            ? null
            : Border.all(color: AppColors.hairlineSoft, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.heading2.copyWith(fontSize: 22),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.caption.copyWith(
                color: AppColors.textFaint,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
