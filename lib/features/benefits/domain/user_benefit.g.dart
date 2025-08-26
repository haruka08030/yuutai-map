// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_benefit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserBenefit _$UserBenefitFromJson(Map<String, dynamic> json) => _UserBenefit(
  id: json['id'] as String,
  userId: json['userId'] as String,
  companyCode: json['companyCode'] as String,
  companyName: json['companyName'] as String,
  benefitDetails: json['benefitDetails'] as String,
  expirationDate: DateTime.parse(json['expirationDate'] as String),
  isUsed: json['isUsed'] as bool? ?? false,
);

Map<String, dynamic> _$UserBenefitToJson(_UserBenefit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'companyCode': instance.companyCode,
      'companyName': instance.companyName,
      'benefitDetails': instance.benefitDetails,
      'expirationDate': instance.expirationDate.toIso8601String(),
      'isUsed': instance.isUsed,
    };
