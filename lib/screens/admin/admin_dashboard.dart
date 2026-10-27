import 'package:flutter/material.dart';
import '../../models/company_profile.dart';
import '../../services/company_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/admin/admin_bottom_nav.dart';
import '../../widgets/admin/company_approval_card.dart';
import '../../widgets/shared/amwal_app_bar.dart';
import '../shared/account_tab.dart';
import 'admin_opportunities_tab.dart';

/// تبويب الرئيسية للأدمن: إحصائيات سريعة وآخر 3 طلبات مع زر المزيد
class _AdminHomeTab extends StatelessWidget {
  final List<CompanyProfile> companies;
  final bool isLoading;
  final String? processingCompanyId;
  final VoidCallback onRefresh;
  final VoidCallback onNavigateToCompaniesTab;
  final Future<void> Function(CompanyProfile, bool) onToggleVerification;

  const _AdminHomeTab({
    required this.companies,
    required this.isLoading,
    required this.processingCompanyId,
    required this.onRefresh,
    required this.onNavigateToCompaniesTab,
    required this.onToggleVerification,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.ink,
          strokeWidth: 2,
        ),
      );
    }

    final pendingCount = companies.where((c) => !c.isVerified).length;
    final verifiedCount = companies.where((c) => c.isVerified).length;
    final pendingRequests = companies.where((c) => !c.isVerified).take(3).toList();

    return RefreshIndicator(
      color: AppColors.ink,
      backgroundColor: AppColors.canvas,
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'لوحة تحكم المسؤول',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'متابعة المنصة، واعتماد الشركات، وحماية المستثمرين.',
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),

            const SizedBox(height: AppSpacing.lg),

            // بطاقات الإحصائيات السريعة (Stats Row)
            Row(
              children: [
                _buildStatCard('إجمالي الشركات', '${companies.length}'),
                const SizedBox(width: AppSpacing.sm),
                _buildStatCard(
                  'قيد الاعتماد',
                  '$pendingCount',
                  isHighlighted: pendingCount > 0,
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildStatCard('المعتمدة', '$verifiedCount'),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // عنوان قسم آخر الطلبات المعلقة مع زر المزيد
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'طلبات بانتظار الاعتماد',
                      style: AppTypography.heading4,
                    ),
                    Text(
                      'أحدث المنشآت التي تتطلب مراجعة (تختفي فور اعتمادها)',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onNavigateToCompaniesTab,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('المزيد'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // عرض الطلبات المعلقة فقط (تختفي بمجرد اعتمادها)
            if (pendingRequests.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 36,
                      color: AppColors.ink,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'رائع! لا توجد طلبات معلقة حالياً، تم اعتماد جميع الشركات.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingRequests.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final company = pendingRequests[index];
                  return CompanyApprovalCard(
                    company: company,
                    isActionLoading: processingCompanyId == company.id,
                    onToggleVerification: (newStatus) =>
                        onToggleVerification(company, newStatus),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onNavigateToCompaniesTab,
                  icon: const Icon(Icons.list_alt_rounded, size: 18),
                  label: Text('عرض كافة الشركات (${companies.length})'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value,
      {bool isHighlighted = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.ink : AppColors.field,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: isHighlighted
                    ? AppColors.onPrimary.withAlpha(200)
                    : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isHighlighted ? AppColors.onPrimary : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// تبويب اعتماد الشركات المخصص: كامل القائمة مع فلاتر البحث والاعتماد
class _AdminCompaniesTab extends StatefulWidget {
  final List<CompanyProfile> companies;
  final bool isLoading;
  final String? processingCompanyId;
  final VoidCallback onRefresh;
  final Future<void> Function(CompanyProfile, bool) onToggleVerification;

  const _AdminCompaniesTab({
    required this.companies,
    required this.isLoading,
    required this.processingCompanyId,
    required this.onRefresh,
    required this.onToggleVerification,
  });

  @override
  State<_AdminCompaniesTab> createState() => _AdminCompaniesTabState();
}

class _AdminCompaniesTabState extends State<_AdminCompaniesTab> {
  int _selectedFilterIndex = 0; // 0: الكل, 1: بانتظار الاعتماد, 2: معتمد

  List<CompanyProfile> get _filteredCompanies {
    if (_selectedFilterIndex == 1) {
      return widget.companies.where((c) => !c.isVerified).toList();
    } else if (_selectedFilterIndex == 2) {
      return widget.companies.where((c) => c.isVerified).toList();
    }
    return widget.companies;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.ink,
          strokeWidth: 2,
        ),
      );
    }

    final filtered = _filteredCompanies;

    return RefreshIndicator(
      color: AppColors.ink,
      backgroundColor: AppColors.canvas,
      onRefresh: () async => widget.onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اعتماد الشركات',
              style: AppTypography.heading2,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'فحص وتوثيق كافة الشركات المسجلة لمنع الاحتيال وضمان أمان المستثمرين.',
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),

            const SizedBox(height: AppSpacing.lg),

            // فلاتر التصفية
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل (${widget.companies.length})', 0),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    'بانتظار الاعتماد (${widget.companies.where((c) => !c.isVerified).length})',
                    1,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    'معتمد (${widget.companies.where((c) => c.isVerified).length})',
                    2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.domain_verification_rounded,
                      size: 40,
                      color: AppColors.textFaint,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _selectedFilterIndex == 1
                          ? 'لا توجد شركات بانتظار الاعتماد حالياً.'
                          : 'لا توجد شركات في هذا القسم.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final company = filtered[index];
                  return CompanyApprovalCard(
                    company: company,
                    isActionLoading: widget.processingCompanyId == company.id,
                    onToggleVerification: (newStatus) =>
                        widget.onToggleVerification(company, newStatus),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ink : AppColors.field,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.onPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

/// شاشة لوحة تحكم المسؤول (Admin Dashboard)
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  List<CompanyProfile> _companies = [];
  bool _isLoading = true;
  String? _processingCompanyId;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() => _isLoading = true);
    final data = await CompanyService.getAllCompanies();
    if (mounted) {
      setState(() {
        _companies = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleToggleVerification(
    CompanyProfile company,
    bool newStatus,
  ) async {
    setState(() => _processingCompanyId = company.id);

    final success = await CompanyService.updateCompanyVerification(
      companyId: company.id,
      isVerified: newStatus,
    );

    if (mounted) {
      setState(() => _processingCompanyId = null);

      if (success) {
        setState(() {
          final index = _companies.indexWhere((c) => c.id == company.id);
          if (index != -1) {
            _companies[index] = company.copyWith(isVerified: newStatus);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus
                  ? 'تم اعتماد شركة "${company.companyName}" بنجاح! أصبح بإمكانها نشر الفرص.'
                  : 'تم إلغاء اعتماد شركة "${company.companyName}" ومنع النشر.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.ink,
          ),
        );
        _loadCompanies();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر تحديث الحالة، تأكد من الصلاحيات والاتصال.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _AdminHomeTab(
        companies: _companies,
        isLoading: _isLoading,
        processingCompanyId: _processingCompanyId,
        onRefresh: _loadCompanies,
        onNavigateToCompaniesTab: () => setState(() => _currentIndex = 2),
        onToggleVerification: _handleToggleVerification,
      ),
      const AdminOpportunitiesTab(),
      _AdminCompaniesTab(
        companies: _companies,
        isLoading: _isLoading,
        processingCompanyId: _processingCompanyId,
        onRefresh: _loadCompanies,
        onToggleVerification: _handleToggleVerification,
      ),
      const AccountTab(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: const AmwalAppBar(),
        body: tabs[_currentIndex],
        bottomNavigationBar: AdminBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
