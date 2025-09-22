class Company {
  final String id;
  final String name;
  final int? code; // 証券コード等は数値で保持（null許容）

  Company({required this.id, required this.name, this.code});

  // Supabase用のファクトリーメソッド
  factory Company.fromSupabase(Map<String, dynamic> data) {
    // Supabaseでは通常 id フィールドがある
    final dynamic rawId = data['id'];
    final String safeId = rawId?.toString() ?? '';

    // name が int で入ってても toString で丸める
    final String safeName = (data['name'] ?? '').toString();

    // code は int or String どちらでも受けて int? にする
    final dynamic rawCode = data['code'];
    final int? safeCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    return Company(id: safeId, name: safeName, code: safeCode);
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'code': code,
  };
}
