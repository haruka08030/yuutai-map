// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_yuutai.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsersYuutai {

 int? get id;@JsonKey(name: 'company_name') String get companyName;@JsonKey(name: 'company_id') int? get companyId;@JsonKey(name: 'benefit_detail') String? get benefitDetail;@JsonKey(name: 'expiry_date') DateTime? get expiryDate; BenefitStatus get status;@JsonKey(name: 'alert_enabled') bool get alertEnabled; String? get notes;@JsonKey(name: 'notify_days_before') int? get notifyDaysBefore;
/// Create a copy of UsersYuutai
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersYuutaiCopyWith<UsersYuutai> get copyWith => _$UsersYuutaiCopyWithImpl<UsersYuutai>(this as UsersYuutai, _$identity);

  /// Serializes this UsersYuutai to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersYuutai&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.benefitDetail, benefitDetail) || other.benefitDetail == benefitDetail)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.alertEnabled, alertEnabled) || other.alertEnabled == alertEnabled)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.notifyDaysBefore, notifyDaysBefore) || other.notifyDaysBefore == notifyDaysBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,companyId,benefitDetail,expiryDate,status,alertEnabled,notes,notifyDaysBefore);

@override
String toString() {
  return 'UsersYuutai(id: $id, companyName: $companyName, companyId: $companyId, benefitDetail: $benefitDetail, expiryDate: $expiryDate, status: $status, alertEnabled: $alertEnabled, notes: $notes, notifyDaysBefore: $notifyDaysBefore)';
}


}

/// @nodoc
abstract mixin class $UsersYuutaiCopyWith<$Res>  {
  factory $UsersYuutaiCopyWith(UsersYuutai value, $Res Function(UsersYuutai) _then) = _$UsersYuutaiCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'company_id') int? companyId,@JsonKey(name: 'benefit_detail') String? benefitDetail,@JsonKey(name: 'expiry_date') DateTime? expiryDate, BenefitStatus status,@JsonKey(name: 'alert_enabled') bool alertEnabled, String? notes,@JsonKey(name: 'notify_days_before') int? notifyDaysBefore
});




}
/// @nodoc
class _$UsersYuutaiCopyWithImpl<$Res>
    implements $UsersYuutaiCopyWith<$Res> {
  _$UsersYuutaiCopyWithImpl(this._self, this._then);

  final UsersYuutai _self;
  final $Res Function(UsersYuutai) _then;

/// Create a copy of UsersYuutai
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? companyName = null,Object? companyId = freezed,Object? benefitDetail = freezed,Object? expiryDate = freezed,Object? status = null,Object? alertEnabled = null,Object? notes = freezed,Object? notifyDaysBefore = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int?,benefitDetail: freezed == benefitDetail ? _self.benefitDetail : benefitDetail // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BenefitStatus,alertEnabled: null == alertEnabled ? _self.alertEnabled : alertEnabled // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,notifyDaysBefore: freezed == notifyDaysBefore ? _self.notifyDaysBefore : notifyDaysBefore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersYuutai].
extension UsersYuutaiPatterns on UsersYuutai {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersYuutai value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersYuutai() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersYuutai value)  $default,){
final _that = this;
switch (_that) {
case _UsersYuutai():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersYuutai value)?  $default,){
final _that = this;
switch (_that) {
case _UsersYuutai() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'company_id')  int? companyId, @JsonKey(name: 'benefit_detail')  String? benefitDetail, @JsonKey(name: 'expiry_date')  DateTime? expiryDate,  BenefitStatus status, @JsonKey(name: 'alert_enabled')  bool alertEnabled,  String? notes, @JsonKey(name: 'notify_days_before')  int? notifyDaysBefore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersYuutai() when $default != null:
return $default(_that.id,_that.companyName,_that.companyId,_that.benefitDetail,_that.expiryDate,_that.status,_that.alertEnabled,_that.notes,_that.notifyDaysBefore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'company_id')  int? companyId, @JsonKey(name: 'benefit_detail')  String? benefitDetail, @JsonKey(name: 'expiry_date')  DateTime? expiryDate,  BenefitStatus status, @JsonKey(name: 'alert_enabled')  bool alertEnabled,  String? notes, @JsonKey(name: 'notify_days_before')  int? notifyDaysBefore)  $default,) {final _that = this;
switch (_that) {
case _UsersYuutai():
return $default(_that.id,_that.companyName,_that.companyId,_that.benefitDetail,_that.expiryDate,_that.status,_that.alertEnabled,_that.notes,_that.notifyDaysBefore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'company_name')  String companyName, @JsonKey(name: 'company_id')  int? companyId, @JsonKey(name: 'benefit_detail')  String? benefitDetail, @JsonKey(name: 'expiry_date')  DateTime? expiryDate,  BenefitStatus status, @JsonKey(name: 'alert_enabled')  bool alertEnabled,  String? notes, @JsonKey(name: 'notify_days_before')  int? notifyDaysBefore)?  $default,) {final _that = this;
switch (_that) {
case _UsersYuutai() when $default != null:
return $default(_that.id,_that.companyName,_that.companyId,_that.benefitDetail,_that.expiryDate,_that.status,_that.alertEnabled,_that.notes,_that.notifyDaysBefore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsersYuutai extends UsersYuutai {
  const _UsersYuutai({this.id, @JsonKey(name: 'company_name') this.companyName = '', @JsonKey(name: 'company_id') this.companyId, @JsonKey(name: 'benefit_detail') this.benefitDetail, @JsonKey(name: 'expiry_date') this.expiryDate, this.status = BenefitStatus.active, @JsonKey(name: 'alert_enabled') this.alertEnabled = false, this.notes, @JsonKey(name: 'notify_days_before') this.notifyDaysBefore}): super._();
  factory _UsersYuutai.fromJson(Map<String, dynamic> json) => _$UsersYuutaiFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'company_name') final  String companyName;
@override@JsonKey(name: 'company_id') final  int? companyId;
@override@JsonKey(name: 'benefit_detail') final  String? benefitDetail;
@override@JsonKey(name: 'expiry_date') final  DateTime? expiryDate;
@override@JsonKey() final  BenefitStatus status;
@override@JsonKey(name: 'alert_enabled') final  bool alertEnabled;
@override final  String? notes;
@override@JsonKey(name: 'notify_days_before') final  int? notifyDaysBefore;

/// Create a copy of UsersYuutai
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersYuutaiCopyWith<_UsersYuutai> get copyWith => __$UsersYuutaiCopyWithImpl<_UsersYuutai>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsersYuutaiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersYuutai&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.benefitDetail, benefitDetail) || other.benefitDetail == benefitDetail)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.alertEnabled, alertEnabled) || other.alertEnabled == alertEnabled)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.notifyDaysBefore, notifyDaysBefore) || other.notifyDaysBefore == notifyDaysBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,companyId,benefitDetail,expiryDate,status,alertEnabled,notes,notifyDaysBefore);

@override
String toString() {
  return 'UsersYuutai(id: $id, companyName: $companyName, companyId: $companyId, benefitDetail: $benefitDetail, expiryDate: $expiryDate, status: $status, alertEnabled: $alertEnabled, notes: $notes, notifyDaysBefore: $notifyDaysBefore)';
}


}

/// @nodoc
abstract mixin class _$UsersYuutaiCopyWith<$Res> implements $UsersYuutaiCopyWith<$Res> {
  factory _$UsersYuutaiCopyWith(_UsersYuutai value, $Res Function(_UsersYuutai) _then) = __$UsersYuutaiCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'company_name') String companyName,@JsonKey(name: 'company_id') int? companyId,@JsonKey(name: 'benefit_detail') String? benefitDetail,@JsonKey(name: 'expiry_date') DateTime? expiryDate, BenefitStatus status,@JsonKey(name: 'alert_enabled') bool alertEnabled, String? notes,@JsonKey(name: 'notify_days_before') int? notifyDaysBefore
});




}
/// @nodoc
class __$UsersYuutaiCopyWithImpl<$Res>
    implements _$UsersYuutaiCopyWith<$Res> {
  __$UsersYuutaiCopyWithImpl(this._self, this._then);

  final _UsersYuutai _self;
  final $Res Function(_UsersYuutai) _then;

/// Create a copy of UsersYuutai
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? companyName = null,Object? companyId = freezed,Object? benefitDetail = freezed,Object? expiryDate = freezed,Object? status = null,Object? alertEnabled = null,Object? notes = freezed,Object? notifyDaysBefore = freezed,}) {
  return _then(_UsersYuutai(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as int?,benefitDetail: freezed == benefitDetail ? _self.benefitDetail : benefitDetail // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BenefitStatus,alertEnabled: null == alertEnabled ? _self.alertEnabled : alertEnabled // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,notifyDaysBefore: freezed == notifyDaysBefore ? _self.notifyDaysBefore : notifyDaysBefore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
