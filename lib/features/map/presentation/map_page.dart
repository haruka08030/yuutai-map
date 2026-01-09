import 'package:flutter_stock/features/map/presentation/widgets/map_control_buttons.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter_stock/core/widgets/app_error_view.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/map/presentation/utils/marker_generator.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_action_buttons.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_filter_bottom_sheet.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_guest_register_dialog.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_status_banner.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    hide Cluster, ClusterManager;

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  late ClusterManager<Place> _clusterManager;
  Set<Marker> _markers = {};
  bool _bannerDismissed = false;
  late final MarkerGenerator _markerGenerator;

  static const Map<String, Color> _categoryColors = {
    '飲食': Color(0xFFEF4444), // Red-500
    'ファッション': Color(0xFF8B5CF6), // Violet-500
    '家電': Color(0xFF3B82F6), // Blue-500
    'その他': Color(0xFF6B7280), // Gray-500
  };

  Color _getCategoryColor(String? category) {
    if (category == null || !_categoryColors.containsKey(category)) {
      return Colors.grey; // Default color for undefined categories
    }
    return _categoryColors[category]!;
  }

  @override
  void initState() {
    _markerGenerator = MarkerGenerator();
    _clusterManager = _initClusterManager();
    super.initState();
  }

  ClusterManager<Place> _initClusterManager() {
    return ClusterManager<Place>(
      [],
      _updateMarkers,
      markerBuilder: (cluster) async {
        final Color markerColor = cluster.isMultiple
            ? Colors
                .orange // Default color for clusters
            : _getCategoryColor(cluster.items.first.category);

        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () => _onMarkerTapped(cluster),
          icon: await _markerGenerator.getMarkerBitmap(
            cluster.isMultiple ? 125 : 75,
            text: cluster.isMultiple ? cluster.count.toString() : null,
            color: markerColor,
          ),
        );
      },
    );
  }

  void _onMarkerTapped(Cluster<Place> cluster) async {
    final isGuest = ref.read(isGuestProvider);
    if (!cluster.isMultiple) {
      final place = cluster.items.first;
      if (isGuest) {
        MapGuestRegisterDialog.show(
          context: context,
          storeName: place.name,
          onRegisterPressed: () => context.go('/'),
        );
      } else {
        context.push('/store/detail', extra: place);
      }
    } else {
      final controller = await _mapController.future;
      final currentZoom = await controller.getZoomLevel();
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(cluster.location, currentZoom + 2),
      );
    }
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  Future<void> _showFilterSheet(MapState state) async {
    await MapFilterBottomSheet.show(
      context: context,
      state: state,
      onApply: ({
        required bool showAllStores,
        required Set<String> selectedCategories,
        String? folderId,
      }) {
        ref.read(mapControllerProvider.notifier).applyFilters(
              showAllStores: showAllStores,
              selectedCategories: selectedCategories,
              folderId: folderId,
            );
      },
    );
  }

  Future<void> _goToCurrentLocation(Position currentPosition) async {
    final GoogleMapController controller = await _mapController.future;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 14.5,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('現在地の取得に失敗しました: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MapState?>(mapControllerProvider.select((s) => s.value), (
      previous,
      next,
    ) {
      if (previous != null && next != null) {
        if (previous.showAllStores && !next.showAllStores) {
          // The user just switched from "all stores" to "my yuutai only"
          setState(() {
            _bannerDismissed = false;
          });
        }
      }
    });

    final mapStateAsync = ref.watch(mapControllerProvider);

    return mapStateAsync.when(
      data: (state) {
        _clusterManager.setItems(state.items);
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    state.currentPosition.latitude,
                    state.currentPosition.longitude,
                  ),
                  zoom: 14,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
                  }
                  _clusterManager.setMapId(controller.mapId);
                },
                onCameraMove: (position) =>
                    _clusterManager.onCameraMove(position),
                onCameraIdle: () => _clusterManager.updateMap(),
                myLocationEnabled: true,
                myLocationButtonEnabled: false, // Disable default button
              ),
              Positioned(
                top: 60,
                right: 16,
                child: MapControlButtons(
                  showAllStores: state.showAllStores,
                  onTogglePressed: (index) {
                    ref.read(mapControllerProvider.notifier).applyFilters(
                          showAllStores: index == 1,
                          selectedCategories: state.selectedCategories,
                          folderId: state.folderId,
                        );
                  },
                  onFilterPressed: () => _showFilterSheet(state),
                ),
              ),
              MapStatusBanner(
                showAllStores: state.showAllStores,
                isGuest: state.isGuest,
                bannerDismissed: _bannerDismissed,
                onShowAll: () {
                  ref.read(mapControllerProvider.notifier).applyFilters(
                        showAllStores: true,
                        selectedCategories: state.selectedCategories,
                        folderId: state.folderId,
                      );
                },
                onClose: () {
                  setState(() {
                    _bannerDismissed = true;
                  });
                },
              ),
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
}
