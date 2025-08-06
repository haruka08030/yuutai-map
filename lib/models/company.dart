import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id;
  final String name;
  final String code;

  Company({required this.id, required this.name, required this.code});

  factory Company.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Company(
      id: doc.id,
      name: data['company_name'],
      code: data['company_code'],
    );
  }
}
