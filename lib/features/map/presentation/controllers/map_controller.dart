import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/map/data/store_repository.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapControllerProvider =
    AsyncNotifierProvider<MapController, MapState>(() {
  return MapController();
});

class MapController extends AsyncNotifier<MapState> {
  @override
  Future<MapState> build() async {
    final isGuest = ref.watch(isGuestProvider);
    final currentPosition = await _determinePosition();
    final availableCategories = await _fetchAvailableCategories();

    final initialState = MapState(
      markers: const {},
      currentPosition: currentPosition,
      availableCategories: availableCategories,
      showAllStores: isGuest, // Default to all stores for guests
      selectedCategories: const {},
      isGuest: isGuest,
    );

    // Fetch initial markers and update state
    final markers = await _fetchMarkers(
      showAllStores: initialState.showAllStores,
      selectedCategories: initialState.selectedCategories,
    );
    return initialState.copyWith(markers: markers);
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
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return Geolocator.getCurrentPosition();
  }

  Future<List<String>> _fetchAvailableCategories() async {
    final storeRepo = ref.read(storeRepositoryProvider);
    return storeRepo.getAvailableCategories();
  }

  Future<Set<Marker>> _fetchMarkers({
    required bool showAllStores,
    required Set<String> selectedCategories,
  }) async {
    final storeRepo = ref.read(storeRepositoryProvider);
    final Set<Marker> markers = {};

    if (showAllStores) {
      final stores =
          await storeRepo.getStores(categories: selectedCategories.toList());
      for (final store in stores) {
        markers.add(Marker(
          markerId: MarkerId(store.id.toString()),
          position: LatLng(store.latitude, store.longitude),
          infoWindow: InfoWindow(title: store.name),
        ));
      }
    } else {
      final benefits =
          await ref.read(usersYuutaiRepositoryProvider).getActive();
      for (final benefit in benefits) {
        if (benefit.companyId != null) {
          final stores = await storeRepo.getStores(
            companyId: benefit.companyId.toString(),
            categories: selectedCategories.toList(),
          );
          for (final store in stores) {
            markers.add(Marker(
              markerId: MarkerId(store.id.toString()),
              position: LatLng(store.latitude, store.longitude),
              infoWindow: InfoWindow(title: store.name),
            ));
          }
        }
      }
    }
    return markers;
  }

  Future<void> applyFilters({
    required bool showAllStores,
    required Set<String> selectedCategories,
  }) async {
    final oldState = await future;
    // ignore: invalid_use_of_internal_member
    state = const AsyncLoading<MapState>().copyWithPrevious(AsyncData(oldState));

    try {
      final markers = await _fetchMarkers(
        showAllStores: showAllStores,
        selectedCategories: selectedCategories,
      );
      state = AsyncData(oldState.copyWith(
        markers: markers,
        showAllStores: showAllStores,
        selectedCategories: selectedCategories,
      ));
    } catch (e, st) {
      // ignore: invalid_use_of_internal_member
      state = AsyncError<MapState>(e, st).copyWithPrevious(AsyncData(oldState));
    }
  }
}
