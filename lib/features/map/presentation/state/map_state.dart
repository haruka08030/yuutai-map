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
    required Set<String> categories,
    String? folderId,
    String? region,
    String? prefecture,
    @Default(false) bool isGuest,

    /// フィルター適用中はマップを表示したままオーバーレイでローディング表示
    @Default(false) bool isApplying,

    /// フィルター適用エラー時はマップを表示したまま SnackBar で表示
    String? filterError,
  }) = _MapState;
}
