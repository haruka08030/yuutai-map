import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String id;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Location(
      id: doc.id,
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
}
