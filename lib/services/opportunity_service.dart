import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../models/opportunity.dart';

class OpportunityService {
  static SupabaseClient get _client => SupabaseConfig.client;

  /// جلب كافة الفرص للأدمن لمراجعتها وإدارتها
  static Future<List<Opportunity>> fetchAllOpportunities() async {
    try {
      final response = await _client
          .from('opportunities')
          .select('*, profiles(company_name, full_name)')
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((item) => Opportunity.fromJson(item as Map<String, dynamic>))
          .toList();

      return list;
    } catch (e) {
      return [];
    }
  }

  /// جلب الفرص المعتمدة فقط (التي ستظهر للمستثمرين في التطبيق)
  static Future<List<Opportunity>> fetchApprovedOpportunities() async {
    try {
      final response = await _client
          .from('opportunities')
          .select('*, profiles(company_name, full_name)')
          .eq('status', 'approved')
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((item) => Opportunity.fromJson(item as Map<String, dynamic>))
          .toList();

      return list;
    } catch (e) {
      return [];
    }
  }

  /// جلب الفرص الخاصة بالشركة المسجلة حالياً
  static Future<List<Opportunity>> fetchCompanyOpportunities() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _client
          .from('opportunities')
          .select()
          .eq('company_id', user.id)
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((item) => Opportunity.fromJson(item as Map<String, dynamic>))
          .toList();

      return list;
    } catch (e) {
      return [];
    }
  }

  /// إنشاء فرصة جديدة من قبل الأدمن أو الشركة

  static Future<bool> createOpportunity(Opportunity opp) async {
    try {
      final user = _client.auth.currentUser;
      final data = opp.toJson();
      if (opp.companyId == null && user != null) {
        data['company_id'] = user.id;
      }
      data['created_at'] = DateTime.now().toIso8601String();

      await _client.from('opportunities').insert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// تعديل فرصة قائمة
  static Future<bool> updateOpportunity(Opportunity opp) async {
    try {
      final data = opp.toJson();
      await _client.from('opportunities').update(data).eq('id', opp.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// مراجعة واعتماد أو رفض الفرصة من قبل الأدمن
  static Future<bool> updateOpportunityStatus({
    required String id,
    required String status, // 'approved', 'rejected', 'pending'
    String? rejectionReason,
  }) async {
    try {
      final user = _client.auth.currentUser;
      final updateData = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
        if (status == 'approved') ...{
          'approved_by': user?.id,
          'approved_at': DateTime.now().toIso8601String(),
        },
      };

      if (rejectionReason != null) {
        updateData['rejection_reason'] = rejectionReason;
      }

      await _client.from('opportunities').update(updateData).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// حذف فرصة
  static Future<bool> deleteOpportunity(String id) async {
    try {
      await _client.from('opportunities').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
