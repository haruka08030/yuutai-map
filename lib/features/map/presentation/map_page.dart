import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer();

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
    final mapStateAsync = ref.watch(mapControllerProvider);

    return mapStateAsync.when(
      data: (state) {
        return Scaffold(
          body: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                state.currentPosition.latitude,
                state.currentPosition.longitude,
              ),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
            },
            markers: state.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Disable default button
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