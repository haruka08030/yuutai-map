import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/app/presentation/widgets/app_drawer.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart'; // Assuming this provides selectedFolderIdProvider

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  // Keeping track of history and search query for initial tab might be handled by each branch's root page
  // or by passing initial state via extra if needed. For now, removing from here.

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 600;

    if (isLargeScreen) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              labelType: NavigationRailLabelType.none,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.map),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text(''),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Stack(
                children: [
                  widget
                      .navigationShell, // Displays the currently selected branch
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: widget.navigationShell.currentIndex == 0
            ? AppBar(
                title: const Text(''),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              )
            : null,
        drawer: AppDrawer(
          selectedFolderId: selectedFolderId,
          onFolderSelected: (folderId) {
            ref
                .read(selectedFolderIdProvider.notifier)
                .setSelectedFolderId(folderId);
            context.go('/yuutai?folderId=$folderId');
            Navigator.pop(context);
          },
          onAllCouponsTapped: () {
            ref
                .read(selectedFolderIdProvider.notifier)
                .setSelectedFolderId(null);
            context.go('/yuutai'); // Navigate to yuutai with no specific filter
            Navigator.pop(context);
          },
          onHistoryTapped: () {
            ref
                .read(selectedFolderIdProvider.notifier)
                .setSelectedFolderId(null);
            context.go(
              '/yuutai?showHistory=true',
            ); // Navigate to yuutai showing history
            Navigator.pop(context);
          },
          onMapTapped: () {
            _goBranch(1);
            Navigator.pop(context);
          },
          onSettingsTapped: () {
            _goBranch(2);
            Navigator.pop(context);
          },
        ),
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          indicatorColor: const Color(0xFF24A19C).withValues(alpha: 0.1),
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.list_alt_rounded, color: Color(0xFF9CA3AF)),
              selectedIcon: Icon(
                Icons.list_alt_rounded,
                color: Color(0xFF24A19C),
              ),
              label: 'List',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined, color: Color(0xFF9CA3AF)),
              selectedIcon: Icon(Icons.map_rounded, color: Color(0xFF24A19C)),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Color(0xFF9CA3AF)),
              selectedIcon: Icon(
                Icons.settings_rounded,
                color: Color(0xFF24A19C),
              ),
              label: 'Settings',
            ),
          ],
        ),
      );
    }
  }
}
