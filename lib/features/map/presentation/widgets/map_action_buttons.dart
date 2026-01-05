import 'package:flutter/material.dart';

class MapActionButtons extends StatelessWidget {
  final VoidCallback onLocationPressed;
  final VoidCallback onFilterPressed;

  const MapActionButtons({
    super.key,
    required this.onLocationPressed,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'location_fab',
            onPressed: onLocationPressed,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF24A19C),
            elevation: 4,
            child: const Icon(Icons.my_location, size: 20),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'filter_fab',
            onPressed: onFilterPressed,
            backgroundColor: const Color(0xFF24A19C),
            foregroundColor: Colors.white,
            elevation: 6,
            child: const Icon(Icons.filter_list_rounded, size: 28),
          ),
        ],
      ),
    );
  }
}
