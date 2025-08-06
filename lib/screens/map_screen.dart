import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Map<MarkerId, Marker> _markers = {};
  final String? googleMapsApiKey = dotenv.env['API_KEY'];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    // 現在地を取得
    await _determinePosition();
    if (_currentPosition == null) return;

    // 全ての店舗情報を取得
    final companiesSnapshot = await FirebaseFirestore.instance
        .collection('companies')
        .get();
    for (var companyDoc in companiesSnapshot.docs) {
      final locationsSnapshot = await companyDoc.reference
          .collection('locations')
          .get();
      for (var locationDoc in locationsSnapshot.docs) {
        final location = Location.fromFirestore(locationDoc);
        final markerId = MarkerId(location.id);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: location.address),
        );
        _markers[markerId] = marker;
      }
    }
    setState(() {});
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    _currentPosition = await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (googleMapsApiKey == null) {
      return const Center(child: Text('Error: Google Maps API key not found.'));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Benefits')),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 12,
              ),
              markers: Set<Marker>.of(_markers.values),
              myLocationEnabled: true,
            ),
    );
  }
}
