import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/map/data/store_repository.dart';
import 'package:flutter_stock/features/map/domain/constants/japanese_regions.dart';
import 'package:flutter_stock/features/map/domain/entities/store.dart';
import 'package:flutter_stock/features/map/domain/map_filter_params.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapControllerProvider = AsyncNotifierProvider<MapController, MapState>(
  () {
    return MapController();
  },
);

class MapController extends AsyncNotifier<MapState> {
  @override
  Future<MapState> build() async {
    ref.listen<String?>(selectedFolderIdProvider, (prev, next) {
      if (state.value != null && prev != next) {
        final s = state.value!;
        applyFilters((
          showAllStores: s.showAllStores,
          categories: s.categories,
          folderId: next,
          region: s.region,
          prefecture: s.prefecture,
        ));
      }
    });

    final isGuest = ref.watch(isGuestProvider);
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final currentPosition = await _determinePosition();
    final availableCategories = await _fetchAvailableCategories();

    final initialState = MapState(
      items: const [],
      currentPosition: currentPosition,
      availableCategories: availableCategories,
      showAllStores: isGuest,
      categories: const {},
      isGuest: isGuest,
      folderId: selectedFolderId,
      region: null,
      prefecture: null,
    );

    // Fetch initial items and update state
    final items = await _fetchItems(
      showAllStores: initialState.showAllStores,
      categories: initialState.categories,
      folderId: initialState.folderId,
      region: initialState.region,
      prefecture: initialState.prefecture,
    );
    return initialState.copyWith(items: items);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return Geolocator.getCurrentPosition();
  }

  Future<List<String>> _fetchAvailableCategories() async {
    final storeRepo = ref.read(storeRepositoryProvider);
    return storeRepo.getAvailableCategories();
  }

  static Place _placeFromStore(Store store) {
    return Place(
      id: store.id,
      name: store.name,
      latLng: LatLng(store.latitude, store.longitude),
      category: store.category,
      address: store.address,
      prefecture: store.prefecture,
      companyId: store.companyId,
    );
  }

  List<String>? _prefecturesFromLocation({
    String? region,
    String? prefecture,
  }) {
    if (prefecture != null && prefecture.isNotEmpty) {
      return [prefecture];
    }
    if (region != null &&
        region.isNotEmpty &&
        JapaneseRegions.regionToPrefectures.containsKey(region)) {
      return JapaneseRegions.regionToPrefectures[region]!.toList();
    }
    return null;
  }

  Future<List<Place>> _fetchItems({
    required bool showAllStores,
    required Set<String> categories,
    String? folderId,
    String? region,
    String? prefecture,
  }) async {
    final storeRepo = ref.read(storeRepositoryProvider);
    final prefectures = _prefecturesFromLocation(
      region: region,
      prefecture: prefecture,
    );
    final List<Place> items = [];

    if (showAllStores) {
      final stores = await storeRepo.getStores(
        categories: categories.toList(),
        prefectures: prefectures,
      );
      items.addAll(stores.map(_placeFromStore));
    } else {
      var benefits = await ref.read(usersYuutaiRepositoryProvider).getActive();
      if (folderId != null) {
        benefits = benefits.where((b) => b.folderId == folderId).toList();
      }
      for (final benefit in benefits) {
        if (benefit.companyId != null) {
          final stores = await storeRepo.getStores(
            companyId: benefit.companyId.toString(),
            categories: categories.toList(),
            prefectures: prefectures,
          );
          items.addAll(stores.map(_placeFromStore));
        }
      }
    }
    return items;
  }

  /// フィルター適用中・エラー時も前のマップを表示したままにする（UX優先）
  Future<void> applyFilters(FilterParams params) async {
    final oldState = state.value;
    if (oldState == null) {
      state = const AsyncLoading<MapState>();
      try {
        final items = await _fetchItems(
          showAllStores: params.showAllStores,
          categories: params.categories,
          folderId: params.folderId,
          region: params.region,
          prefecture: params.prefecture,
        );
        final base = await future;
        state = AsyncData(
          base.copyWith(
            items: items,
            showAllStores: params.showAllStores,
            categories: params.categories,
            folderId: params.folderId,
            region: params.region,
            prefecture: params.prefecture,
          ),
        );
      } catch (e, st) {
        state = AsyncError<MapState>(e, st);
      }
      return;
    }

    state = AsyncData(
      oldState.copyWith(
        isApplying: true,
        filterError: null,
      ),
    );

    try {
      final items = await _fetchItems(
        showAllStores: params.showAllStores,
        categories: params.categories,
        folderId: params.folderId,
        region: params.region,
        prefecture: params.prefecture,
      );
      state = AsyncData(
        oldState.copyWith(
          items: items,
          showAllStores: params.showAllStores,
          categories: params.categories,
          folderId: params.folderId,
          region: params.region,
          prefecture: params.prefecture,
          isApplying: false,
          filterError: null,
        ),
      );
    } catch (e, _) {
      state = AsyncData(
        oldState.copyWith(
          isApplying: false,
          filterError: AppException.from(e).message,
        ),
      );
    }
  }

  void clearFilterError() {
    final value = state.value;
    if (value != null && value.filterError != null) {
      state = AsyncData(value.copyWith(filterError: null));
    }
  }
}
