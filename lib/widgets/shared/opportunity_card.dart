import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OpportunityCard extends StatelessWidget {
  final String title;
  final String category;
  final String targetAmount;
  final String raisedAmount;
  final double progress;
  final String expectedReturn;
  final VoidCallback? onTap;

  const OpportunityCard({
    super.key,
    required this.title,
    required this.category,
    required this.targetAmount,
    required this.raisedAmount,
    required this.progress,
    required this.expectedReturn,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.hairlineSoft, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.canvasSoft,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  category,
                  style: AppTypography.label.copyWith(color: AppColors.ink),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'عائد متوقع: $expectedReturn',
                  style: AppTypography.label.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTypography.heading4.copyWith(fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تم جمع: $raisedAmount',
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
              Text(
                'الهدف: $targetAmount',
                style: AppTypography.caption.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.canvasSoft,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.ink),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
