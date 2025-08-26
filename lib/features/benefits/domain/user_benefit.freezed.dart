// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_benefit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserBenefit {

 String get id; String get userId; String get companyCode; String get companyName; String get benefitDetails; DateTime get expirationDate; bool get isUsed;
/// Create a copy of UserBenefit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserBenefitCopyWith<UserBenefit> get copyWith => _$UserBenefitCopyWithImpl<UserBenefit>(this as UserBenefit, _$identity);

  /// Serializes this UserBenefit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserBenefit&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.companyCode, companyCode) || other.companyCode == companyCode)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.benefitDetails, benefitDetails) || other.benefitDetails == benefitDetails)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,companyCode,companyName,benefitDetails,expirationDate,isUsed);

@override
String toString() {
  return 'UserBenefit(id: $id, userId: $userId, companyCode: $companyCode, companyName: $companyName, benefitDetails: $benefitDetails, expirationDate: $expirationDate, isUsed: $isUsed)';
}


}

/// @nodoc
abstract mixin class $UserBenefitCopyWith<$Res>  {
  factory $UserBenefitCopyWith(UserBenefit value, $Res Function(UserBenefit) _then) = _$UserBenefitCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String companyCode, String companyName, String benefitDetails, DateTime expirationDate, bool isUsed
});




}
/// @nodoc
class _$UserBenefitCopyWithImpl<$Res>
    implements $UserBenefitCopyWith<$Res> {
  _$UserBenefitCopyWithImpl(this._self, this._then);

  final UserBenefit _self;
  final $Res Function(UserBenefit) _then;

/// Create a copy of UserBenefit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? companyCode = null,Object? companyName = null,Object? benefitDetails = null,Object? expirationDate = null,Object? isUsed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,companyCode: null == companyCode ? _self.companyCode : companyCode // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,benefitDetails: null == benefitDetails ? _self.benefitDetails : benefitDetails // ignore: cast_nullable_to_non_nullable
as String,expirationDate: null == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserBenefit].
extension UserBenefitPatterns on UserBenefit {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserBenefit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserBenefit() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserBenefit value)  $default,){
final _that = this;
switch (_that) {
case _UserBenefit():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserBenefit value)?  $default,){
final _that = this;
switch (_that) {
case _UserBenefit() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String companyCode,  String companyName,  String benefitDetails,  DateTime expirationDate,  bool isUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserBenefit() when $default != null:
return $default(_that.id,_that.userId,_that.companyCode,_that.companyName,_that.benefitDetails,_that.expirationDate,_that.isUsed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String companyCode,  String companyName,  String benefitDetails,  DateTime expirationDate,  bool isUsed)  $default,) {final _that = this;
switch (_that) {
case _UserBenefit():
return $default(_that.id,_that.userId,_that.companyCode,_that.companyName,_that.benefitDetails,_that.expirationDate,_that.isUsed);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String companyCode,  String companyName,  String benefitDetails,  DateTime expirationDate,  bool isUsed)?  $default,) {final _that = this;
switch (_that) {
case _UserBenefit() when $default != null:
return $default(_that.id,_that.userId,_that.companyCode,_that.companyName,_that.benefitDetails,_that.expirationDate,_that.isUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserBenefit implements UserBenefit {
  const _UserBenefit({required this.id, required this.userId, required this.companyCode, required this.companyName, required this.benefitDetails, required this.expirationDate, this.isUsed = false});
  factory _UserBenefit.fromJson(Map<String, dynamic> json) => _$UserBenefitFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String companyCode;
@override final  String companyName;
@override final  String benefitDetails;
@override final  DateTime expirationDate;
@override@JsonKey() final  bool isUsed;

/// Create a copy of UserBenefit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserBenefitCopyWith<_UserBenefit> get copyWith => __$UserBenefitCopyWithImpl<_UserBenefit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserBenefitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserBenefit&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.companyCode, companyCode) || other.companyCode == companyCode)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.benefitDetails, benefitDetails) || other.benefitDetails == benefitDetails)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,companyCode,companyName,benefitDetails,expirationDate,isUsed);

@override
String toString() {
  return 'UserBenefit(id: $id, userId: $userId, companyCode: $companyCode, companyName: $companyName, benefitDetails: $benefitDetails, expirationDate: $expirationDate, isUsed: $isUsed)';
}


}

/// @nodoc
abstract mixin class _$UserBenefitCopyWith<$Res> implements $UserBenefitCopyWith<$Res> {
  factory _$UserBenefitCopyWith(_UserBenefit value, $Res Function(_UserBenefit) _then) = __$UserBenefitCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String companyCode, String companyName, String benefitDetails, DateTime expirationDate, bool isUsed
});




}
/// @nodoc
class __$UserBenefitCopyWithImpl<$Res>
    implements _$UserBenefitCopyWith<$Res> {
  __$UserBenefitCopyWithImpl(this._self, this._then);

  final _UserBenefit _self;
  final $Res Function(_UserBenefit) _then;

/// Create a copy of UserBenefit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? companyCode = null,Object? companyName = null,Object? benefitDetails = null,Object? expirationDate = null,Object? isUsed = null,}) {
  return _then(_UserBenefit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,companyCode: null == companyCode ? _self.companyCode : companyCode // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,benefitDetails: null == benefitDetails ? _self.benefitDetails : benefitDetails // ignore: cast_nullable_to_non_nullable
as String,expirationDate: null == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
