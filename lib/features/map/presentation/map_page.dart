
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null, // No AppBar for the map
      body: Center(
        child: Text('Map Page'),
      ),
    );
  }
}
