class ShareholderBenefit {
  final String id;
  final String? companyId;
  final String benefitDetails;
  final DateTime expirationDate;
  final bool isUsed;
  final String? memo;

  ShareholderBenefit({
    required this.id,
    this.companyId,
    required this.benefitDetails,
    required this.expirationDate,
    required this.isUsed,
    this.memo,
  });

  ShareholderBenefit copyWith({
    String? id,
    String? companyId,
    String? benefitDetails,
    DateTime? expirationDate,
    bool? isUsed,
    String? memo,
  }) {
    return ShareholderBenefit(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      benefitDetails: benefitDetails ?? this.benefitDetails,
      expirationDate: expirationDate ?? this.expirationDate,
      isUsed: isUsed ?? this.isUsed,
      memo: memo ?? this.memo,
    );
  }
}
