import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 2,
    required this.stepTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stepTitle,
              style: AppTypography.heading4.copyWith(fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.canvasSoft,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                'الخطوة $currentStep من $totalSteps',
                style: AppTypography.label.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompletedOrCurrent = index < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  left: index < totalSteps - 1 ? 6 : 0,
                ),
                decoration: BoxDecoration(
                  color: isCompletedOrCurrent
                      ? AppColors.ink
                      : AppColors.canvasSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
