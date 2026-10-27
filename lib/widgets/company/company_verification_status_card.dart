import 'package:flutter/material.dart';
import '../../models/company_profile.dart';
import '../../theme/app_theme.dart';

/// بطاقة عرض حالة اعتماد الشركة بتصميم بسيط وأنيق وفق الثيم
class CompanyVerificationStatusCard extends StatelessWidget {
  final CompanyProfile company;
  final VoidCallback onRefresh;

  const CompanyVerificationStatusCard({
    super.key,
    required this.company,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = company.isVerified;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
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
          // شارة الحالة (Status Badge)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 5,
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
                          ? Icons.verified_rounded
                          : Icons.hourglass_top_rounded,
                      size: 15,
                      color: isVerified
                          ? AppColors.onPrimary
                          : AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isVerified ? 'معتمد وموثق' : 'قيد المراجعة والاعتماد',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isVerified
                            ? AppColors.onPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                tooltip: 'تحديث الحالة',
                color: AppColors.textMuted,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // العنوان
          Text(
            isVerified ? 'حساب الشركة معتمد' : 'الحساب بانتظار اعتماد الإدارة',
            style: AppTypography.heading3,
          ),

          const SizedBox(height: AppSpacing.xs),

          // الشرح التوضيحي البسيط
          Text(
            isVerified
                ? 'تم التحقق من السجل التجاري واعتماد حسابكم رسمياً. يمكنكم الآن نشر الفرص التمويلية واستقبال الاستثمارات.'
                : 'يتم فحص ومطابقة بيانات السجل التجاري لشركتكم من قبل الإدارة لحماية المستثمرين من الاحتيال. خاصية نشر الفرص ستتاح فور الاعتماد.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // تفاصيل بيانات السجل التجاري
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.field,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              children: [
                _buildInfoRow('اسم المنشأة:', company.companyName),
                const SizedBox(height: 6),
                _buildInfoRow('رقم السجل التجاري:', company.crNumber),
                if (company.representativeName.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _buildInfoRow('الممثل المفوض:', company.representativeName),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // زر الإجراء
          if (isVerified)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('واجهة نشر الفرص التمويلية جاهزة للبناء.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const Text('نشر فرصة استثمارية جديدة'),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.sync_rounded, size: 18),
                label: const Text('فحص حالة الاعتماد'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          value.isEmpty ? '—' : value,
          style: AppTypography.caption.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
