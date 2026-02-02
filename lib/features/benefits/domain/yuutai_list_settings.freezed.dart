// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yuutai_list_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YuutaiListSettings {
  YuutaiSortOrder get sortOrder;
  bool get showHistory;
  YuutaiListFilter get listFilter;
  String? get folderId;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $YuutaiListSettingsCopyWith<YuutaiListSettings> get copyWith =>
      _$YuutaiListSettingsCopyWithImpl<YuutaiListSettings>(
          this as YuutaiListSettings, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is YuutaiListSettings &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.showHistory, showHistory) ||
                other.showHistory == showHistory) &&
            (identical(other.listFilter, listFilter) ||
                other.listFilter == listFilter) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sortOrder, showHistory, listFilter, folderId);

  @override
  String toString() {
    return 'YuutaiListSettings(sortOrder: $sortOrder, showHistory: $showHistory, listFilter: $listFilter, folderId: $folderId)';
  }
}

/// @nodoc
abstract mixin class $YuutaiListSettingsCopyWith<$Res> {
  factory $YuutaiListSettingsCopyWith(
          YuutaiListSettings value, $Res Function(YuutaiListSettings) _then) =
      _$YuutaiListSettingsCopyWithImpl;
  @useResult
  $Res call(
      {YuutaiSortOrder sortOrder,
      bool showHistory,
      YuutaiListFilter listFilter,
      String? folderId});
}

/// @nodoc
class _$YuutaiListSettingsCopyWithImpl<$Res>
    implements $YuutaiListSettingsCopyWith<$Res> {
  _$YuutaiListSettingsCopyWithImpl(this._self, this._then);

  final YuutaiListSettings _self;
  final $Res Function(YuutaiListSettings) _then;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortOrder = null,
    Object? showHistory = null,
    Object? listFilter = null,
    Object? folderId = freezed,
  }) {
    return _then(_self.copyWith(
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as YuutaiSortOrder,
      showHistory: null == showHistory
          ? _self.showHistory
          : showHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      listFilter: null == listFilter
          ? _self.listFilter
          : listFilter // ignore: cast_nullable_to_non_nullable
              as YuutaiListFilter,
      folderId: freezed == folderId
          ? _self.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [YuutaiListSettings].
extension YuutaiListSettingsPatterns on YuutaiListSettings {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_YuutaiListSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _YuutaiListSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_YuutaiListSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _YuutaiListSettings():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_YuutaiListSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _YuutaiListSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(YuutaiSortOrder sortOrder, bool showHistory,
            YuutaiListFilter listFilter, String? folderId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _YuutaiListSettings() when $default != null:
        return $default(_that.sortOrder, _that.showHistory, _that.listFilter,
            _that.folderId);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(YuutaiSortOrder sortOrder, bool showHistory,
            YuutaiListFilter listFilter, String? folderId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _YuutaiListSettings():
        return $default(_that.sortOrder, _that.showHistory, _that.listFilter,
            _that.folderId);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(YuutaiSortOrder sortOrder, bool showHistory,
            YuutaiListFilter listFilter, String? folderId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _YuutaiListSettings() when $default != null:
        return $default(_that.sortOrder, _that.showHistory, _that.listFilter,
            _that.folderId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _YuutaiListSettings implements YuutaiListSettings {
  const _YuutaiListSettings(
      {this.sortOrder = YuutaiSortOrder.expiryDate,
      this.showHistory = false,
      this.listFilter = YuutaiListFilter.all,
      this.folderId});

  @override
  @JsonKey()
  final YuutaiSortOrder sortOrder;
  @override
  @JsonKey()
  final bool showHistory;
  @override
  @JsonKey()
  final YuutaiListFilter listFilter;
  @override
  final String? folderId;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$YuutaiListSettingsCopyWith<_YuutaiListSettings> get copyWith =>
      __$YuutaiListSettingsCopyWithImpl<_YuutaiListSettings>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _YuutaiListSettings &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.showHistory, showHistory) ||
                other.showHistory == showHistory) &&
            (identical(other.listFilter, listFilter) ||
                other.listFilter == listFilter) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sortOrder, showHistory, listFilter, folderId);

  @override
  String toString() {
    return 'YuutaiListSettings(sortOrder: $sortOrder, showHistory: $showHistory, listFilter: $listFilter, folderId: $folderId)';
  }
}

/// @nodoc
abstract mixin class _$YuutaiListSettingsCopyWith<$Res>
    implements $YuutaiListSettingsCopyWith<$Res> {
  factory _$YuutaiListSettingsCopyWith(
          _YuutaiListSettings value, $Res Function(_YuutaiListSettings) _then) =
      __$YuutaiListSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {YuutaiSortOrder sortOrder,
      bool showHistory,
      YuutaiListFilter listFilter,
      String? folderId});
}

/// @nodoc
class __$YuutaiListSettingsCopyWithImpl<$Res>
    implements _$YuutaiListSettingsCopyWith<$Res> {
  __$YuutaiListSettingsCopyWithImpl(this._self, this._then);

  final _YuutaiListSettings _self;
  final $Res Function(_YuutaiListSettings) _then;

  /// Create a copy of YuutaiListSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sortOrder = null,
    Object? showHistory = null,
    Object? listFilter = null,
    Object? folderId = freezed,
  }) {
    return _then(_YuutaiListSettings(
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as YuutaiSortOrder,
      showHistory: null == showHistory
          ? _self.showHistory
          : showHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      listFilter: null == listFilter
          ? _self.listFilter
          : listFilter // ignore: cast_nullable_to_non_nullable
              as YuutaiListFilter,
      folderId: freezed == folderId
          ? _self.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
