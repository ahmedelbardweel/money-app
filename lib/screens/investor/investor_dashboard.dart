import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared/amwal_app_bar.dart';
import '../../widgets/investor/investor_bottom_nav.dart';
import '../shared/account_tab.dart';

/// Investor home tab — centered role name (placeholder for future content).
class _InvestorHomeTab extends StatelessWidget {
  const _InvestorHomeTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'المستخدم',
        textAlign: TextAlign.center,
        style: AppTypography.heading1,
      ),
    );
  }
}

/// Investor dashboard shell with bottom navigation.
class InvestorDashboard extends StatefulWidget {
  const InvestorDashboard({super.key});

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  int _currentIndex = 0;

  static const List<Widget> _tabs = [_InvestorHomeTab(), AccountTab()];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: const AmwalAppBar(),
        body: _tabs[_currentIndex],
        bottomNavigationBar: InvestorBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
