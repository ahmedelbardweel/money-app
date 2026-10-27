import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// شريط تنقل سفلي مخصص للمستثمر (Custom Bottom Navigation Bar)
/// الكبسولة باللون الرمادي الفاتح، والكلمة تحت الأيقونة بدون أي هوفر
class InvestorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const InvestorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomNavGrey,
        border: Border(
          top: BorderSide(
            color: AppColors.hairline,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _CustomTabItem(
                label: 'الرئيسية',
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _CustomTabItem(
                label: 'حسابي',
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.appBarGrey : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected ? AppColors.ink : AppColors.textMuted,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.ink : AppColors.textMuted,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
