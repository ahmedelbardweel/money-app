import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Shared bottom navigation bar widget — Mobbin monochrome style.
/// Two tabs: الرئيسية (Home) & حسابي (Profile).
class AmwalBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AmwalBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(
          top: BorderSide(color: AppColors.hairlineSoft, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.canvas,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.ink,
        unselectedItemColor: AppColors.textFaint,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: AppTypography.label,
        unselectedLabelStyle: AppTypography.caption,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
