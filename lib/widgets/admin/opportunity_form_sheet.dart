import 'package:flutter/material.dart';
import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../theme/app_theme.dart';
import '../custom_widgets.dart';

/// نموذج إنشاء وتعديل الفرصة الاستثمارية للأدمن
class OpportunityFormSheet extends StatefulWidget {
  final Opportunity? existingOpportunity;
  final bool isCompanySubmission;
  final VoidCallback onSaved;

  const OpportunityFormSheet({
    super.key,
    this.existingOpportunity,
    this.isCompanySubmission = false,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    Opportunity? existingOpportunity,
    bool isCompanySubmission = false,
    required VoidCallback onSaved,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: OpportunityFormSheet(
          existingOpportunity: existingOpportunity,
          isCompanySubmission: isCompanySubmission,
          onSaved: onSaved,
        ),
      ),
    );
  }

  @override
  State<OpportunityFormSheet> createState() => _OpportunityFormSheetState();
}

class _OpportunityFormSheetState extends State<OpportunityFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _minBudgetController;
  late TextEditingController _targetAmountController;
  late TextEditingController _descriptionController;
  late TextEditingController _officialSourceController;

  String _selectedCategory = 'سوق مال';
  String _selectedRiskLevel = 'متوسط';
  String _selectedExperienceLevel = 'متوسط';
  bool _isSaving = false;

  final List<String> _categories = [
    'سوق مال',
    'تجارة إلكترونية',
    'خدمات',
    'عقارات',
    'تقنية',
    'أخرى',
  ];

  final List<String> _riskLevels = ['منخفض', 'متوسط', 'مرتفع'];
  final List<String> _experienceLevels = ['منخفض', 'متوسط', 'مرتفع'];

  @override
  void initState() {
    super.initState();
    final opp = widget.existingOpportunity;
    _titleController = TextEditingController(text: opp?.title ?? '');
    _minBudgetController = TextEditingController(
      text: opp != null ? opp.minBudget.toStringAsFixed(0) : '300',
    );
    _targetAmountController = TextEditingController(
      text: opp != null ? opp.targetAmount.toStringAsFixed(0) : '10000',
    );
    _descriptionController =
        TextEditingController(text: opp?.description ?? '');
    _officialSourceController =
        TextEditingController(text: opp?.officialSourceUrl ?? '');

    if (opp != null) {
      if (_categories.contains(opp.category)) {
        _selectedCategory = opp.category;
      }
      if (_riskLevels.contains(opp.riskLevel)) {
        _selectedRiskLevel = opp.riskLevel;
      }
      if (_experienceLevels.contains(opp.experienceLevel)) {
        _selectedExperienceLevel = opp.experienceLevel;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minBudgetController.dispose();
    _targetAmountController.dispose();
    _descriptionController.dispose();
    _officialSourceController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final isEditing = widget.existingOpportunity != null;
    final minBudget = double.tryParse(_minBudgetController.text.trim()) ?? 300.0;
    final targetAmount =
        double.tryParse(_targetAmountController.text.trim()) ?? 10000.0;

    final opp = Opportunity(
      id: widget.existingOpportunity?.id ?? '',
      companyId: widget.existingOpportunity?.companyId,
      title: _titleController.text.trim(),
      category: _selectedCategory,
      minBudget: minBudget,
      targetAmount: targetAmount,
      riskLevel: _selectedRiskLevel,
      experienceLevel: _selectedExperienceLevel,
      description: _descriptionController.text.trim(),
      officialSourceUrl: _officialSourceController.text.trim().isEmpty
          ? null
          : _officialSourceController.text.trim(),
      status: widget.existingOpportunity?.status ??
          (widget.isCompanySubmission ? 'pending' : 'approved'),
    );

    final success = isEditing
        ? await OpportunityService.updateOpportunity(opp)
        : await OpportunityService.createOpportunity(opp);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.of(context).pop();
        widget.onSaved();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'تم تحديث بيانات الفرصة بنجاح!'
                  : (widget.isCompanySubmission
                      ? 'تم إرسال الفرصة بنجاح! ستظهر على التطبيق فور مراجعتها واعتمادها من الإدارة.'
                      : 'تم إنشاء الفرصة ونشرها بنجاح!'),
            ),
            backgroundColor: AppColors.ink,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر حفظ الفرصة، يرجى التحقق من الاتصال.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingOpportunity != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.hairline,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),

          // الرأس
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'تعديل بيانات الفرصة' : 'إنشاء فرصة جديدة',
                  style: AppTypography.heading3,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(),

          // حقول الإدخال
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. اسم الفرصة
                    AppTextField(
                      label: 'اسم الفرصة الاستثمارية',
                      hint: 'مثال: صندوق النمو للتجارة الإلكترونية',
                      controller: _titleController,
                      prefixIcon: const Icon(Icons.title_rounded, size: 20),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'اسم الفرصة مطلوب';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 2. القطاع
                    Text('القطاع', style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = cat),
                          selectedColor: AppColors.ink,
                          labelStyle: TextStyle(
                            color: isSel
                                ? AppColors.onPrimary
                                : AppColors.textMuted,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                          backgroundColor: AppColors.field,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 3. الحد الأدنى للميزانية والمبلغ الإجمالي
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'الحد الأدنى للميزانية (\$)',
                            hint: 'مثال: 300',
                            controller: _minBudgetController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.attach_money_rounded,
                                size: 20),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'الميزانية مطلوبة';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppTextField(
                            label: 'المبلغ المستهدف (\$)',
                            hint: 'مثال: 10000',
                            controller: _targetAmountController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.monetization_on_outlined,
                                size: 20),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 4. مستوى المخاطرة
                    Text('مستوى المخاطرة', style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: _riskLevels.map((risk) {
                        final isSel = _selectedRiskLevel == risk;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Center(child: Text(risk)),
                              selected: isSel,
                              onSelected: (_) =>
                                  setState(() => _selectedRiskLevel = risk),
                              selectedColor: AppColors.ink,
                              labelStyle: TextStyle(
                                color: isSel
                                    ? AppColors.onPrimary
                                    : AppColors.textMuted,
                                fontWeight:
                                    isSel ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              backgroundColor: AppColors.field,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 5. مستوى الخبرة المطلوبة
                    Text('مستوى الخبرة المطلوبة', style: AppTypography.label),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: _experienceLevels.map((exp) {
                        final isSel = _selectedExperienceLevel == exp;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Center(child: Text(exp)),
                              selected: isSel,
                              onSelected: (_) =>
                                  setState(() => _selectedExperienceLevel = exp),
                              selectedColor: AppColors.ink,
                              labelStyle: TextStyle(
                                color: isSel
                                    ? AppColors.onPrimary
                                    : AppColors.textMuted,
                                fontWeight:
                                    isSel ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              backgroundColor: AppColors.field,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 6. روابط المصادر الرسمية والتراخيص
                    AppTextField(
                      label: 'رابط المصدر الرسمي أو الترخيص (اختياري)',
                      hint: 'https://example.com/license',
                      controller: _officialSourceController,
                      keyboardType: TextInputType.url,
                      prefixIcon: const Icon(Icons.link_rounded, size: 20),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 7. الوصف
                    AppTextField(
                      label: 'وصف الفرصة والتفاصيل',
                      hint: 'اكتب وصفاً مفصلاً وموثوقاً عن الفرصة وأهدافها...',
                      controller: _descriptionController,
                      maxLines: 4,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'الوصف مطلوب لتأكيد موثوقية الفرصة';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // زر الحفظ والنشر
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _handleSave,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Icon(Icons.check_circle_rounded, size: 20),
                        label: Text(
                          _isSaving
                              ? 'جاري الحفظ...'
                              : (isEditing
                                  ? 'تحديث بيانات الفرصة'
                                  : 'إنشاء الفرصة ونشرها'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
