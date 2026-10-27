import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../models/company_profile.dart';

class CompanyService {
  static SupabaseClient get _client => SupabaseConfig.client;

  /// جلب بيانات الشركة الحالية المسجلة للدخول
  static Future<CompanyProfile?> getCurrentCompanyProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return CompanyProfile.fromJson(response);
      }

      // إذا لم يتوفر بعد في profiles، استخرج من metadata
      final meta = user.userMetadata;
      if (meta != null) {
        return CompanyProfile(
          id: user.id,
          companyName: meta['company_name'] as String? ?? 'الشركة',
          crNumber: meta['cr_number'] as String? ?? '',
          representativeName: meta['representative_name'] as String? ?? '',
          phone: meta['phone'] as String? ?? '',
          isVerified: false,
        );
      }
    } catch (_) {
      // في حال وجود مشكلة شبكة أو جداول، استخرج من بيانات الجلسة الحالية
      final meta = user.userMetadata;
      if (meta != null) {
        return CompanyProfile(
          id: user.id,
          companyName: meta['company_name'] as String? ?? 'الشركة',
          crNumber: meta['cr_number'] as String? ?? '',
          representativeName: meta['representative_name'] as String? ?? '',
          phone: meta['phone'] as String? ?? '',
          isVerified: false,
        );
      }
    }
    return null;
  }

  /// جلب كافة الشركات المسجلة للأدمن لمراجعتها واعتمادها
  static Future<List<CompanyProfile>> getAllCompanies() async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('role', 'company')
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((item) => CompanyProfile.fromJson(item as Map<String, dynamic>))
          .toList();

      return list;
    } catch (e) {
      return [];
    }
  }

  /// تحديث حالة الاعتماد (اعتماد الشركة أو سحب الاعتماد)
  static Future<bool> updateCompanyVerification({
    required String companyId,
    required bool isVerified,
  }) async {
    try {
      await _client
          .from('profiles')
          .update({
            'is_verified': isVerified,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', companyId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
