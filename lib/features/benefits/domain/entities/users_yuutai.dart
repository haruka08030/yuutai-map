import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';

part 'users_yuutai.freezed.dart';
part 'users_yuutai.g.dart';

@freezed
abstract class UsersYuutai with _$UsersYuutai {
  const UsersYuutai._();

  const factory UsersYuutai({
    int? id,
    @JsonKey(name: 'company_name') @Default('') String companyName,
    @JsonKey(name: 'company_id') int? companyId,
    @JsonKey(name: 'benefit_detail') String? benefitDetail,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    @Default(BenefitStatus.active) BenefitStatus status,
    @JsonKey(name: 'alert_enabled') @Default(false) bool alertEnabled,
    String? notes,
    @JsonKey(name: 'notify_days_before') List<int>? notifyDaysBefore,
    @JsonKey(name: 'folder_id') String? folderId,
  }) = _UsersYuutai;

  factory UsersYuutai.fromJson(Map<String, dynamic> json) =>
      _$UsersYuutaiFromJson(json);
}
