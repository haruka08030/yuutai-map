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

    /// 地方で絞り込み（例: 関東）
    String? selectedRegion,

    /// 都道府県で絞り込み（例: 東京都）。指定時は selectedRegion より優先
    String? selectedPrefecture,
    @Default(false) bool isGuest,
  }) = _MapState;
}
