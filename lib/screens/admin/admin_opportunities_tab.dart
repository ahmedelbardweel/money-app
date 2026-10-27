import 'package:flutter/material.dart';
import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/admin/admin_opportunity_card.dart';
import '../../widgets/admin/opportunity_form_sheet.dart';

/// تبويب إدارة ومراجعة الفرص الاستثمارية للأدمن
class AdminOpportunitiesTab extends StatefulWidget {
  const AdminOpportunitiesTab({super.key});

  @override
  State<AdminOpportunitiesTab> createState() => _AdminOpportunitiesTabState();
}

class _AdminOpportunitiesTabState extends State<AdminOpportunitiesTab> {
  List<Opportunity> _opportunities = [];
  bool _isLoading = true;
  String? _processingOpportunityId;
  int _selectedFilterIndex = 0; // 0: الكل, 1: بانتظار المراجعة, 2: المعتمدة, 3: المرفوضة

  @override
  void initState() {
    super.initState();
    _loadOpportunities();
  }

  Future<void> _loadOpportunities() async {
    setState(() => _isLoading = true);
    final data = await OpportunityService.fetchAllOpportunities();
    if (mounted) {
      setState(() {
        _opportunities = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleStatusChange(String id, String newStatus) async {
    setState(() => _processingOpportunityId = id);

    final success = await OpportunityService.updateOpportunityStatus(
      id: id,
      status: newStatus,
    );

    if (mounted) {
      setState(() => _processingOpportunityId = null);

      if (success) {
        setState(() {
          final idx = _opportunities.indexWhere((o) => o.id == id);
          if (idx != -1) {
            _opportunities[idx] = _opportunities[idx].copyWith(status: newStatus);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'approved'
                  ? 'تم اعتماد الفرصة وأصبحت متاحة على التطبيق!'
                  : 'تم تحديث حالة الفرصة بنجاح.',
            ),
            backgroundColor: AppColors.ink,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadOpportunities();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر تحديث الحالة، تأكد من الاتصال والصلاحيات.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  List<Opportunity> get _filteredOpportunities {
    if (_selectedFilterIndex == 1) {
      return _opportunities.where((o) => o.status == 'pending').toList();
    } else if (_selectedFilterIndex == 2) {
      return _opportunities.where((o) => o.status == 'approved').toList();
    } else if (_selectedFilterIndex == 3) {
      return _opportunities.where((o) => o.status == 'rejected').toList();
    }
    return _opportunities;
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

    final filtered = _filteredOpportunities;
    final pendingCount =
        _opportunities.where((o) => o.status == 'pending').length;

    return RefreshIndicator(
      color: AppColors.ink,
      backgroundColor: AppColors.canvas,
      onRefresh: _loadOpportunities,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط العنوان مع زر إنشاء فرصة جديدة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إدارة ومراجعة الفرص',
                        style: AppTypography.heading2,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'إنشاء، مراجعة وتعديل الفرص قبل ظهورها',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    OpportunityFormSheet.show(
                      context,
                      onSaved: _loadOpportunities,
                    );
                  },
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

            const SizedBox(height: AppSpacing.lg),

            // فلاتر التصفية
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل (${_opportunities.length})', 0),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    'بانتظار المراجعة ($pendingCount)',
                    1,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    'المعتمدة (${_opportunities.where((o) => o.status == 'approved').length})',
                    2,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    'المرفوضة (${_opportunities.where((o) => o.status == 'rejected').length})',
                    3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // قائمة الفرص
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
                      Icons.layers_clear_outlined,
                      size: 40,
                      color: AppColors.textFaint,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _selectedFilterIndex == 1
                          ? 'لا توجد فرص بانتظار المراجعة والاعتماد.'
                          : 'لا توجد فرص مسجلة في هذا القسم.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () {
                        OpportunityFormSheet.show(
                          context,
                          onSaved: _loadOpportunities,
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('إنشاء فرصة جديدة الآن'),
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
                  final opp = filtered[index];
                  return AdminOpportunityCard(
                    opportunity: opp,
                    isProcessing: _processingOpportunityId == opp.id,
                    onEdit: () {
                      OpportunityFormSheet.show(
                        context,
                        existingOpportunity: opp,
                        onSaved: _loadOpportunities,
                      );
                    },
                    onStatusChange: (newStatus) =>
                        _handleStatusChange(opp.id, newStatus),
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
