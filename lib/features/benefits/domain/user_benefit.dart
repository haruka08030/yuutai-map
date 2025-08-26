import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_benefit.freezed.dart';
part 'user_benefit.g.dart';

@freezed
class UserBenefit with _$UserBenefit {
  const factory UserBenefit({
    required String id,
    required String userId,
    required String companyCode,
    required String companyName,
    required String benefitDetails,
    required DateTime expirationDate,
    @Default(false) bool isUsed,
  }) = _UserBenefit;

  factory UserBenefit.fromJson(Map<String, dynamic> json) =>
      _$UserBenefitFromJson(json);
}
