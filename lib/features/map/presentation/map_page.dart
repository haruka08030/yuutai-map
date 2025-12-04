
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _showAllStores = false;
  List<String> _availableCategories = [];
  Set<String> _selectedCategories = {};

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
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      await _determinePosition();
      await _fetchAvailableCategories();
      await _fetchStores();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAvailableCategories() async {
    final storeRepo = ref.read(storeRepositoryProvider);
    final categories = await storeRepo.getAvailableCategories();
    setState(() {
      _availableCategories = categories;
    });
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
      final stores = await storeRepo.getStores(
        categories: _selectedCategories.toList(),
      );
      for (final store in stores) {
        markers.add(
          Marker(
            markerId: MarkerId(store.id.toString()),
            position: LatLng(store.latitude, store.longitude),
            infoWindow: InfoWindow(title: store.name),
          ),
        );
      }
    } else {
      final benefits = await ref.read(usersYuutaiRepositoryProvider).getActive();
      for (final benefit in benefits) {
        if (benefit.companyId != null) {
          final stores = await storeRepo.getStores(
            companyId: benefit.companyId.toString(),
            categories: _selectedCategories.toList(),
          );

          for (final store in stores) {
            markers.add(
              Marker(
                markerId: MarkerId(store.id.toString()),
                position: LatLng(store.latitude, store.longitude),
                infoWindow: InfoWindow(title: store.name),
              ),
            );
          }
        }
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider);
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
      ));
    }

    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _currentPosition != null
                ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                : const LatLng(35.6895, 139.6917), // Default to Tokyo
            zoom: 14,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!isGuest)
                FilterChip(
                  label: Text(_showAllStores ? 'すべての店舗' : '保有優待の店舗'),
                  selected: _showAllStores,
                  onSelected: (selected) {
                    setState(() {
                      _showAllStores = selected;
                    });
                    _fetchStores();
                  },
                ),
              ..._availableCategories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategories.contains(category),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                    _fetchStores();
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
