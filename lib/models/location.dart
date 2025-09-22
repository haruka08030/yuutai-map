class Location {
  final String id;
  final String address;
  final double latitude;
  final double longitude;
  final String? companyId; // Add company reference for Supabase

  Location({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.companyId,
  });

  factory Location.fromSupabase(Map<String, dynamic> data) {
    return Location(
      id: data['id']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      companyId: data['company_id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'company_id': companyId,
  };
}
