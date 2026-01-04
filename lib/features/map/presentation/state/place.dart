import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
  Place({
    required this.name,
    required this.latLng,
    this.isClosed = false,
  });

  final String name;
  final bool isClosed;
  final LatLng latLng;

  @override
  LatLng get location => latLng;
}
