import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id; // Firestoreのdoc.idを使う（常にString）
  final String name;
  final int? code; // 証券コード等は数値で保持（null許容）

  Company({required this.id, required this.name, this.code});

  // QueryDocumentSnapshot でも DocumentSnapshot でもOK
  factory Company.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};

    // たとえ data['id'] が int/String でも String に寄せる。無ければ doc.id
    final dynamic rawId = data.containsKey('id') ? data['id'] : doc.id;
    final String safeId = rawId?.toString() ?? doc.id;

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
    // 保存時も doc.id を使う方針。code は別フィールドで保持
    'name': name,
    'code': code,
  };
}
