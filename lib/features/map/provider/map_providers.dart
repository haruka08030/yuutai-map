import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';

final mapControllerProvider = AsyncNotifierProvider<MapController, MapState>(
  () {
    return MapController();
  },
);
