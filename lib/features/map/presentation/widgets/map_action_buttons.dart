import 'package:flutter/material.dart';

class MapActionButtons extends StatelessWidget {
  final VoidCallback onLocationPressed;

  const MapActionButtons({
    super.key,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FloatingActionButton.small(
        heroTag: 'location_fab',
        onPressed: onLocationPressed,
        tooltip: 'My Location',
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF24A19C),
        elevation: 4,
        child: const Icon(Icons.my_location, size: 20),
      ),
    );
  }
}
