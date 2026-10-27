import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Shared AppBar across all screens — shows only the app name "أموال".
/// Mobbin spec: Canvas background, 0 elevation, 0 shadow, Ink text.
class AmwalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AmwalAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarGrey,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        'أموال',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
