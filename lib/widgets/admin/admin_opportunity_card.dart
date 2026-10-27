import 'package:flutter/material.dart';
import '../../models/opportunity.dart';
import '../../theme/app_theme.dart';

/// بطاقة عرض ومراجعة الفرصة الاستثمارية للأدمن
class AdminOpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final bool isProcessing;
  final VoidCallback onEdit;
  final ValueChanged<String> onStatusChange; // 'approved', 'rejected'
  final VoidCallback? onDelete;

  const AdminOpportunityCard({
    super.key,
    required this.opportunity,
    required this.isProcessing,
    required this.onEdit,
    required this.onStatusChange,
    this.onDelete,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isApproved = opportunity.status == 'approved';
    final isPending = opportunity.status == 'pending';
    final isRejected = opportunity.status == 'rejected';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isApproved
              ? AppColors.ink
              : (isPending ? AppColors.accent : AppColors.hairline),
          width: isApproved || isPending ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شارة القطاع والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  opportunity.category,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              _buildStatusBadge(isApproved, isPending, isRejected),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // عنوان الفرصة
          Text(
            opportunity.title,
            style: AppTypography.heading4,
          ),

          const SizedBox(height: AppSpacing.xs),

          // الوصف
          if (opportunity.description.isNotEmpty)
            Text(
              opportunity.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),

          const SizedBox(height: AppSpacing.md),

          // شارات التفاصيل (الحد الأدنى، المخاطرة، الخبرة)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildDetailChip(
                Icons.attach_money_rounded,
                'الحد الأدنى: ${opportunity.minBudget.toStringAsFixed(0)} \$',
              ),
              _buildDetailChip(
                Icons.shield_outlined,
                'المخاطرة: ${opportunity.riskLevel}',
              ),
              _buildDetailChip(
                Icons.psychology_outlined,
                'الخبرة: ${opportunity.experienceLevel}',
              ),
            ],
          ),

          // رابط المصدر الرسمي إن وجد
          if (opportunity.officialSourceUrl != null &&
              opportunity.officialSourceUrl!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.field,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 15, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'مصدر رسمي: ${opportunity.officialSourceUrl}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),

          // تواريخ النشر والتحديث
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نُشر في: ${_formatDate(opportunity.createdAt)}',
                style: AppTypography.caption,
              ),
              Text(
                'آخر تحديث: ${_formatDate(opportunity.updatedAt)}',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // أزرار اتخاذ القرار والمراجعة والتعديل
          if (isProcessing)
            const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.ink,
                ),
              ),
            )
          else
            Row(
              children: [
                // زر التعديل دائماً متاح للأدمن
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),

                // إذا كانت معلقة: أزرار الاعتماد أو الرفض
                if (isPending) ...[
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => onStatusChange('approved'),
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: const Text('اعتماد ونشر'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    onPressed: () => onStatusChange('rejected'),
                    icon: const Icon(Icons.close_rounded, color: Colors.red),
                    tooltip: 'رفض الفرصة',
                  ),
                ] else if (isApproved) ...[
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () => onStatusChange('rejected'),
                      icon: const Icon(Icons.block_rounded, size: 16),
                      label: const Text('إيقاف النشر'),
                    ),
                  ),
                ] else if (isRejected) ...[
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => onStatusChange('approved'),
                      icon: const Icon(Icons.check_circle_outline_rounded,
                          size: 16),
                      label: const Text('إعادة الاعتماد'),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.canvasSoft,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isApproved, bool isPending, bool isRejected) {
    String text = 'بانتظار المراجعة';
    Color bgColor = AppColors.canvasSoft;
    Color textColor = AppColors.textMuted;
    IconData icon = Icons.hourglass_top_rounded;

    if (isApproved) {
      text = 'معتمدة ومنشورة ✓';
      bgColor = AppColors.ink;
      textColor = AppColors.onPrimary;
      icon = Icons.verified_rounded;
    } else if (isRejected) {
      text = 'مرفوضة ✕';
      bgColor = Colors.red.withAlpha(25);
      textColor = Colors.red;
      icon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
