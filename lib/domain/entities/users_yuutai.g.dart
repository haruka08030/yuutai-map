// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_yuutai.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsersYuutai _$UsersYuutaiFromJson(Map<String, dynamic> json) => _UsersYuutai(
  id: json['id'] as String,
  title: json['title'] as String,
  brandId: json['brand_id'] as String?,
  companyId: json['company_id'] as String?,
  benefitText: json['benefit_text'] as String?,
  notes: json['notes'] as String?,
  notifyBeforeDays: (json['notify_before_days'] as num?)?.toInt(),
  notifyAtHour: (json['notify_at_hour'] as num?)?.toInt(),
  expireOn: json['expire_on'] == null
      ? null
      : DateTime.parse(json['expire_on'] as String),
  isUsed: json['is_used'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UsersYuutaiToJson(_UsersYuutai instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'brand_id': instance.brandId,
      'company_id': instance.companyId,
      'benefit_text': instance.benefitText,
      'notes': instance.notes,
      'notify_before_days': instance.notifyBeforeDays,
      'notify_at_hour': instance.notifyAtHour,
      'expire_on': instance.expireOn?.toIso8601String(),
      'is_used': instance.isUsed,
      'tags': instance.tags,
    };
