import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_widgets.dart';

class CompanyStep1Form extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController crNumberController;
  final TextEditingController representativeNameController;
  final TextEditingController phoneController;

  const CompanyStep1Form({
    super.key,
    required this.companyNameController,
    required this.crNumberController,
    required this.representativeNameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'اسم المنشأة / الشركة',
          hint: 'شركة التقنية المالية المحدودة',
          controller: companyNameController,
          prefixIcon: const Icon(
            Icons.business_outlined,
            size: 20,
            color: AppColors.textMuted,
          ),
          validator: (val) => (val == null || val.trim().isEmpty)
              ? 'يرجى إدخال اسم المنشأة أو الشركة'
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'رقم السجل التجاري (CR)',
          hint: '1010XXXXXX',
          controller: crNumberController,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(
            Icons.badge_outlined,
            size: 20,
            color: AppColors.textMuted,
          ),
          validator: (val) => (val == null || val.trim().isEmpty)
              ? 'يرجى إدخال رقم السجل التجاري'
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'اسم المفوض الرسمي',
          hint: 'مثال: أحمد خالد',
          controller: representativeNameController,
          prefixIcon: const Icon(
            Icons.person_outline,
            size: 20,
            color: AppColors.textMuted,
          ),
          validator: (val) => (val == null || val.trim().isEmpty)
              ? 'يرجى إدخال اسم المفوض الرسمي'
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'رقم جوال التواصل',
          hint: '05XXXXXXXX',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.phone_outlined,
            size: 20,
            color: AppColors.textMuted,
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'يرجى إدخال رقم الجوال';
            }
            if (val.trim().length < 9) {
              return 'رقم الجوال غير مكتمل';
            }
            return null;
          },
        ),
      ],
    );
  }
}
