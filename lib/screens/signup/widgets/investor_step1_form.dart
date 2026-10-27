import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_widgets.dart';

class InvestorStep1Form extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const InvestorStep1Form({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'الاسم الثلاثي',
          hint: 'مثال: محمد عبدالله الشمري',
          controller: nameController,
          prefixIcon: const Icon(
            Icons.person_outline,
            size: 20,
            color: AppColors.textMuted,
          ),
          validator: (val) => (val == null || val.trim().isEmpty)
              ? 'يرجى إدخال الاسم الثلاثي'
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'رقم الجوال',
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
