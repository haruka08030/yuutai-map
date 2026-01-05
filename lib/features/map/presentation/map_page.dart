import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_stock/features/auth/presentation/initial_auth_choice_page.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
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

  @override
  void initState() {
    _clusterManager = _initClusterManager();
    super.initState();
  }

  ClusterManager<Place> _initClusterManager() {
    return ClusterManager<Place>(
      [],
      _updateMarkers,
      markerBuilder: (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () => _onMarkerTapped(cluster),
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      },
    );
  }

  void _onMarkerTapped(Cluster<Place> cluster) async {
    final isGuest = ref.read(isGuestProvider);
    if (isGuest && !cluster.isMultiple) {
      final storeName = cluster.items.first.name;
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '「$storeName」の優待を管理するには、アカウント登録が必要です。',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      child: const Text('登録・ログイン画面へ'),
                      onPressed: () => context.go('/'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (cluster.isMultiple) {
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

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    if (kIsWeb) size = (size / 2).round();

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint1 = Paint()..color = Colors.orange;
    final paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
            size / 2 - textPainter.width / 2, size / 2 - textPainter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    // ignore: cast_nullable_to_non_nullable
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<void> _showFilterSheet(MapState currentState) async {
    bool tempShowAll = currentState.showAllStores;
    final Set<String> tempSelectedCategories =
        Set<String>.from(currentState.selectedCategories);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('フィルター',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Divider(height: 24),
                    if (!currentState.isGuest)
                      SwitchListTile(
                        title: const Text('すべての店舗を表示'),
                        subtitle: const Text('オフにすると保有優待の店舗のみ表示'),
                        value: tempShowAll,
                        onChanged: (value) =>
                            setDialogState(() => tempShowAll = value),
                      ),
                    Text('カテゴリ',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currentState.availableCategories.map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: tempSelectedCategories.contains(category),
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                tempSelectedCategories.add(category);
                              } else {
                                tempSelectedCategories.remove(category);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          ref.read(mapControllerProvider.notifier).applyFilters(
                                showAllStores: tempShowAll,
                                selectedCategories: tempSelectedCategories,
                              );
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('適用'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
    ref.listen<MapState?>(mapControllerProvider.select((s) => s.value),
        (previous, next) {
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
              if (!state.showAllStores && !state.isGuest && !_bannerDismissed)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryContainer
                            .withOpacity(0.95),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '保有優待の対象店舗のみ表示中です。',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(mapControllerProvider.notifier)
                                  .applyFilters(
                                    showAllStores: true,
                                    selectedCategories:
                                        state.selectedCategories,
                                  );
                            },
                            child: const Text('すべて表示'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _bannerDismissed = true;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'location_fab',
                onPressed: () => _goToCurrentLocation(state.currentPosition),
                child: const Icon(Icons.my_location),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'filter_fab',
                onPressed: () => _showFilterSheet(state),
                child: const Icon(Icons.filter_list),
              ),
            ],
          ),
        );
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('エラーが発生しました\n${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(mapControllerProvider),
              child: const Text('リトライ'),
            )
          ],
        ),
      ),
    );
  }
}