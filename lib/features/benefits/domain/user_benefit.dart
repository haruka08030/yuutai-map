import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_benefit.freezed.dart';
part 'user_benefit.g.dart';

@freezed
class UserBenefit with _$UserBenefit {
  const factory UserBenefit({
    required String id,
    required String userId,
    required String companyId, // ← これが無くて他所で落ちてた
    String? companyName,
    required String benefitDetails,
    required DateTime expirationDate,
    @Default(false) bool isUsed,
    String? memo,
    // tags は DB では別テーブル運用予定なので JSON は無視して OK
    @Default(<Tag>[]) List<Tag> tags,
  }) = _UserBenefit;

  factory UserBenefit.fromJson(Map<String, dynamic> json) =>
      _$UserBenefitFromJson(json);
}

DateTime _dtFromJson(dynamic v) =>
    v is String ? DateTime.parse(v) : (v as DateTime);

dynamic _dtToJson(DateTime v) => v.toIso8601String();

// 最小の Tag（警告/依存崩れ回避用）
class Tag {
  final String id;
  final String name;
  const Tag({required this.id, required this.name});
}
