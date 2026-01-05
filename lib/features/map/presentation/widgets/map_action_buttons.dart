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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: 'location_fab',
          onPressed: onLocationPressed,
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'filter_fab',
          onPressed: onFilterPressed,
          child: const Icon(Icons.filter_list),
        ),
      ],
    );
  }
}
