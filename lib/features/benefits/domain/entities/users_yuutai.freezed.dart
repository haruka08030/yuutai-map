// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_yuutai.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UsersYuutai _$UsersYuutaiFromJson(Map<String, dynamic> json) {
  return _UsersYuutai.fromJson(json);
}

/// @nodoc
mixin _$UsersYuutai {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int? get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'benefit_detail')
  String? get benefitDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  BenefitStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'alert_enabled')
  bool get alertEnabled => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'notify_days_before')
  List<int>? get notifyDaysBefore => throw _privateConstructorUsedError;
  @JsonKey(name: 'folder_id')
  String? get folderId => throw _privateConstructorUsedError;

  /// Serializes this UsersYuutai to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsersYuutai
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsersYuutaiCopyWith<UsersYuutai> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersYuutaiCopyWith<$Res> {
  factory $UsersYuutaiCopyWith(
    UsersYuutai value,
    $Res Function(UsersYuutai) then,
  ) = _$UsersYuutaiCopyWithImpl<$Res, UsersYuutai>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'company_name') String companyName,
    @JsonKey(name: 'company_id') int? companyId,
    @JsonKey(name: 'benefit_detail') String? benefitDetail,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    BenefitStatus status,
    @JsonKey(name: 'alert_enabled') bool alertEnabled,
    String? notes,
    @JsonKey(name: 'notify_days_before') List<int>? notifyDaysBefore,
    @JsonKey(name: 'folder_id') String? folderId,
  });
}

/// @nodoc
class _$UsersYuutaiCopyWithImpl<$Res, $Val extends UsersYuutai>
    implements $UsersYuutaiCopyWith<$Res> {
  _$UsersYuutaiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersYuutai
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? companyName = null,
    Object? companyId = freezed,
    Object? benefitDetail = freezed,
    Object? expiryDate = freezed,
    Object? status = null,
    Object? alertEnabled = null,
    Object? notes = freezed,
    Object? notifyDaysBefore = freezed,
    Object? folderId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            companyId: freezed == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as int?,
            benefitDetail: freezed == benefitDetail
                ? _value.benefitDetail
                : benefitDetail // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BenefitStatus,
            alertEnabled: null == alertEnabled
                ? _value.alertEnabled
                : alertEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            notifyDaysBefore: freezed == notifyDaysBefore
                ? _value.notifyDaysBefore
                : notifyDaysBefore // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            folderId: freezed == folderId
                ? _value.folderId
                : folderId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsersYuutaiImplCopyWith<$Res>
    implements $UsersYuutaiCopyWith<$Res> {
  factory _$$UsersYuutaiImplCopyWith(
    _$UsersYuutaiImpl value,
    $Res Function(_$UsersYuutaiImpl) then,
  ) = __$$UsersYuutaiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'company_name') String companyName,
    @JsonKey(name: 'company_id') int? companyId,
    @JsonKey(name: 'benefit_detail') String? benefitDetail,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    BenefitStatus status,
    @JsonKey(name: 'alert_enabled') bool alertEnabled,
    String? notes,
    @JsonKey(name: 'notify_days_before') List<int>? notifyDaysBefore,
    @JsonKey(name: 'folder_id') String? folderId,
  });
}

/// @nodoc
class __$$UsersYuutaiImplCopyWithImpl<$Res>
    extends _$UsersYuutaiCopyWithImpl<$Res, _$UsersYuutaiImpl>
    implements _$$UsersYuutaiImplCopyWith<$Res> {
  __$$UsersYuutaiImplCopyWithImpl(
    _$UsersYuutaiImpl _value,
    $Res Function(_$UsersYuutaiImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersYuutai
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? companyName = null,
    Object? companyId = freezed,
    Object? benefitDetail = freezed,
    Object? expiryDate = freezed,
    Object? status = null,
    Object? alertEnabled = null,
    Object? notes = freezed,
    Object? notifyDaysBefore = freezed,
    Object? folderId = freezed,
  }) {
    return _then(
      _$UsersYuutaiImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: freezed == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as int?,
        benefitDetail: freezed == benefitDetail
            ? _value.benefitDetail
            : benefitDetail // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BenefitStatus,
        alertEnabled: null == alertEnabled
            ? _value.alertEnabled
            : alertEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        notifyDaysBefore: freezed == notifyDaysBefore
            ? _value._notifyDaysBefore
            : notifyDaysBefore // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        folderId: freezed == folderId
            ? _value.folderId
            : folderId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersYuutaiImpl extends _UsersYuutai {
  const _$UsersYuutaiImpl({
    this.id,
    @JsonKey(name: 'company_name') this.companyName = '',
    @JsonKey(name: 'company_id') this.companyId,
    @JsonKey(name: 'benefit_detail') this.benefitDetail,
    @JsonKey(name: 'expiry_date') this.expiryDate,
    this.status = BenefitStatus.active,
    @JsonKey(name: 'alert_enabled') this.alertEnabled = false,
    this.notes,
    @JsonKey(name: 'notify_days_before') final List<int>? notifyDaysBefore,
    @JsonKey(name: 'folder_id') this.folderId,
  }) : _notifyDaysBefore = notifyDaysBefore,
       super._();

  factory _$UsersYuutaiImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersYuutaiImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'company_id')
  final int? companyId;
  @override
  @JsonKey(name: 'benefit_detail')
  final String? benefitDetail;
  @override
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @override
  @JsonKey()
  final BenefitStatus status;
  @override
  @JsonKey(name: 'alert_enabled')
  final bool alertEnabled;
  @override
  final String? notes;
  final List<int>? _notifyDaysBefore;
  @override
  @JsonKey(name: 'notify_days_before')
  List<int>? get notifyDaysBefore {
    final value = _notifyDaysBefore;
    if (value == null) return null;
    if (_notifyDaysBefore is EqualUnmodifiableListView)
      return _notifyDaysBefore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'folder_id')
  final String? folderId;

  @override
  String toString() {
    return 'UsersYuutai(id: $id, companyName: $companyName, companyId: $companyId, benefitDetail: $benefitDetail, expiryDate: $expiryDate, status: $status, alertEnabled: $alertEnabled, notes: $notes, notifyDaysBefore: $notifyDaysBefore, folderId: $folderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersYuutaiImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.benefitDetail, benefitDetail) ||
                other.benefitDetail == benefitDetail) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.alertEnabled, alertEnabled) ||
                other.alertEnabled == alertEnabled) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._notifyDaysBefore,
              _notifyDaysBefore,
            ) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    companyName,
    companyId,
    benefitDetail,
    expiryDate,
    status,
    alertEnabled,
    notes,
    const DeepCollectionEquality().hash(_notifyDaysBefore),
    folderId,
  );

  /// Create a copy of UsersYuutai
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersYuutaiImplCopyWith<_$UsersYuutaiImpl> get copyWith =>
      __$$UsersYuutaiImplCopyWithImpl<_$UsersYuutaiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersYuutaiImplToJson(this);
  }
}

abstract class _UsersYuutai extends UsersYuutai {
  const factory _UsersYuutai({
    final int? id,
    @JsonKey(name: 'company_name') final String companyName,
    @JsonKey(name: 'company_id') final int? companyId,
    @JsonKey(name: 'benefit_detail') final String? benefitDetail,
    @JsonKey(name: 'expiry_date') final DateTime? expiryDate,
    final BenefitStatus status,
    @JsonKey(name: 'alert_enabled') final bool alertEnabled,
    final String? notes,
    @JsonKey(name: 'notify_days_before') final List<int>? notifyDaysBefore,
    @JsonKey(name: 'folder_id') final String? folderId,
  }) = _$UsersYuutaiImpl;
  const _UsersYuutai._() : super._();

  factory _UsersYuutai.fromJson(Map<String, dynamic> json) =
      _$UsersYuutaiImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'company_id')
  int? get companyId;
  @override
  @JsonKey(name: 'benefit_detail')
  String? get benefitDetail;
  @override
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;
  @override
  BenefitStatus get status;
  @override
  @JsonKey(name: 'alert_enabled')
  bool get alertEnabled;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'notify_days_before')
  List<int>? get notifyDaysBefore;
  @override
  @JsonKey(name: 'folder_id')
  String? get folderId;

  /// Create a copy of UsersYuutai
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersYuutaiImplCopyWith<_$UsersYuutaiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
