import 'package:flutter_stock/features/benefits/domain/tag.dart';
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
    @Default(<Tag>[]) List<Tag> tags,
    // 任意のメモ。不要なら消してOK
    String? memo,
  }) = _UserBenefit;

  factory UserBenefit.fromJson(Map<String, dynamic> json) =>
      _$UserBenefitFromJson(json);

  @override
  // TODO: implement benefitDetails
  String get benefitDetails => throw UnimplementedError();

  @override
  // TODO: implement companyCode
  String get companyCode => throw UnimplementedError();

  @override
  // TODO: implement companyName
  String get companyName => throw UnimplementedError();

  @override
  // TODO: implement expirationDate
  DateTime get expirationDate => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isUsed
  bool get isUsed => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement userId
  String get userId => throw UnimplementedError();
}
