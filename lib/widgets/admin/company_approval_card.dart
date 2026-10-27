import 'package:flutter/material.dart';
import '../../models/company_profile.dart';
import '../../theme/app_theme.dart';

/// بطاقة فحص واعتماد الشركة من قبل الأدمن
class CompanyApprovalCard extends StatelessWidget {
  final CompanyProfile company;
  final bool isActionLoading;
  final ValueChanged<bool> onToggleVerification;

  const CompanyApprovalCard({
    super.key,
    required this.company,
    required this.isActionLoading,
    required this.onToggleVerification,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = company.isVerified;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isVerified ? AppColors.ink : AppColors.hairline,
          width: isVerified ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الرأس: اسم الشركة والشارة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.companyName.isEmpty
                          ? 'شركة بدون اسم'
                          : company.companyName,
                      style: AppTypography.heading4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سجل تجاري: ${company.crNumber.isEmpty ? "غير محدد" : company.crNumber}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isVerified ? AppColors.ink : AppColors.canvasSoft,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVerified
                          ? Icons.check_circle_rounded
                          : Icons.hourglass_empty_rounded,
                      size: 13,
                      color: isVerified
                          ? AppColors.onPrimary
                          : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isVerified ? 'معتمد' : 'بانتظار الاعتماد',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isVerified
                            ? AppColors.onPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // بيانات إضافية
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المفوض: ${company.representativeName.isEmpty ? "—" : company.representativeName}',
                  style: AppTypography.caption,
                ),
                Text(
                  'الهاتف: ${company.phone.isEmpty ? "—" : company.phone}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // أزرار اتخاذ القرار
          SizedBox(
            width: double.infinity,
            child: isActionLoading
                ? const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.ink,
                      ),
                    ),
                  )
                : isVerified
                    ? OutlinedButton.icon(
                        onPressed: () => onToggleVerification(false),
                        icon: const Icon(Icons.block_rounded, size: 16),
                        label: const Text('إلغاء الاعتماد ومنع النشر'),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => onToggleVerification(true),
                        icon: const Icon(Icons.check_circle_outline_rounded,
                            size: 16),
                        label: const Text('اعتماد الشركة والسماح بالنشر'),
                      ),
          ),
        ],
      ),
    );
  }
}
