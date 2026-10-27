import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared/stat_card.dart';

class AdminMetricsStrip extends StatelessWidget {
  final double totalManagedFunds;
  final int pendingRequestsCount;
  final int totalUsersCount;
  final double complianceRate;

  const AdminMetricsStrip({
    super.key,
    this.totalManagedFunds = 0.0,
    this.pendingRequestsCount = 0,
    this.totalUsersCount = 0,
    this.complianceRate = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'إجمالي التمويل المدار',
                value: '${totalManagedFunds.toStringAsFixed(2)} ر.س',
                subtitle: 'معاملات المنصة',
                isFilled: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                title: 'الطلبات المعلقة',
                value: '$pendingRequestsCount طلبات',
                subtitle: 'بانتظار الاعتماد',
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
                title: 'إجمالي المستخدمين',
                value: '$totalUsersCount',
                subtitle: 'مستثمرين وشركات',
                isFilled: false,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                title: 'نسبة الامتثال المالي',
                value: '${complianceRate.toStringAsFixed(1)}%',
                subtitle: 'معايير النظام',
                isFilled: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
