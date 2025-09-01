import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_benefit.freezed.dart';
part 'user_benefit.g.dart';

@freezed
abstract class UserBenefit with _$UserBenefit {
  const factory UserBenefit({
    required String id, // UUID
    required String title, // 企業名（表示用）
    String? brandId,
    String? companyId,
    String? benefitText, // 優待内容（3000円分など）
    String? notes, // 自由記入メモ
    DateTime? expireOn, // 期限日（JST基準）
    @Default(false) bool isUsed, // 使用済み
    @Default([]) List<String> tags,
  }) = _UserBenefit;

  factory UserBenefit.fromJson(Map<String, dynamic> json) =>
      _$UserBenefitFromJson(json);
}
