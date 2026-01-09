// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yuutai_list_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$YuutaiListSettings {
  YuutaiSortOrder get sortOrder => throw _privateConstructorUsedError;
  bool get showHistory => throw _privateConstructorUsedError;
  String? get folderId => throw _privateConstructorUsedError;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YuutaiListSettingsCopyWith<YuutaiListSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YuutaiListSettingsCopyWith<$Res> {
  factory $YuutaiListSettingsCopyWith(
    YuutaiListSettings value,
    $Res Function(YuutaiListSettings) then,
  ) = _$YuutaiListSettingsCopyWithImpl<$Res, YuutaiListSettings>;
  @useResult
  $Res call({YuutaiSortOrder sortOrder, bool showHistory, String? folderId});
}

/// @nodoc
class _$YuutaiListSettingsCopyWithImpl<$Res, $Val extends YuutaiListSettings>
    implements $YuutaiListSettingsCopyWith<$Res> {
  _$YuutaiListSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortOrder = null,
    Object? showHistory = null,
    Object? folderId = freezed,
  }) {
    return _then(
      _value.copyWith(
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as YuutaiSortOrder,
            showHistory: null == showHistory
                ? _value.showHistory
                : showHistory // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$YuutaiListSettingsImplCopyWith<$Res>
    implements $YuutaiListSettingsCopyWith<$Res> {
  factory _$$YuutaiListSettingsImplCopyWith(
    _$YuutaiListSettingsImpl value,
    $Res Function(_$YuutaiListSettingsImpl) then,
  ) = __$$YuutaiListSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({YuutaiSortOrder sortOrder, bool showHistory, String? folderId});
}

/// @nodoc
class __$$YuutaiListSettingsImplCopyWithImpl<$Res>
    extends _$YuutaiListSettingsCopyWithImpl<$Res, _$YuutaiListSettingsImpl>
    implements _$$YuutaiListSettingsImplCopyWith<$Res> {
  __$$YuutaiListSettingsImplCopyWithImpl(
    _$YuutaiListSettingsImpl _value,
    $Res Function(_$YuutaiListSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortOrder = null,
    Object? showHistory = null,
    Object? folderId = freezed,
  }) {
    return _then(
      _$YuutaiListSettingsImpl(
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as YuutaiSortOrder,
        showHistory: null == showHistory
            ? _value.showHistory
            : showHistory // ignore: cast_nullable_to_non_nullable
                  as bool,
        folderId: freezed == folderId
            ? _value.folderId
            : folderId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$YuutaiListSettingsImpl implements _YuutaiListSettings {
  const _$YuutaiListSettingsImpl({
    this.sortOrder = YuutaiSortOrder.expiryDate,
    this.showHistory = false,
    this.folderId,
  });

  @override
  @JsonKey()
  final YuutaiSortOrder sortOrder;
  @override
  @JsonKey()
  final bool showHistory;
  @override
  final String? folderId;

  @override
  String toString() {
    return 'YuutaiListSettings(sortOrder: $sortOrder, showHistory: $showHistory, folderId: $folderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YuutaiListSettingsImpl &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.showHistory, showHistory) ||
                other.showHistory == showHistory) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sortOrder, showHistory, folderId);

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YuutaiListSettingsImplCopyWith<_$YuutaiListSettingsImpl> get copyWith =>
      __$$YuutaiListSettingsImplCopyWithImpl<_$YuutaiListSettingsImpl>(
        this,
        _$identity,
      );
}

abstract class _YuutaiListSettings implements YuutaiListSettings {
  const factory _YuutaiListSettings({
    final YuutaiSortOrder sortOrder,
    final bool showHistory,
    final String? folderId,
  }) = _$YuutaiListSettingsImpl;

  @override
  YuutaiSortOrder get sortOrder;
  @override
  bool get showHistory;
  @override
  String? get folderId;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YuutaiListSettingsImplCopyWith<_$YuutaiListSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
