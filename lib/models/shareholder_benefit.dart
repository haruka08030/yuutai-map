class ShareholderBenefit {
  final String id;
  final String companyId;
  final String benefitDetails;
  final DateTime expirationDate;
  final bool isUsed;

  ShareholderBenefit({
    required this.id,
    required this.companyId,
    required this.benefitDetails,
    required this.expirationDate,
    required this.isUsed,
  });

  factory ShareholderBenefit.fromSupabase(Map<String, dynamic> data) {
    return ShareholderBenefit(
      id: data['id']?.toString() ?? '',
      companyId: data['company_id']?.toString() ?? '',
      benefitDetails: data['benefit_details']?.toString() ?? '',
      expirationDate: DateTime.parse(data['expiration_date'] ?? DateTime.now().toIso8601String()),
      isUsed: data['is_used'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'company_id': companyId,
    'benefit_details': benefitDetails,
    'expiration_date': expirationDate.toIso8601String(),
    'is_used': isUsed,
  };
}
