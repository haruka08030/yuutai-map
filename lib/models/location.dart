class Location {
  final String id;
  final String name; // 店名（必要なければ削ってOK）
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> m) {
    return Location(
      id: m['id'] as String,
      name: (m['name'] ?? '') as String,
      address: (m['address'] ?? '') as String,
      latitude: (m['lat'] as num).toDouble(),
      longitude: (m['lng'] as num).toDouble(),
    );
  }
}
