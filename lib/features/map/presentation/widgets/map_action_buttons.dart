import 'package:flutter/material.dart';

const Color _kMapFabAccent = Color(0xFF2DD4BF);
const Color _kMapFabBorder = Color(0x7FE2E7EF);
const Color _kMapFabShadow = Color(0x19000000);

class MapActionButtons extends StatelessWidget {
  final VoidCallback onLocationPressed;

  const MapActionButtons({
    super.key,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, bottom: 24),
      child: _MapActionButton(
        onPressed: onLocationPressed,
        tooltip: '現在地',
        icon: Icons.my_location_rounded,
        iconSize: 28,
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  const _MapActionButton({
    required this.onPressed,
    required this.tooltip,
    required this.icon,
    this.iconSize = 24,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: _kMapFabShadow,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _kMapFabBorder),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: _kMapFabAccent,
          ),
        ),
      ),
    );
  }
}
