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

 String get id;// UUID
 String get title;// 企業名（表示用）
 String? get brandId; String? get companyId; String? get benefitText;// 優待内容（3000円分など）
 String? get notes;// 自由記入メモ
 int? get notifyBeforeDays;// 期限の何日前に通知するか（null=デフォルト）
 int? get notifyAtHour;// 通知する時刻（時のみ、0-23, null=9時）
 DateTime? get expireOn;// 期限日（JST基準）
 bool get isUsed;// 使用済み
 List<String> get tags;
/// Create a copy of UsersYuutai
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersYuutaiCopyWith<UsersYuutai> get copyWith => _$UsersYuutaiCopyWithImpl<UsersYuutai>(this as UsersYuutai, _$identity);

  /// Serializes this UsersYuutai to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersYuutai&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.benefitText, benefitText) || other.benefitText == benefitText)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.notifyBeforeDays, notifyBeforeDays) || other.notifyBeforeDays == notifyBeforeDays)&&(identical(other.notifyAtHour, notifyAtHour) || other.notifyAtHour == notifyAtHour)&&(identical(other.expireOn, expireOn) || other.expireOn == expireOn)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,brandId,companyId,benefitText,notes,notifyBeforeDays,notifyAtHour,expireOn,isUsed,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'UsersYuutai(id: $id, title: $title, brandId: $brandId, companyId: $companyId, benefitText: $benefitText, notes: $notes, notifyBeforeDays: $notifyBeforeDays, notifyAtHour: $notifyAtHour, expireOn: $expireOn, isUsed: $isUsed, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $UsersYuutaiCopyWith<$Res>  {
  factory $UsersYuutaiCopyWith(UsersYuutai value, $Res Function(UsersYuutai) _then) = _$UsersYuutaiCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? brandId, String? companyId, String? benefitText, String? notes, int? notifyBeforeDays, int? notifyAtHour, DateTime? expireOn, bool isUsed, List<String> tags
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? brandId = freezed,Object? companyId = freezed,Object? benefitText = freezed,Object? notes = freezed,Object? notifyBeforeDays = freezed,Object? notifyAtHour = freezed,Object? expireOn = freezed,Object? isUsed = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,benefitText: freezed == benefitText ? _self.benefitText : benefitText // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,notifyBeforeDays: freezed == notifyBeforeDays ? _self.notifyBeforeDays : notifyBeforeDays // ignore: cast_nullable_to_non_nullable
as int?,notifyAtHour: freezed == notifyAtHour ? _self.notifyAtHour : notifyAtHour // ignore: cast_nullable_to_non_nullable
as int?,expireOn: freezed == expireOn ? _self.expireOn : expireOn // ignore: cast_nullable_to_non_nullable
as DateTime?,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? brandId,  String? companyId,  String? benefitText,  String? notes,  int? notifyBeforeDays,  int? notifyAtHour,  DateTime? expireOn,  bool isUsed,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersYuutai() when $default != null:
return $default(_that.id,_that.title,_that.brandId,_that.companyId,_that.benefitText,_that.notes,_that.notifyBeforeDays,_that.notifyAtHour,_that.expireOn,_that.isUsed,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? brandId,  String? companyId,  String? benefitText,  String? notes,  int? notifyBeforeDays,  int? notifyAtHour,  DateTime? expireOn,  bool isUsed,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _UsersYuutai():
return $default(_that.id,_that.title,_that.brandId,_that.companyId,_that.benefitText,_that.notes,_that.notifyBeforeDays,_that.notifyAtHour,_that.expireOn,_that.isUsed,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? brandId,  String? companyId,  String? benefitText,  String? notes,  int? notifyBeforeDays,  int? notifyAtHour,  DateTime? expireOn,  bool isUsed,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _UsersYuutai() when $default != null:
return $default(_that.id,_that.title,_that.brandId,_that.companyId,_that.benefitText,_that.notes,_that.notifyBeforeDays,_that.notifyAtHour,_that.expireOn,_that.isUsed,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsersYuutai implements UsersYuutai {
  const _UsersYuutai({required this.id, required this.title, this.brandId, this.companyId, this.benefitText, this.notes, this.notifyBeforeDays, this.notifyAtHour, this.expireOn, this.isUsed = false, final  List<String> tags = const []}): _tags = tags;
  factory _UsersYuutai.fromJson(Map<String, dynamic> json) => _$UsersYuutaiFromJson(json);

@override final  String id;
// UUID
@override final  String title;
// 企業名（表示用）
@override final  String? brandId;
@override final  String? companyId;
@override final  String? benefitText;
// 優待内容（3000円分など）
@override final  String? notes;
// 自由記入メモ
@override final  int? notifyBeforeDays;
// 期限の何日前に通知するか（null=デフォルト）
@override final  int? notifyAtHour;
// 通知する時刻（時のみ、0-23, null=9時）
@override final  DateTime? expireOn;
// 期限日（JST基準）
@override@JsonKey() final  bool isUsed;
// 使用済み
 final  List<String> _tags;
// 使用済み
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersYuutai&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.benefitText, benefitText) || other.benefitText == benefitText)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.notifyBeforeDays, notifyBeforeDays) || other.notifyBeforeDays == notifyBeforeDays)&&(identical(other.notifyAtHour, notifyAtHour) || other.notifyAtHour == notifyAtHour)&&(identical(other.expireOn, expireOn) || other.expireOn == expireOn)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,brandId,companyId,benefitText,notes,notifyBeforeDays,notifyAtHour,expireOn,isUsed,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'UsersYuutai(id: $id, title: $title, brandId: $brandId, companyId: $companyId, benefitText: $benefitText, notes: $notes, notifyBeforeDays: $notifyBeforeDays, notifyAtHour: $notifyAtHour, expireOn: $expireOn, isUsed: $isUsed, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$UsersYuutaiCopyWith<$Res> implements $UsersYuutaiCopyWith<$Res> {
  factory _$UsersYuutaiCopyWith(_UsersYuutai value, $Res Function(_UsersYuutai) _then) = __$UsersYuutaiCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? brandId, String? companyId, String? benefitText, String? notes, int? notifyBeforeDays, int? notifyAtHour, DateTime? expireOn, bool isUsed, List<String> tags
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? brandId = freezed,Object? companyId = freezed,Object? benefitText = freezed,Object? notes = freezed,Object? notifyBeforeDays = freezed,Object? notifyAtHour = freezed,Object? expireOn = freezed,Object? isUsed = null,Object? tags = null,}) {
  return _then(_UsersYuutai(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,benefitText: freezed == benefitText ? _self.benefitText : benefitText // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,notifyBeforeDays: freezed == notifyBeforeDays ? _self.notifyBeforeDays : notifyBeforeDays // ignore: cast_nullable_to_non_nullable
as int?,notifyAtHour: freezed == notifyAtHour ? _self.notifyAtHour : notifyAtHour // ignore: cast_nullable_to_non_nullable
as int?,expireOn: freezed == expireOn ? _self.expireOn : expireOn // ignore: cast_nullable_to_non_nullable
as DateTime?,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
