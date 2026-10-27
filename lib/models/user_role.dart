enum UserRole {
  investor,
  company,
  admin;

  String get titleAr {
    switch (this) {
      case UserRole.investor:
        return 'مستثمر';
      case UserRole.company:
        return 'شركة / صاحب فرصة';
      case UserRole.admin:
        return 'مسؤول';
    }
  }

  String get titleEn {
    switch (this) {
      case UserRole.investor:
        return 'Investor';
      case UserRole.company:
        return 'Company';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get descriptionAr {
    switch (this) {
      case UserRole.investor:
        return 'استكشاف واستثمار في الفرص التمويلية المتاحة.';
      case UserRole.company:
        return 'طرح وإدارة الفرص الاستثمارية ومتابعة التمويل.';
      case UserRole.admin:
        return 'إدارة المنصة، التدقيق، وصلاحيات النظام.';
    }
  }
}
