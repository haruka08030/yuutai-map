import 'package:freezed_annotation/freezed_annotation.dart';
part 'users_yuutai.freezed.dart';
part 'users_yuutai.g.dart';

@freezed
abstract class UsersYuutai with _$UsersYuutai {
  @JsonSerializable(fieldRename: FieldRename.snake) 
  const factory UsersYuutai({
    required String id,
    required String title,
    String? brandId,
    String? companyId,
    String? benefitText,
    String? notes,
    int? notifyBeforeDays,
    int? notifyAtHour,
    DateTime? expireOn,
    @Default(false) bool isUsed,
    @Default([]) List<String> tags,
  }) = _UsersYuutai;

  factory UsersYuutai.fromJson(Map<String, dynamic> json) =>
      _$UsersYuutaiFromJson(json);
}