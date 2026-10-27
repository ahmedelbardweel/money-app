import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';

/// Shared "حسابي" (My Account) tab — identical layout for all roles.
/// Shows sign-out button centered; extend later with profile fields.
class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  Future<void> _signOut(BuildContext context) async {
    await AuthService.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'حسابي',
            style: AppTypography.heading2,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('تسجيل الخروج'),
            ),
          ),
        ],
      ),
    );
  }
}
