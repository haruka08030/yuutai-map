// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MapState {
  Set<Marker> get markers => throw _privateConstructorUsedError;
  Position get currentPosition => throw _privateConstructorUsedError;
  List<String> get availableCategories => throw _privateConstructorUsedError;
  bool get showAllStores => throw _privateConstructorUsedError;
  Set<String> get selectedCategories => throw _privateConstructorUsedError;
  bool get isGuest => throw _privateConstructorUsedError;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapStateCopyWith<MapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapStateCopyWith<$Res> {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) then) =
      _$MapStateCopyWithImpl<$Res, MapState>;
  @useResult
  $Res call({
    Set<Marker> markers,
    Position currentPosition,
    List<String> availableCategories,
    bool showAllStores,
    Set<String> selectedCategories,
    bool isGuest,
  });
}

/// @nodoc
class _$MapStateCopyWithImpl<$Res, $Val extends MapState>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markers = null,
    Object? currentPosition = null,
    Object? availableCategories = null,
    Object? showAllStores = null,
    Object? selectedCategories = null,
    Object? isGuest = null,
  }) {
    return _then(
      _value.copyWith(
            markers: null == markers
                ? _value.markers
                : markers // ignore: cast_nullable_to_non_nullable
                      as Set<Marker>,
            currentPosition: null == currentPosition
                ? _value.currentPosition
                : currentPosition // ignore: cast_nullable_to_non_nullable
                      as Position,
            availableCategories: null == availableCategories
                ? _value.availableCategories
                : availableCategories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            showAllStores: null == showAllStores
                ? _value.showAllStores
                : showAllStores // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedCategories: null == selectedCategories
                ? _value.selectedCategories
                : selectedCategories // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            isGuest: null == isGuest
                ? _value.isGuest
                : isGuest // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapStateImplCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory _$$MapStateImplCopyWith(
    _$MapStateImpl value,
    $Res Function(_$MapStateImpl) then,
  ) = __$$MapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Set<Marker> markers,
    Position currentPosition,
    List<String> availableCategories,
    bool showAllStores,
    Set<String> selectedCategories,
    bool isGuest,
  });
}

/// @nodoc
class __$$MapStateImplCopyWithImpl<$Res>
    extends _$MapStateCopyWithImpl<$Res, _$MapStateImpl>
    implements _$$MapStateImplCopyWith<$Res> {
  __$$MapStateImplCopyWithImpl(
    _$MapStateImpl _value,
    $Res Function(_$MapStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markers = null,
    Object? currentPosition = null,
    Object? availableCategories = null,
    Object? showAllStores = null,
    Object? selectedCategories = null,
    Object? isGuest = null,
  }) {
    return _then(
      _$MapStateImpl(
        markers: null == markers
            ? _value._markers
            : markers // ignore: cast_nullable_to_non_nullable
                  as Set<Marker>,
        currentPosition: null == currentPosition
            ? _value.currentPosition
            : currentPosition // ignore: cast_nullable_to_non_nullable
                  as Position,
        availableCategories: null == availableCategories
            ? _value._availableCategories
            : availableCategories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        showAllStores: null == showAllStores
            ? _value.showAllStores
            : showAllStores // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedCategories: null == selectedCategories
            ? _value._selectedCategories
            : selectedCategories // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        isGuest: null == isGuest
            ? _value.isGuest
            : isGuest // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$MapStateImpl implements _MapState {
  const _$MapStateImpl({
    required final Set<Marker> markers,
    required this.currentPosition,
    required final List<String> availableCategories,
    required this.showAllStores,
    required final Set<String> selectedCategories,
    this.isGuest = false,
  }) : _markers = markers,
       _availableCategories = availableCategories,
       _selectedCategories = selectedCategories;

  final Set<Marker> _markers;
  @override
  Set<Marker> get markers {
    if (_markers is EqualUnmodifiableSetView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_markers);
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
  @JsonKey()
  final bool isGuest;

  @override
  String toString() {
    return 'MapState(markers: $markers, currentPosition: $currentPosition, availableCategories: $availableCategories, showAllStores: $showAllStores, selectedCategories: $selectedCategories, isGuest: $isGuest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapStateImpl &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            (identical(other.currentPosition, currentPosition) ||
                other.currentPosition == currentPosition) &&
            const DeepCollectionEquality().equals(
              other._availableCategories,
              _availableCategories,
            ) &&
            (identical(other.showAllStores, showAllStores) ||
                other.showAllStores == showAllStores) &&
            const DeepCollectionEquality().equals(
              other._selectedCategories,
              _selectedCategories,
            ) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_markers),
    currentPosition,
    const DeepCollectionEquality().hash(_availableCategories),
    showAllStores,
    const DeepCollectionEquality().hash(_selectedCategories),
    isGuest,
  );

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      __$$MapStateImplCopyWithImpl<_$MapStateImpl>(this, _$identity);
}

abstract class _MapState implements MapState {
  const factory _MapState({
    required final Set<Marker> markers,
    required final Position currentPosition,
    required final List<String> availableCategories,
    required final bool showAllStores,
    required final Set<String> selectedCategories,
    final bool isGuest,
  }) = _$MapStateImpl;

  @override
  Set<Marker> get markers;
  @override
  Position get currentPosition;
  @override
  List<String> get availableCategories;
  @override
  bool get showAllStores;
  @override
  Set<String> get selectedCategories;
  @override
  bool get isGuest;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
