// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_benefit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserBenefit _$UserBenefitFromJson(Map<String, dynamic> json) => _UserBenefit(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  companyId: json['company_id'] as String,
  companyName: json['company_name'] as String?,
  benefitDetails: json['benefit_details'] as String,
  expirationDate: _dtFromJson(json['expiration_date']),
  isUsed: json['is_used'] as bool? ?? false,
  memo: json['memo'] as String?,
);

Map<String, dynamic> _$UserBenefitToJson(_UserBenefit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'benefit_details': instance.benefitDetails,
      'expiration_date': _dtToJson(instance.expirationDate),
      'is_used': instance.isUsed,
      'memo': instance.memo,
    };
