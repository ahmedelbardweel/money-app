import 'package:flutter/material.dart';
import '../../models/company_profile.dart';
import '../../models/opportunity.dart';
import '../../services/company_service.dart';
import '../../services/opportunity_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/admin/opportunity_form_sheet.dart';
import '../../widgets/company/company_bottom_nav.dart';
import '../../widgets/company/company_verification_status_card.dart';
import '../../widgets/shared/amwal_app_bar.dart';
import '../shared/account_tab.dart';

/// تبويب الرئيسية للشركة
class _CompanyHomeTab extends StatefulWidget {
  const _CompanyHomeTab();

  @override
  State<_CompanyHomeTab> createState() => _CompanyHomeTabState();
}

class _CompanyHomeTabState extends State<_CompanyHomeTab> {
  CompanyProfile? _company;
  List<Opportunity> _myOpportunities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    setState(() => _isLoading = true);
    final compData = await CompanyService.getCurrentCompanyProfile();
    final opps = await OpportunityService.fetchCompanyOpportunities();

    if (mounted) {
      setState(() {
        _company = compData;
        _myOpportunities = opps;
        _isLoading = false;
      });
    }
  }

  void _openCreateOpportunitySheet() {
    OpportunityFormSheet.show(
      context,
      isCompanySubmission: true,
      onSaved: _loadCompanyData,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.ink,
          strokeWidth: 2,
        ),
      );
    }

    if (_company == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'الشركة / صاحب الفرصة',
              textAlign: TextAlign.center,
              style: AppTypography.heading1,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: _loadCompanyData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    final isVerified = _company!.isVerified;

    return RefreshIndicator(
      color: AppColors.ink,
      backgroundColor: AppColors.canvas,
      onRefresh: _loadCompanyData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - (AppSpacing.lg * 2),
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم الشركة مع إشارة الاعتماد وزر إضافة فرصة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _company!.companyName,
                                    style: AppTypography.heading2,
                                  ),
                                  if (isVerified) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.verified_rounded,
                                      color: AppColors.accent,
                                      size: 24,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                isVerified
                                    ? 'حساب موثق ومعتمد لنشر الفرص الاستثمارية'
                                    : 'لوحة تحكم صاحب الفرصة الاستثمارية',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isVerified && _myOpportunities.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: _openCreateOpportunitySheet,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('فرصة جديدة'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // إذا كانت الشركة غير معتمدة: تظهر بطاقة المراجعة فقط
                    if (!isVerified)
                      CompanyVerificationStatusCard(
                        company: _company!,
                        onRefresh: _loadCompanyData,
                      )
                    // إذا لم تنشئ أي فرصة بعد: يظهر الزر بالمنتصف
                    else if (_myOpportunities.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: AppColors.field,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.rocket_launch_outlined,
                                  size: 38,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const Text(
                                'لا توجد فرص منشورة بعد',
                                style: AppTypography.heading3,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'حسابكم معتمد الآن، ابدأ بإنشاء أول فرصة تمويلية.',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              SizedBox(
                                width: 230,
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: _openCreateOpportunitySheet,
                                  icon: const Icon(Icons.add_rounded, size: 20),
                                  label: const Text(
                                    'إنشاء فرصة جديدة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    // إذا أنشأت فرصاً: تظهر قائمة بالفرص وحالتها
                    else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'فرص المنشأة',
                            style: AppTypography.heading4,
                          ),
                          Text(
                            'إجمالي: ${_myOpportunities.length}',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _myOpportunities.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final opp = _myOpportunities[index];
                          return _buildCompanyOpportunityCard(opp);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompanyOpportunityCard(Opportunity opp) {
    final isApproved = opp.status == 'approved';
    final isPending = opp.status == 'pending';

    String statusText = isApproved
        ? 'معتمدة ومنشورة ✓'
        : (isPending ? 'قيد مراجعة الإدارة' : 'مرفوضة ✕');
    Color statusBg = isApproved
        ? AppColors.ink
        : (isPending ? AppColors.canvasSoft : Colors.red.withAlpha(25));
    Color statusFg = isApproved
        ? AppColors.onPrimary
        : (isPending ? AppColors.textMuted : Colors.red);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.hairline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  opp.category,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(opp.title, style: AppTypography.heading4),
          const SizedBox(height: 4),
          if (opp.description.isNotEmpty)
            Text(
              opp.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                'الحد الأدنى: ${opp.minBudget.toStringAsFixed(0)} \$',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'المخاطرة: ${opp.riskLevel}',
                style: AppTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// واجهة داشبورد الشركة
class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  int _currentIndex = 0;

  static const List<Widget> _tabs = [
    _CompanyHomeTab(),
    AccountTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: const AmwalAppBar(),
        body: _tabs[_currentIndex],
        bottomNavigationBar: CompanyBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
