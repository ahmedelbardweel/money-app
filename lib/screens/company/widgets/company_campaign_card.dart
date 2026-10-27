import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared/stat_card.dart';

class CompanyStatsGrid extends StatelessWidget {
  final double totalRequested;
  final double totalRaised;
  final int totalInvestors;
  final String complianceStatus;

  const CompanyStatsGrid({
    super.key,
    this.totalRequested = 0.0,
    this.totalRaised = 0.0,
    this.totalInvestors = 0,
    this.complianceStatus = 'بانتظار الطرح',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'إجمالي التمويل المطلوب',
                value: '${totalRequested.toStringAsFixed(2)} ر.س',
                subtitle: 'لا توجد حملات نشطة',
                isFilled: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                title: 'المبالغ المجمعة',
                value: '${totalRaised.toStringAsFixed(2)} ر.س',
                subtitle: 'نسبة الإنجاز 0%',
                isFilled: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'عدد المستثمرين',
                value: '$totalInvestors مستثمر',
                subtitle: 'إجمالي المشاركين',
                isFilled: false,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                title: 'حالة الاعتماد',
                value: complianceStatus,
                subtitle: 'السجل التجاري',
                isFilled: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
