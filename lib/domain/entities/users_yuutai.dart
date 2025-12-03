import 'package:freezed_annotation/freezed_annotation.dart';
part 'users_yuutai.freezed.dart';
part 'users_yuutai.g.dart';

@freezed
class UsersYuutai with _$UsersYuutai {
  const factory UsersYuutai({
    int? id,
    @JsonKey(name: 'company_name') @Default('') String companyName,
    @JsonKey(name: 'company_id') int? companyId,
    @JsonKey(name: 'benefit_detail') String? benefitDetail,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    @Default('active') String status,
    @JsonKey(name: 'alert_enabled') @Default(false) bool alertEnabled,
  }) = _UsersYuutai;

  factory UsersYuutai.fromJson(Map<String, dynamic> json) =>
      _$UsersYuutaiFromJson(json);
}