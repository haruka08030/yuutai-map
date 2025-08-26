class Company {
  final String id;
  final String name;
  final int? code;

  Company({required this.id, required this.name, this.code});

  factory Company.fromMap(Map<String, dynamic> data) {
    return Company(
      id: data['id'] as String,
      name: data['name'] as String,
      code: data['code'] as int?,
    );
  }
}
