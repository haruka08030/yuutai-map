import 'package:freezed_annotation/freezed_annotation.dart';
part 'users_yuutai.freezed.dart';
part 'users_yuutai.g.dart';

@freezed
abstract class UsersYuutai with _$UsersYuutai {
  const factory UsersYuutai({
    required String id, // UUID
    required String title, // 企業名（表示用）
    String? brandId,
    String? companyId,
    String? benefitText, // 優待内容（3000円分など）
    String? notes, // 自由記入メモ
    int? notifyBeforeDays, // 期限の何日前に通知するか（null=デフォルト）
    int? notifyAtHour, // 通知する時刻（時のみ、0-23, null=9時）
    DateTime? expireOn, // 期限日（JST基準）
    @Default(false) bool isUsed, // 使用済み
    @Default([]) List<String> tags,
  }) = _UsersYuutai;

  factory UsersYuutai.fromJson(Map<String, dynamic> json) =>
      _$UsersYuutaiFromJson(json);
}