import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AdminAuditCard extends StatelessWidget {
  final String companyName;
  final String campaignTitle;
  final String requestedAmount;
  final String date;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AdminAuditCard({
    super.key,
    required this.companyName,
    required this.campaignTitle,
    required this.requestedAmount,
    required this.date,
    required this.onApprove,
    required this.onReject,
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
                  companyName,
                  style: AppTypography.label.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                date,
                style: AppTypography.caption.copyWith(color: AppColors.textFaint),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            campaignTitle,
            style: AppTypography.heading4.copyWith(fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'المبلغ المطلوب: $requestedAmount',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'اعتماد الفرصة',
                      style: AppTypography.label.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.ink,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.hairline, width: 1),
                      shape: const StadiumBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'طلب استيفاء',
                      style: AppTypography.label.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
