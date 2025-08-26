import 'package:freezed_annotation/freezed_annotation.dart';

part '../user_benefit.freezed.dart';
part '../user_benefit.g.dart';

@freezed
class UserBenefit with _$UserBenefit {
  const UserBenefit._();
  const factory UserBenefit({
    required String id,
    required String userId,
    String? companyCode,
    required String companyName,
    required String benefitDetails,
    required DateTime expirationDate,
    @Default(false) bool isUsed,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(<String>[]) List<String> tags,
  }) = _UserBenefit;

  factory UserBenefit.fromJson(Map<String, dynamic> json) =>
      _$UserBenefitFromJson(json);
  int get daysLeft => expirationDate.difference(DateTime.now()).inDays;
}
