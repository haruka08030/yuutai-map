import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    required Set<Marker> markers,
    required Position currentPosition,
    required List<String> availableCategories,
    required bool showAllStores,
    required Set<String> selectedCategories,
    @Default(false) bool isGuest,
  }) = _MapState;
}
