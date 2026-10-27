class Opportunity {
  final String id;
  final String? companyId;
  final String? companyName;
  final String title;
  final String category;
  final String description;
  final double minBudget;
  final double targetAmount;
  final double raisedAmount;
  final double expectedReturn;
  final int durationMonths;
  final String riskLevel; // منخفض، متوسط، مرتفع
  final String experienceLevel; // منخفض، متوسط، مرتفع
  final String? officialSourceUrl;
  final String status; // pending, approved, rejected, completed
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Opportunity({
    required this.id,
    this.companyId,
    this.companyName,
    required this.title,
    required this.category,
    this.description = '',
    this.minBudget = 300.0,
    this.targetAmount = 10000.0,
    this.raisedAmount = 0.0,
    this.expectedReturn = 12.0,
    this.durationMonths = 12,
    this.riskLevel = 'متوسط',
    this.experienceLevel = 'متوسط',
    this.officialSourceUrl,
    this.status = 'pending',
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    // If company profiles joined
    final profilesData = json['profiles'] as Map<String, dynamic>?;
    final compName = profilesData != null
        ? (profilesData['company_name'] as String? ??
            profilesData['full_name'] as String?)
        : null;

    return Opportunity(
      id: json['id'] as String? ?? '',
      companyId: json['company_id'] as String?,
      companyName: compName ?? json['company_name'] as String?,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'سوق مال',
      description: json['description'] as String? ?? '',
      minBudget: (json['min_budget'] as num?)?.toDouble() ?? 300.0,
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      raisedAmount: (json['raised_amount'] as num?)?.toDouble() ?? 0.0,
      expectedReturn: (json['expected_return'] as num?)?.toDouble() ?? 0.0,
      durationMonths: (json['duration_months'] as num?)?.toInt() ?? 12,
      riskLevel: json['risk_level'] as String? ?? 'متوسط',
      experienceLevel: json['experience_level'] as String? ?? 'متوسط',
      officialSourceUrl: json['official_source_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (companyId != null) 'company_id': companyId,
      'title': title,
      'category': category,
      'description': description,
      'min_budget': minBudget,
      'target_amount': targetAmount,
      'raised_amount': raisedAmount,
      'expected_return': expectedReturn,
      'duration_months': durationMonths,
      'risk_level': riskLevel,
      'experience_level': experienceLevel,
      'official_source_url': officialSourceUrl,
      'status': status,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Opportunity copyWith({
    String? id,
    String? companyId,
    String? companyName,
    String? title,
    String? category,
    String? description,
    double? minBudget,
    double? targetAmount,
    double? raisedAmount,
    double? expectedReturn,
    int? durationMonths,
    String? riskLevel,
    String? experienceLevel,
    String? officialSourceUrl,
    String? status,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Opportunity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      minBudget: minBudget ?? this.minBudget,
      targetAmount: targetAmount ?? this.targetAmount,
      raisedAmount: raisedAmount ?? this.raisedAmount,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      durationMonths: durationMonths ?? this.durationMonths,
      riskLevel: riskLevel ?? this.riskLevel,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      officialSourceUrl: officialSourceUrl ?? this.officialSourceUrl,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
