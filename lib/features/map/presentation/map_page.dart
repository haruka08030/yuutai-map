
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _determinePosition();
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
    final benefits = await ref.read(usersYuutaiRepositoryProvider).getActive();
    final storeRepo = ref.read(storeRepositoryProvider);
    final Set<Marker> markers = {};

    for (final benefit in benefits) {
      if (benefit.brandId != null || benefit.companyId != null) {
        final stores = await storeRepo.getStores(
          brandId: benefit.brandId,
          companyId: benefit.companyId,
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

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return GoogleMap(
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
    );
  }
}
