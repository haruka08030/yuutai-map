import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/map/data/store_repository.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;

  // Filter state
  bool _showAllStores = false;
  Set<String> _selectedCategories = {};

  List<String> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    final isGuest = ref.read(isGuestProvider);
    if (isGuest) {
      _showAllStores = true;
    }
    _init();
  }

  Future<void> _init() async {
    try {
      setState(() => _isLoading = true);
      await _determinePosition();
      await _fetchAvailableCategories();
      await _fetchStores();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchAvailableCategories() async {
    final storeRepo = ref.read(storeRepositoryProvider);
    final categories = await storeRepo.getAvailableCategories();
    if (mounted) {
      setState(() => _availableCategories = categories);
    }
  }

  Future<void> _determinePosition() async {
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

    _currentPosition = await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchStores() async {
    final storeRepo = ref.read(storeRepositoryProvider);
    final Set<Marker> markers = {};

    if (_showAllStores) {
      final stores =
          await storeRepo.getStores(categories: _selectedCategories.toList());
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
            categories: _selectedCategories.toList(),
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

    if (mounted) {
      setState(() => _markers = markers);
    }
  }

  Future<void> _showFilterSheet() async {
    bool tempShowAll = _showAllStores;
    Set<String> tempSelectedCategories = Set<String>.from(_selectedCategories);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final isGuest = ref.watch(isGuestProvider);
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
                    if (!isGuest)
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
                      children: _availableCategories.map((category) {
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
                          setState(() {
                            _showAllStores = tempShowAll;
                            _selectedCategories = tempSelectedCategories;
                          });
                          _fetchStores();
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

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    try {
      await _determinePosition();
      if (_currentPosition != null && mounted) {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 14.5,
            ),
          ),
        );
      }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _init, child: const Text('リトライ'))
          ],
        ),
      );
    }

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition != null
              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              : const LatLng(35.6895, 139.6917), // Default to Tokyo
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false, // Disable default button
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'location_fab',
            onPressed: _goToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'filter_fab',
            onPressed: _showFilterSheet,
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}
