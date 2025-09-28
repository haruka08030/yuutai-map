// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_benefit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserBenefit _$UserBenefitFromJson(Map<String, dynamic> json) => _UserBenefit(
  id: json['id'] as String,
  title: json['title'] as String,
  brandId: json['brandId'] as String?,
  companyId: json['companyId'] as String?,
  benefitText: json['benefitText'] as String?,
  notes: json['notes'] as String?,
  notifyBeforeDays: (json['notifyBeforeDays'] as num?)?.toInt(),
  notifyAtHour: (json['notifyAtHour'] as num?)?.toInt(),
  expireOn: json['expireOn'] == null
      ? null
      : DateTime.parse(json['expireOn'] as String),
  isUsed: json['isUsed'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UserBenefitToJson(_UserBenefit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'brandId': instance.brandId,
      'companyId': instance.companyId,
      'benefitText': instance.benefitText,
      'notes': instance.notes,
      'notifyBeforeDays': instance.notifyBeforeDays,
      'notifyAtHour': instance.notifyAtHour,
      'expireOn': instance.expireOn?.toIso8601String(),
      'isUsed': instance.isUsed,
      'tags': instance.tags,
    };
