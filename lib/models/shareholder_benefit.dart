import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory ShareholderBenefit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShareholderBenefit(
      id: doc.id,
      companyId: data['company_id'],
      benefitDetails: data['benefit_details'],
      expirationDate: (data['expiration_date'] as Timestamp).toDate(),
      isUsed: data['is_used'] ?? false,
    );
  }
}
