import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../models/user_role.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/company/company_dashboard.dart';
import '../screens/investor/investor_dashboard.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseConfig.client;

  static User? get currentUser => _client.auth.currentUser;

  static bool get isAuthenticated => currentUser != null;

  /// Get role from currentUser metadata
  static UserRole getCurrentUserRole() {
    final meta = currentUser?.userMetadata;
    final roleString = meta?['role'] as String?;

    if (roleString == 'company') return UserRole.company;
    if (roleString == 'admin') return UserRole.admin;
    return UserRole.investor;
  }

  /// Get true role from public.profiles table in Supabase
  static Future<UserRole> fetchUserRole(String userId) async {
    try {
      final res = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      if (res != null && res['role'] != null) {
        final roleStr = res['role'] as String;
        if (roleStr == 'admin') return UserRole.admin;
        if (roleStr == 'company') return UserRole.company;
        return UserRole.investor;
      }
    } catch (_) {}

    return getCurrentUserRole();
  }

  /// Sign up with email, password, role and custom metadata
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required UserRole role,
    required Map<String, dynamic> metadata,
  }) async {
    final combinedMetadata = {
      ...metadata,
      'role': role.name,
      'created_at': DateTime.now().toIso8601String(),
    };

    return await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: combinedMetadata,
    );
  }

  /// Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign out
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Route to appropriate Dashboard based on role
  static Widget getDashboardForRole(UserRole role) {
    switch (role) {
      case UserRole.investor:
        return const InvestorDashboard();
      case UserRole.company:
        return const CompanyDashboard();
      case UserRole.admin:
        return const AdminDashboard();
    }
  }

  /// Navigate to role dashboard cleanly
  static void navigateToRoleDashboard(BuildContext context, UserRole role) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            getDashboardForRole(role),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      (route) => false,
    );
  }
}
