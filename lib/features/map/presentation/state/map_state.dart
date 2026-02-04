import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_stock/features/map/domain/map_filter_params.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';

part 'map_state.freezed.dart';

@freezed
abstract class MapState with _$MapState {
  const MapState._();

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

  /// 現在の状態からフィルター用パラメータを組み立てる。categories だけ上書きしたい場合に使用。
  FilterParams toFilterParams({Set<String>? categories}) => (
        showAllStores: showAllStores,
        categories: categories ?? this.categories,
        folderId: folderId,
        region: region,
        prefecture: prefecture,
      );
}
