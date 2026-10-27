import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_widgets.dart';

class NewOpportunityModal extends StatefulWidget {
  const NewOpportunityModal({super.key});

  @override
  State<NewOpportunityModal> createState() => _NewOpportunityModalState();
}

class _NewOpportunityModalState extends State<NewOpportunityModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _returnController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _returnController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم رفع طلب التمويل بنجاح وسيتم تدقيقه من الإدارة.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        decoration: const BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.hairline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'طرح فرصة تمويلية جديدة.',
                  style: AppTypography.heading3,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'أدخل تفاصيل الحملة لتقديمها لفريق الاعتماد المالي.',
                  style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'عنوان الفرصة / المشروع',
                  hint: 'مثال: تمويل توسعة المستودعات اللوجستية',
                  controller: _titleController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'يرجى إدخال العنوان'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'المبلغ المستهدف (ر.س)',
                        hint: '1,000,000',
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'المبلغ مطلوب'
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'العائد المتوقع (%)',
                        hint: '15.5%',
                        keyboardType: TextInputType.number,
                        controller: _returnController,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'العائد مطلوب'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'مدة التمويل (بالأشهر)',
                  hint: '12 شهراً',
                  keyboardType: TextInputType.number,
                  controller: _durationController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'المدة مطلوبة'
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppPrimaryButton(
                  label: 'تقديم للمراجعة والاعتماد.',
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
