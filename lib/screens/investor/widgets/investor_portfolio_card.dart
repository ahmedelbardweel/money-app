import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared/stat_card.dart';

class InvestorPortfolioCard extends StatelessWidget {
  final double totalInvested;
  final double totalProfits;
  final int activeOpportunitiesCount;
  final double availableBalance;

  const InvestorPortfolioCard({
    super.key,
    this.totalInvested = 0.0,
    this.totalProfits = 0.0,
    this.activeOpportunitiesCount = 0,
    this.availableBalance = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'إجمالي المحفظة',
                value: '${totalInvested.toStringAsFixed(2)} ر.س',
                subtitle: 'لا توجد أصول نشطة',
                isFilled: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                title: 'الأرباح المستلمة',
                value: '${totalProfits.toStringAsFixed(2)} ر.س',
                subtitle: 'توزيعات دورية',
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
                title: 'الفرص النشطة',
                value: '$activeOpportunitiesCount فرصة',
                subtitle: 'المشاركات الحالية',
                isFilled: false,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                title: 'الرصيد المتاح للاستثمار',
                value: '${availableBalance.toStringAsFixed(2)} ر.س',
                subtitle: 'المحفظة النقدية',
                isFilled: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
