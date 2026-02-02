// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_yuutai_edit_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsersYuutaiEditState {
  UsersYuutai? get initialBenefit;
  DateTime? get expireOn;
  String? get selectedFolderId;
  int? get selectedCompanyId;
  Map<int, bool> get selectedPredefinedDays;
  bool get customDayEnabled;
  String get customDayValue;
  bool get isLoading;

  /// Create a copy of UsersYuutaiEditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsersYuutaiEditStateCopyWith<UsersYuutaiEditState> get copyWith =>
      _$UsersYuutaiEditStateCopyWithImpl<UsersYuutaiEditState>(
          this as UsersYuutaiEditState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsersYuutaiEditState &&
            (identical(other.initialBenefit, initialBenefit) ||
                other.initialBenefit == initialBenefit) &&
            (identical(other.expireOn, expireOn) ||
                other.expireOn == expireOn) &&
            (identical(other.selectedFolderId, selectedFolderId) ||
                other.selectedFolderId == selectedFolderId) &&
            (identical(other.selectedCompanyId, selectedCompanyId) ||
                other.selectedCompanyId == selectedCompanyId) &&
            const DeepCollectionEquality()
                .equals(other.selectedPredefinedDays, selectedPredefinedDays) &&
            (identical(other.customDayEnabled, customDayEnabled) ||
                other.customDayEnabled == customDayEnabled) &&
            (identical(other.customDayValue, customDayValue) ||
                other.customDayValue == customDayValue) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      initialBenefit,
      expireOn,
      selectedFolderId,
      selectedCompanyId,
      const DeepCollectionEquality().hash(selectedPredefinedDays),
      customDayEnabled,
      customDayValue,
      isLoading);

  @override
  String toString() {
    return 'UsersYuutaiEditState(initialBenefit: $initialBenefit, expireOn: $expireOn, selectedFolderId: $selectedFolderId, selectedCompanyId: $selectedCompanyId, selectedPredefinedDays: $selectedPredefinedDays, customDayEnabled: $customDayEnabled, customDayValue: $customDayValue, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $UsersYuutaiEditStateCopyWith<$Res> {
  factory $UsersYuutaiEditStateCopyWith(UsersYuutaiEditState value,
          $Res Function(UsersYuutaiEditState) _then) =
      _$UsersYuutaiEditStateCopyWithImpl;
  @useResult
  $Res call(
      {UsersYuutai? initialBenefit,
      DateTime? expireOn,
      String? selectedFolderId,
      int? selectedCompanyId,
      Map<int, bool> selectedPredefinedDays,
      bool customDayEnabled,
      String customDayValue,
      bool isLoading});

  $UsersYuutaiCopyWith<$Res>? get initialBenefit;
}

/// @nodoc
class _$UsersYuutaiEditStateCopyWithImpl<$Res>
    implements $UsersYuutaiEditStateCopyWith<$Res> {
  _$UsersYuutaiEditStateCopyWithImpl(this._self, this._then);

  final UsersYuutaiEditState _self;
  final $Res Function(UsersYuutaiEditState) _then;

  /// Create a copy of UsersYuutaiEditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialBenefit = freezed,
    Object? expireOn = freezed,
    Object? selectedFolderId = freezed,
    Object? selectedCompanyId = freezed,
    Object? selectedPredefinedDays = null,
    Object? customDayEnabled = null,
    Object? customDayValue = null,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      initialBenefit: freezed == initialBenefit
          ? _self.initialBenefit
          : initialBenefit // ignore: cast_nullable_to_non_nullable
              as UsersYuutai?,
      expireOn: freezed == expireOn
          ? _self.expireOn
          : expireOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedFolderId: freezed == selectedFolderId
          ? _self.selectedFolderId
          : selectedFolderId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCompanyId: freezed == selectedCompanyId
          ? _self.selectedCompanyId
          : selectedCompanyId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedPredefinedDays: null == selectedPredefinedDays
          ? _self.selectedPredefinedDays
          : selectedPredefinedDays // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      customDayEnabled: null == customDayEnabled
          ? _self.customDayEnabled
          : customDayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      customDayValue: null == customDayValue
          ? _self.customDayValue
          : customDayValue // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of UsersYuutaiEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsersYuutaiCopyWith<$Res>? get initialBenefit {
    if (_self.initialBenefit == null) {
      return null;
    }

    return $UsersYuutaiCopyWith<$Res>(_self.initialBenefit!, (value) {
      return _then(_self.copyWith(initialBenefit: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UsersYuutaiEditState].
extension UsersYuutaiEditStatePatterns on UsersYuutaiEditState {
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
    TResult Function(_UsersYuutaiEditState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsersYuutaiEditState() when $default != null:
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
    TResult Function(_UsersYuutaiEditState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsersYuutaiEditState():
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
    TResult? Function(_UsersYuutaiEditState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsersYuutaiEditState() when $default != null:
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
    TResult Function(
            UsersYuutai? initialBenefit,
            DateTime? expireOn,
            String? selectedFolderId,
            int? selectedCompanyId,
            Map<int, bool> selectedPredefinedDays,
            bool customDayEnabled,
            String customDayValue,
            bool isLoading)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsersYuutaiEditState() when $default != null:
        return $default(
            _that.initialBenefit,
            _that.expireOn,
            _that.selectedFolderId,
            _that.selectedCompanyId,
            _that.selectedPredefinedDays,
            _that.customDayEnabled,
            _that.customDayValue,
            _that.isLoading);
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
    TResult Function(
            UsersYuutai? initialBenefit,
            DateTime? expireOn,
            String? selectedFolderId,
            int? selectedCompanyId,
            Map<int, bool> selectedPredefinedDays,
            bool customDayEnabled,
            String customDayValue,
            bool isLoading)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsersYuutaiEditState():
        return $default(
            _that.initialBenefit,
            _that.expireOn,
            _that.selectedFolderId,
            _that.selectedCompanyId,
            _that.selectedPredefinedDays,
            _that.customDayEnabled,
            _that.customDayValue,
            _that.isLoading);
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
    TResult? Function(
            UsersYuutai? initialBenefit,
            DateTime? expireOn,
            String? selectedFolderId,
            int? selectedCompanyId,
            Map<int, bool> selectedPredefinedDays,
            bool customDayEnabled,
            String customDayValue,
            bool isLoading)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsersYuutaiEditState() when $default != null:
        return $default(
            _that.initialBenefit,
            _that.expireOn,
            _that.selectedFolderId,
            _that.selectedCompanyId,
            _that.selectedPredefinedDays,
            _that.customDayEnabled,
            _that.customDayValue,
            _that.isLoading);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UsersYuutaiEditState implements UsersYuutaiEditState {
  const _UsersYuutaiEditState(
      {this.initialBenefit,
      this.expireOn,
      this.selectedFolderId,
      this.selectedCompanyId,
      final Map<int, bool> selectedPredefinedDays = _predefinedDayOptions,
      this.customDayEnabled = false,
      this.customDayValue = '',
      this.isLoading = false})
      : _selectedPredefinedDays = selectedPredefinedDays;

  @override
  final UsersYuutai? initialBenefit;
  @override
  final DateTime? expireOn;
  @override
  final String? selectedFolderId;
  @override
  final int? selectedCompanyId;
  final Map<int, bool> _selectedPredefinedDays;
  @override
  @JsonKey()
  Map<int, bool> get selectedPredefinedDays {
    if (_selectedPredefinedDays is EqualUnmodifiableMapView)
      return _selectedPredefinedDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedPredefinedDays);
  }

  @override
  @JsonKey()
  final bool customDayEnabled;
  @override
  @JsonKey()
  final String customDayValue;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of UsersYuutaiEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsersYuutaiEditStateCopyWith<_UsersYuutaiEditState> get copyWith =>
      __$UsersYuutaiEditStateCopyWithImpl<_UsersYuutaiEditState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsersYuutaiEditState &&
            (identical(other.initialBenefit, initialBenefit) ||
                other.initialBenefit == initialBenefit) &&
            (identical(other.expireOn, expireOn) ||
                other.expireOn == expireOn) &&
            (identical(other.selectedFolderId, selectedFolderId) ||
                other.selectedFolderId == selectedFolderId) &&
            (identical(other.selectedCompanyId, selectedCompanyId) ||
                other.selectedCompanyId == selectedCompanyId) &&
            const DeepCollectionEquality().equals(
                other._selectedPredefinedDays, _selectedPredefinedDays) &&
            (identical(other.customDayEnabled, customDayEnabled) ||
                other.customDayEnabled == customDayEnabled) &&
            (identical(other.customDayValue, customDayValue) ||
                other.customDayValue == customDayValue) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      initialBenefit,
      expireOn,
      selectedFolderId,
      selectedCompanyId,
      const DeepCollectionEquality().hash(_selectedPredefinedDays),
      customDayEnabled,
      customDayValue,
      isLoading);

  @override
  String toString() {
    return 'UsersYuutaiEditState(initialBenefit: $initialBenefit, expireOn: $expireOn, selectedFolderId: $selectedFolderId, selectedCompanyId: $selectedCompanyId, selectedPredefinedDays: $selectedPredefinedDays, customDayEnabled: $customDayEnabled, customDayValue: $customDayValue, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$UsersYuutaiEditStateCopyWith<$Res>
    implements $UsersYuutaiEditStateCopyWith<$Res> {
  factory _$UsersYuutaiEditStateCopyWith(_UsersYuutaiEditState value,
          $Res Function(_UsersYuutaiEditState) _then) =
      __$UsersYuutaiEditStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {UsersYuutai? initialBenefit,
      DateTime? expireOn,
      String? selectedFolderId,
      int? selectedCompanyId,
      Map<int, bool> selectedPredefinedDays,
      bool customDayEnabled,
      String customDayValue,
      bool isLoading});

  @override
  $UsersYuutaiCopyWith<$Res>? get initialBenefit;
}

/// @nodoc
class __$UsersYuutaiEditStateCopyWithImpl<$Res>
    implements _$UsersYuutaiEditStateCopyWith<$Res> {
  __$UsersYuutaiEditStateCopyWithImpl(this._self, this._then);

  final _UsersYuutaiEditState _self;
  final $Res Function(_UsersYuutaiEditState) _then;

  /// Create a copy of UsersYuutaiEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? initialBenefit = freezed,
    Object? expireOn = freezed,
    Object? selectedFolderId = freezed,
    Object? selectedCompanyId = freezed,
    Object? selectedPredefinedDays = null,
    Object? customDayEnabled = null,
    Object? customDayValue = null,
    Object? isLoading = null,
  }) {
    return _then(_UsersYuutaiEditState(
      initialBenefit: freezed == initialBenefit
          ? _self.initialBenefit
          : initialBenefit // ignore: cast_nullable_to_non_nullable
              as UsersYuutai?,
      expireOn: freezed == expireOn
          ? _self.expireOn
          : expireOn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedFolderId: freezed == selectedFolderId
          ? _self.selectedFolderId
          : selectedFolderId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCompanyId: freezed == selectedCompanyId
          ? _self.selectedCompanyId
          : selectedCompanyId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedPredefinedDays: null == selectedPredefinedDays
          ? _self._selectedPredefinedDays
          : selectedPredefinedDays // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      customDayEnabled: null == customDayEnabled
          ? _self.customDayEnabled
          : customDayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      customDayValue: null == customDayValue
          ? _self.customDayValue
          : customDayValue // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of UsersYuutaiEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsersYuutaiCopyWith<$Res>? get initialBenefit {
    if (_self.initialBenefit == null) {
      return null;
    }

    return $UsersYuutaiCopyWith<$Res>(_self.initialBenefit!, (value) {
      return _then(_self.copyWith(initialBenefit: value));
    });
  }
}

// dart format on
