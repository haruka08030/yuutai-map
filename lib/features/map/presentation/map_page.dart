import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    hide Cluster, ClusterManager;

import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/core/widgets/app_error_view.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/map/domain/constants/japanese_regions.dart';
import 'package:flutter_stock/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter_stock/features/map/presentation/map_style.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/features/map/presentation/utils/marker_generator.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_action_buttons.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_filter_bottom_sheet.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_guest_register_dialog.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_header.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_status_banner.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_store_detail_sheet.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_store_empty_state.dart';

// カメラのズームレベル
const double _initialZoom = 14;
const double _currentLocationZoom = 14.5;
const double _clusterZoomIncrement = 2;
const double _prefectureZoom = 9;
const double _regionZoom = 8;

// マーカーサイズ（クラスタ時は大きく表示）
const int _markerSizeSingle = 75;
const int _markerSizeCluster = 125;

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  late ClusterManager<Place> _clusterManager;
  Set<Marker> _markers = {};
  late final MarkerGenerator _markerGenerator;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const Map<String, Color> _categoryColors = {
    '飲食': Color(0xFFEF4444),
    'ファッション': Color(0xFF8B5CF6),
    '家電': Color(0xFF3B82F6),
    'その他': Color(0xFF6B7280),
  };

  Color _getCategoryColor(String? category) {
    if (category == null || !_categoryColors.containsKey(category)) {
      return Colors.grey;
    }
    return _categoryColors[category]!;
  }

  @override
  void initState() {
    super.initState();
    _markerGenerator = MarkerGenerator();
    _clusterManager = _initClusterManager();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ClusterManager<Place> _initClusterManager() {
    return ClusterManager<Place>(
      [],
      _updateMarkers,
      markerBuilder: (cluster) async {
        final markerColor = cluster.isMultiple
            ? Colors.orange
            : _getCategoryColor(cluster.items.first.category);
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () => _onMarkerTapped(cluster),
          icon: await _markerGenerator.getMarkerBitmap(
            cluster.isMultiple ? _markerSizeCluster : _markerSizeSingle,
            text: cluster.isMultiple ? cluster.count.toString() : null,
            color: markerColor,
          ),
        );
      },
    );
  }

  Future<void> _onMarkerTapped(Cluster<Place> cluster) async {
    final isGuest = ref.read(isGuestProvider);
    if (cluster.isMultiple) {
      final controller = await _mapController.future;
      final zoom = await controller.getZoomLevel();
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            cluster.location, zoom + _clusterZoomIncrement),
      );
      return;
    }

    final place = cluster.items.first;
    if (isGuest) {
      MapGuestRegisterDialog.show(
        context: context,
        storeName: place.name,
        onRegisterPressed: () => context.go('/'),
      );
      return;
    }

    final mapState = ref.read(mapControllerProvider).value;
    if (mapState != null) {
      await showMapStoreDetailSheet(
        context: context,
        place: place,
        currentLat: mapState.currentPosition.latitude,
        currentLng: mapState.currentPosition.longitude,
      );
    } else {
      context.push('/store/detail', extra: place);
    }
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() => _markers = markers);
  }

  Future<void> _showFilterSheet(MapState state) async {
    await MapFilterBottomSheet.show(
      context: context,
      state: state,
      onApply: (params) {
        ref.read(mapControllerProvider.notifier).applyFilters(params);
        _animateToLocation(
          prefecture: params.prefecture,
          region: params.region,
        );
      },
    );
  }

  Future<void> _animateToLocation({
    String? prefecture,
    String? region,
  }) async {
    final center = _resolveMapCenter(prefecture: prefecture, region: region);
    if (center == null) return;

    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(center.$1, center.$2),
          zoom: center.$3,
        ),
      ),
    );
  }

  /// 都道府県 or 地方からカメラ中心とズームを取得。該当なしなら null。
  (double, double, double)? _resolveMapCenter({
    String? prefecture,
    String? region,
  }) {
    if (prefecture != null &&
        prefecture.isNotEmpty &&
        JapaneseRegions.prefectureCenters.containsKey(prefecture)) {
      final c = JapaneseRegions.prefectureCenters[prefecture]!;
      if (c.length >= 2) return (c[0], c[1], _prefectureZoom);
    }
    if (region != null &&
        region.isNotEmpty &&
        JapaneseRegions.regionCenters.containsKey(region)) {
      final c = JapaneseRegions.regionCenters[region]!;
      if (c.length >= 2) return (c[0], c[1], _regionZoom);
    }
    return null;
  }

  Future<void> _goToCurrentLocation(Position position) async {
    final controller = await _mapController.future;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: _currentLocationZoom,
          ),
        ),
      );
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  List<Place> _filterPlacesBySearch(List<Place> items) {
    if (_searchQuery.isEmpty) return items;
    final query = _searchQuery.trim().toLowerCase();
    return items.where((place) {
      final name = place.name.toLowerCase();
      final address = (place.address ?? '').toLowerCase();
      final prefecture = (place.prefecture ?? '').toLowerCase();
      return name.contains(query) ||
          address.contains(query) ||
          prefecture.contains(query);
    }).toList();
  }

  void _showFilterErrorSnackBarIfNeeded(MapState state) {
    final errorMessage = state.filterError;
    if (errorMessage == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(mapControllerProvider.notifier).clearFilterError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          action: SnackBarAction(
            label: '再試行',
            onPressed: () {
              ref.read(mapControllerProvider.notifier).applyFilters(
                    state.toFilterParams(),
                  );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapStateAsync = ref.watch(mapControllerProvider);

    return mapStateAsync.when(
      data: (state) {
        final filteredPlaces = _filterPlacesBySearch(state.items);
        _clusterManager.setItems(filteredPlaces);
        final showSearchEmpty =
            _searchQuery.isNotEmpty && filteredPlaces.isEmpty;
        _showFilterErrorSnackBarIfNeeded(state);

        return Scaffold(
          body: Stack(
            children: [
              _buildGoogleMap(context, state),
              MapHeader(
                state: state,
                searchController: _searchController,
                onFilterPressed: () => _showFilterSheet(state),
                onCategoryChanged: (categories) {
                  ref.read(mapControllerProvider.notifier).applyFilters(
                        state.toFilterParams(categories: categories),
                      );
                },
                onSearchChanged: (query) {
                  setState(() => _searchQuery = query);
                },
              ),
              const MapStatusBanner(),
              if (state.isApplying) _buildApplyingOverlay(),
              if (showSearchEmpty) _buildSearchEmptyOverlay(context),
            ],
          ),
          floatingActionButton: MapActionButtons(
            onLocationPressed: () =>
                _goToCurrentLocation(state.currentPosition),
          ),
        );
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, stack) => AppErrorView(
        message: AppException.from(error).message,
        onRetry: () => ref.invalidate(mapControllerProvider),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context, MapState state) {
    return GoogleMap(
      mapType: MapType.normal,
      style: mapStyleForBrightness(Theme.of(context).brightness),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          state.currentPosition.latitude,
          state.currentPosition.longitude,
        ),
        zoom: _initialZoom,
      ),
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        if (!_mapController.isCompleted) _mapController.complete(controller);
        _clusterManager.setMapId(controller.mapId);
      },
      onCameraMove: (position) => _clusterManager.onCameraMove(position),
      onCameraIdle: () => _clusterManager.updateMap(),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }

  Widget _buildApplyingOverlay() => const Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black26,
              dismissible: false,
            ),
          ),
          Center(child: AppLoadingIndicator()),
        ],
      );

  Widget _buildSearchEmptyOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: MapStoreEmptyState(
            query: _searchQuery,
            onClearPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
          ),
        ),
      ),
    );
  }
}
