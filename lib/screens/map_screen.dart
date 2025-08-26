import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stock/models/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String? googleMapsApiKey = dotenv.env['API_KEY']; // 既存のまま
  final _sb = Supabase.instance.client;

  GoogleMapController? _controller;
  Position? _currentPosition;
  final Map<MarkerId, Marker> _markers = {};

  // 連打抑制用
  LatLngBounds? _lastBoundsFetched;

  @override
  void initState() {
    super.initState();
    _ensureLocationAndInit();
  }

  Future<void> _ensureLocationAndInit() async {
    await _determinePosition();
    if (_currentPosition == null) return;

    // 初期読み込み：現在地を中心にある程度の範囲をフェッチ
    final center = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
    final bounds = _approxBounds(center, 12); // zoom ~12 の概算 bbox
    await _fetchAndRender(bounds);
    setState(() {});
  }

  /// 概算でズーム→bboxを作る（厳密でなくてOK）
  LatLngBounds _approxBounds(LatLng center, double zoom) {
    // 緯度経度 1度あたりの距離は緯度で変わるが簡易に計算
    // ここでは zoom 12 で ~20km 四方になる程度の係数で概算
    const latDelta = 0.25; // 適宜調整
    final lngDelta = 0.25 / cos(center.latitude * pi / 180.0);
    return LatLngBounds(
      southwest: LatLng(
        center.latitude - latDelta,
        center.longitude - lngDelta,
      ),
      northeast: LatLng(
        center.latitude + latDelta,
        center.longitude + lngDelta,
      ),
    );
  }

  Future<void> _fetchAndRender(LatLngBounds bounds) async {
    // 同じ範囲を連続で叩かない
    if (_lastBoundsFetched != null &&
        _similarBounds(_lastBoundsFetched!, bounds)) {
      return;
    }
    _lastBoundsFetched = bounds;

    // bbox でクエリ（lat/lng の between）
    final rows = await _sb
        .from('store')
        .select('id, name, address, lat, lng')
        .gte('lat', bounds.southwest.latitude)
        .lte('lat', bounds.northeast.latitude)
        .gte('lng', bounds.southwest.longitude)
        .lte('lng', bounds.northeast.longitude);

    final list = (rows as List)
        .map((r) => Location.fromMap(Map<String, dynamic>.from(r)))
        .toList();

    // Marker 化
    final map = <MarkerId, Marker>{};
    for (final loc in list) {
      final id = MarkerId(loc.id);
      map[id] = Marker(
        markerId: id,
        position: LatLng(loc.latitude, loc.longitude),
        infoWindow: InfoWindow(
          title: loc.name.isEmpty ? loc.address : loc.name,
          snippet: loc.address,
        ),
      );
    }

    setState(() {
      _markers
        ..clear()
        ..addAll(map);
    });
  }

  bool _similarBounds(LatLngBounds a, LatLngBounds b) {
    // ほんの少しの移動なら同じとみなす（サーバー負荷軽減）
    const eps = 0.01;
    bool close(double x, double y) => (x - y).abs() < eps;
    return close(a.southwest.latitude, b.southwest.latitude) &&
        close(a.southwest.longitude, b.southwest.longitude) &&
        close(a.northeast.latitude, b.northeast.latitude) &&
        close(a.northeast.longitude, b.northeast.longitude);
  }

  Future<void> _determinePosition() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (googleMapsApiKey == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Google Maps API key not found.')),
      );
    }
    if (_currentPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final start = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Benefits')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: start, zoom: 12),
        markers: Set<Marker>.of(_markers.values),
        myLocationEnabled: true,
        onMapCreated: (c) => _controller = c,
        onCameraIdle: () async {
          if (_controller == null) return;
          final bounds = await _controller!.getVisibleRegion();
          await _fetchAndRender(bounds);
        },
      ),
    );
  }
}
