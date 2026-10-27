import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../screens/login_screen.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import 'role_badge.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserRole role;

  const DashboardAppBar({
    super.key,
    required this.role,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.canvas,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: null,
      title: const Text(
        'أموال',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        RoleBadge(role: role),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.ink, size: 20),
          tooltip: 'تسجيل الخروج',
          onPressed: () async {
            await AuthService.signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}
