class CompanyProfile {
  final String id;
  final String companyName;
  final String crNumber;
  final String representativeName;
  final String phone;
  final bool isVerified;
  final DateTime? createdAt;

  const CompanyProfile({
    required this.id,
    required this.companyName,
    required this.crNumber,
    required this.representativeName,
    required this.phone,
    required this.isVerified,
    this.createdAt,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      crNumber: json['cr_number'] as String? ?? '',
      representativeName: json['representative_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'cr_number': crNumber,
      'representative_name': representativeName,
      'phone': phone,
      'is_verified': isVerified,
    };
  }

  CompanyProfile copyWith({
    String? id,
    String? companyName,
    String? crNumber,
    String? representativeName,
    String? phone,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return CompanyProfile(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      crNumber: crNumber ?? this.crNumber,
      representativeName: representativeName ?? this.representativeName,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
