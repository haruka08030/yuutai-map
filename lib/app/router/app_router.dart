import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppRoutes { list, map, settings }

/// Riverpod から提供する GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.list.name,
        builder: (context, state) => const ListScreen(),
      ),
      GoRoute(
        path: '/map',
        name: AppRoutes.map.name,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

/// --- 以下は最低限のプレースホルダー画面 ---

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benefits')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, i) => ListTile(
          title: Text('Sample benefit #${i + 1}'),
          subtitle: const Text('Company / details / due date'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/settings'),
        child: const Icon(Icons.settings),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: const Center(child: Text('Map placeholder')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings placeholder')),
    );
  }
}
