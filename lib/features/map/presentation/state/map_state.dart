import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';

part 'map_state.freezed.dart';

@freezed
abstract class MapState with _$MapState {
  const factory MapState({
    required List<Place> items,
    required Position currentPosition,
    required List<String> availableCategories,
    required bool showAllStores,
    required Set<String> selectedCategories,
    String? folderId,
    @Default(false) bool isGuest,
  }) = _MapState;
}
