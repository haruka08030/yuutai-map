// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapState {
  List<Place> get items;
  Position get currentPosition;
  List<String> get availableCategories;
  bool get showAllStores;
  Set<String> get selectedCategories;
  String? get folderId;

  /// 地方で絞り込み（例: 関東）
  String? get selectedRegion;

  /// 都道府県で絞り込み（例: 東京都）。指定時は selectedRegion より優先
  String? get selectedPrefecture;
  bool get isGuest;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapStateCopyWith<MapState> get copyWith =>
      _$MapStateCopyWithImpl<MapState>(this as MapState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapState &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.currentPosition, currentPosition) ||
                other.currentPosition == currentPosition) &&
            const DeepCollectionEquality()
                .equals(other.availableCategories, availableCategories) &&
            (identical(other.showAllStores, showAllStores) ||
                other.showAllStores == showAllStores) &&
            const DeepCollectionEquality()
                .equals(other.selectedCategories, selectedCategories) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.selectedRegion, selectedRegion) ||
                other.selectedRegion == selectedRegion) &&
            (identical(other.selectedPrefecture, selectedPrefecture) ||
                other.selectedPrefecture == selectedPrefecture) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(items),
      currentPosition,
      const DeepCollectionEquality().hash(availableCategories),
      showAllStores,
      const DeepCollectionEquality().hash(selectedCategories),
      folderId,
      selectedRegion,
      selectedPrefecture,
      isGuest);

  @override
  String toString() {
    return 'MapState(items: $items, currentPosition: $currentPosition, availableCategories: $availableCategories, showAllStores: $showAllStores, selectedCategories: $selectedCategories, folderId: $folderId, selectedRegion: $selectedRegion, selectedPrefecture: $selectedPrefecture, isGuest: $isGuest)';
  }
}

/// @nodoc
abstract mixin class $MapStateCopyWith<$Res> {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) _then) =
      _$MapStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Place> items,
      Position currentPosition,
      List<String> availableCategories,
      bool showAllStores,
      Set<String> selectedCategories,
      String? folderId,
      String? selectedRegion,
      String? selectedPrefecture,
      bool isGuest});
}

/// @nodoc
class _$MapStateCopyWithImpl<$Res> implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._self, this._then);

  final MapState _self;
  final $Res Function(MapState) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentPosition = null,
    Object? availableCategories = null,
    Object? showAllStores = null,
    Object? selectedCategories = null,
    Object? folderId = freezed,
    Object? selectedRegion = freezed,
    Object? selectedPrefecture = freezed,
    Object? isGuest = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Place>,
      currentPosition: null == currentPosition
          ? _self.currentPosition
          : currentPosition // ignore: cast_nullable_to_non_nullable
              as Position,
      availableCategories: null == availableCategories
          ? _self.availableCategories
          : availableCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      showAllStores: null == showAllStores
          ? _self.showAllStores
          : showAllStores // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedCategories: null == selectedCategories
          ? _self.selectedCategories
          : selectedCategories // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      folderId: freezed == folderId
          ? _self.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedRegion: freezed == selectedRegion
          ? _self.selectedRegion
          : selectedRegion // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedPrefecture: freezed == selectedPrefecture
          ? _self.selectedPrefecture
          : selectedPrefecture // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: null == isGuest
          ? _self.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MapState].
extension MapStatePatterns on MapState {
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
    TResult Function(_MapState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapState() when $default != null:
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
    TResult Function(_MapState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapState():
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
    TResult? Function(_MapState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapState() when $default != null:
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
            List<Place> items,
            Position currentPosition,
            List<String> availableCategories,
            bool showAllStores,
            Set<String> selectedCategories,
            String? folderId,
            String? selectedRegion,
            String? selectedPrefecture,
            bool isGuest)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapState() when $default != null:
        return $default(
            _that.items,
            _that.currentPosition,
            _that.availableCategories,
            _that.showAllStores,
            _that.selectedCategories,
            _that.folderId,
            _that.selectedRegion,
            _that.selectedPrefecture,
            _that.isGuest);
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
            List<Place> items,
            Position currentPosition,
            List<String> availableCategories,
            bool showAllStores,
            Set<String> selectedCategories,
            String? folderId,
            String? selectedRegion,
            String? selectedPrefecture,
            bool isGuest)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapState():
        return $default(
            _that.items,
            _that.currentPosition,
            _that.availableCategories,
            _that.showAllStores,
            _that.selectedCategories,
            _that.folderId,
            _that.selectedRegion,
            _that.selectedPrefecture,
            _that.isGuest);
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
            List<Place> items,
            Position currentPosition,
            List<String> availableCategories,
            bool showAllStores,
            Set<String> selectedCategories,
            String? folderId,
            String? selectedRegion,
            String? selectedPrefecture,
            bool isGuest)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapState() when $default != null:
        return $default(
            _that.items,
            _that.currentPosition,
            _that.availableCategories,
            _that.showAllStores,
            _that.selectedCategories,
            _that.folderId,
            _that.selectedRegion,
            _that.selectedPrefecture,
            _that.isGuest);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MapState implements MapState {
  const _MapState(
      {required final List<Place> items,
      required this.currentPosition,
      required final List<String> availableCategories,
      required this.showAllStores,
      required final Set<String> selectedCategories,
      this.folderId,
      this.selectedRegion,
      this.selectedPrefecture,
      this.isGuest = false})
      : _items = items,
        _availableCategories = availableCategories,
        _selectedCategories = selectedCategories;

  final List<Place> _items;
  @override
  List<Place> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final Position currentPosition;
  final List<String> _availableCategories;
  @override
  List<String> get availableCategories {
    if (_availableCategories is EqualUnmodifiableListView)
      return _availableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCategories);
  }

  @override
  final bool showAllStores;
  final Set<String> _selectedCategories;
  @override
  Set<String> get selectedCategories {
    if (_selectedCategories is EqualUnmodifiableSetView)
      return _selectedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedCategories);
  }

  @override
  final String? folderId;

  /// 地方で絞り込み（例: 関東）
  @override
  final String? selectedRegion;

  /// 都道府県で絞り込み（例: 東京都）。指定時は selectedRegion より優先
  @override
  final String? selectedPrefecture;
  @override
  @JsonKey()
  final bool isGuest;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MapStateCopyWith<_MapState> get copyWith =>
      __$MapStateCopyWithImpl<_MapState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MapState &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currentPosition, currentPosition) ||
                other.currentPosition == currentPosition) &&
            const DeepCollectionEquality()
                .equals(other._availableCategories, _availableCategories) &&
            (identical(other.showAllStores, showAllStores) ||
                other.showAllStores == showAllStores) &&
            const DeepCollectionEquality()
                .equals(other._selectedCategories, _selectedCategories) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.selectedRegion, selectedRegion) ||
                other.selectedRegion == selectedRegion) &&
            (identical(other.selectedPrefecture, selectedPrefecture) ||
                other.selectedPrefecture == selectedPrefecture) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      currentPosition,
      const DeepCollectionEquality().hash(_availableCategories),
      showAllStores,
      const DeepCollectionEquality().hash(_selectedCategories),
      folderId,
      selectedRegion,
      selectedPrefecture,
      isGuest);

  @override
  String toString() {
    return 'MapState(items: $items, currentPosition: $currentPosition, availableCategories: $availableCategories, showAllStores: $showAllStores, selectedCategories: $selectedCategories, folderId: $folderId, selectedRegion: $selectedRegion, selectedPrefecture: $selectedPrefecture, isGuest: $isGuest)';
  }
}

/// @nodoc
abstract mixin class _$MapStateCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory _$MapStateCopyWith(_MapState value, $Res Function(_MapState) _then) =
      __$MapStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Place> items,
      Position currentPosition,
      List<String> availableCategories,
      bool showAllStores,
      Set<String> selectedCategories,
      String? folderId,
      String? selectedRegion,
      String? selectedPrefecture,
      bool isGuest});
}

/// @nodoc
class __$MapStateCopyWithImpl<$Res> implements _$MapStateCopyWith<$Res> {
  __$MapStateCopyWithImpl(this._self, this._then);

  final _MapState _self;
  final $Res Function(_MapState) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? currentPosition = null,
    Object? availableCategories = null,
    Object? showAllStores = null,
    Object? selectedCategories = null,
    Object? folderId = freezed,
    Object? selectedRegion = freezed,
    Object? selectedPrefecture = freezed,
    Object? isGuest = null,
  }) {
    return _then(_MapState(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Place>,
      currentPosition: null == currentPosition
          ? _self.currentPosition
          : currentPosition // ignore: cast_nullable_to_non_nullable
              as Position,
      availableCategories: null == availableCategories
          ? _self._availableCategories
          : availableCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      showAllStores: null == showAllStores
          ? _self.showAllStores
          : showAllStores // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedCategories: null == selectedCategories
          ? _self._selectedCategories
          : selectedCategories // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      folderId: freezed == folderId
          ? _self.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedRegion: freezed == selectedRegion
          ? _self.selectedRegion
          : selectedRegion // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedPrefecture: freezed == selectedPrefecture
          ? _self.selectedPrefecture
          : selectedPrefecture // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: null == isGuest
          ? _self.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
