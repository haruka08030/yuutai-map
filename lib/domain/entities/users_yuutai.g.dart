// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_yuutai.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsersYuutai _$UsersYuutaiFromJson(Map<String, dynamic> json) => _UsersYuutai(
  id: (json['id'] as num?)?.toInt(),
  companyName: json['company_name'] as String? ?? '',
  companyId: (json['company_id'] as num?)?.toInt(),
  benefitDetail: json['benefit_detail'] as String?,
  expiryDate: json['expiry_date'] == null
      ? null
      : DateTime.parse(json['expiry_date'] as String),
  status:
      $enumDecodeNullable(_$BenefitStatusEnumMap, json['status']) ??
      BenefitStatus.active,
  alertEnabled: json['alert_enabled'] as bool? ?? false,
  notes: json['notes'] as String?,
  notifyDaysBefore: (json['notify_days_before'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$UsersYuutaiToJson(_UsersYuutai instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'company_id': instance.companyId,
      'benefit_detail': instance.benefitDetail,
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'status': _$BenefitStatusEnumMap[instance.status]!,
      'alert_enabled': instance.alertEnabled,
      'notes': instance.notes,
      'notify_days_before': instance.notifyDaysBefore,
    };

const _$BenefitStatusEnumMap = {
  BenefitStatus.active: 'active',
  BenefitStatus.used: 'used',
  BenefitStatus.expired: 'expired',
};
