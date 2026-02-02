// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Store {
  int get id;
  String get name;
  @JsonKey(name: 'lat')
  double get latitude;
  @JsonKey(name: 'lng')
  double get longitude;
  @JsonKey(name: 'category_tag')
  String? get category;
  String? get address;
  String? get prefecture;
  @JsonKey(name: 'company_id')
  int? get companyId;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreCopyWith<Store> get copyWith =>
      _$StoreCopyWithImpl<Store>(this as Store, _$identity);

  /// Serializes this Store to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Store &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.prefecture, prefecture) ||
                other.prefecture == prefecture) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, latitude, longitude,
      category, address, prefecture, companyId);

  @override
  String toString() {
    return 'Store(id: $id, name: $name, latitude: $latitude, longitude: $longitude, category: $category, address: $address, prefecture: $prefecture, companyId: $companyId)';
  }
}

/// @nodoc
abstract mixin class $StoreCopyWith<$Res> {
  factory $StoreCopyWith(Store value, $Res Function(Store) _then) =
      _$StoreCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'lat') double latitude,
      @JsonKey(name: 'lng') double longitude,
      @JsonKey(name: 'category_tag') String? category,
      String? address,
      String? prefecture,
      @JsonKey(name: 'company_id') int? companyId});
}

/// @nodoc
class _$StoreCopyWithImpl<$Res> implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._self, this._then);

  final Store _self;
  final $Res Function(Store) _then;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? category = freezed,
    Object? address = freezed,
    Object? prefecture = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      prefecture: freezed == prefecture
          ? _self.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _self.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Store].
extension StorePatterns on Store {
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
    TResult Function(_Store value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Store() when $default != null:
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
    TResult Function(_Store value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Store():
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
    TResult? Function(_Store value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Store() when $default != null:
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
            int id,
            String name,
            @JsonKey(name: 'lat') double latitude,
            @JsonKey(name: 'lng') double longitude,
            @JsonKey(name: 'category_tag') String? category,
            String? address,
            String? prefecture,
            @JsonKey(name: 'company_id') int? companyId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Store() when $default != null:
        return $default(_that.id, _that.name, _that.latitude, _that.longitude,
            _that.category, _that.address, _that.prefecture, _that.companyId);
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
            int id,
            String name,
            @JsonKey(name: 'lat') double latitude,
            @JsonKey(name: 'lng') double longitude,
            @JsonKey(name: 'category_tag') String? category,
            String? address,
            String? prefecture,
            @JsonKey(name: 'company_id') int? companyId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Store():
        return $default(_that.id, _that.name, _that.latitude, _that.longitude,
            _that.category, _that.address, _that.prefecture, _that.companyId);
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
            int id,
            String name,
            @JsonKey(name: 'lat') double latitude,
            @JsonKey(name: 'lng') double longitude,
            @JsonKey(name: 'category_tag') String? category,
            String? address,
            String? prefecture,
            @JsonKey(name: 'company_id') int? companyId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Store() when $default != null:
        return $default(_that.id, _that.name, _that.latitude, _that.longitude,
            _that.category, _that.address, _that.prefecture, _that.companyId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Store implements Store {
  const _Store(
      {required this.id,
      required this.name,
      @JsonKey(name: 'lat') required this.latitude,
      @JsonKey(name: 'lng') required this.longitude,
      @JsonKey(name: 'category_tag') this.category,
      this.address,
      this.prefecture,
      @JsonKey(name: 'company_id') this.companyId});
  factory _Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'lat')
  final double latitude;
  @override
  @JsonKey(name: 'lng')
  final double longitude;
  @override
  @JsonKey(name: 'category_tag')
  final String? category;
  @override
  final String? address;
  @override
  final String? prefecture;
  @override
  @JsonKey(name: 'company_id')
  final int? companyId;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StoreCopyWith<_Store> get copyWith =>
      __$StoreCopyWithImpl<_Store>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StoreToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Store &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.prefecture, prefecture) ||
                other.prefecture == prefecture) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, latitude, longitude,
      category, address, prefecture, companyId);

  @override
  String toString() {
    return 'Store(id: $id, name: $name, latitude: $latitude, longitude: $longitude, category: $category, address: $address, prefecture: $prefecture, companyId: $companyId)';
  }
}

/// @nodoc
abstract mixin class _$StoreCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$StoreCopyWith(_Store value, $Res Function(_Store) _then) =
      __$StoreCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'lat') double latitude,
      @JsonKey(name: 'lng') double longitude,
      @JsonKey(name: 'category_tag') String? category,
      String? address,
      String? prefecture,
      @JsonKey(name: 'company_id') int? companyId});
}

/// @nodoc
class __$StoreCopyWithImpl<$Res> implements _$StoreCopyWith<$Res> {
  __$StoreCopyWithImpl(this._self, this._then);

  final _Store _self;
  final $Res Function(_Store) _then;

  /// Create a copy of Store
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? category = freezed,
    Object? address = freezed,
    Object? prefecture = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_Store(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      prefecture: freezed == prefecture
          ? _self.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _self.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
