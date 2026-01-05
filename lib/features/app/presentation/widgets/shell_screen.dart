import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/app/presentation/widgets/app_drawer.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart'; // Assuming this provides selectedFolderIdProvider
import 'package:flutter_stock/features/auth/data/auth_repository.dart'; // Assuming this provides isGuestProvider

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({
    super.key,
    required this.navigationShell,
  });

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
    final isGuest = ref.watch(isGuestProvider);
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 600;

    // TODO: Add FloatingActionButton logic here if needed.
    // This will likely involve checking the current route or branch to decide
    // if a FAB should be shown and what it should do.
    final FloatingActionButton? fab =
        widget.navigationShell.currentIndex == 0 && !isGuest
            ? FloatingActionButton(
                onPressed: () {
                  context.push('/yuutai/add'); // Assumes /yuutai/add is directly accessible or handled by a specific branch
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null;

    if (isLargeScreen) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_getAppBarTitle(widget.navigationShell.currentIndex)),
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  label: Text('優待'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.map),
                  label: Text('マップ'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('設定'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Stack(
                children: [
                  widget.navigationShell, // Displays the currently selected branch
                  if (fab != null)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: fab,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_getAppBarTitle(widget.navigationShell.currentIndex)),
        ),
        drawer: AppDrawer(
          selectedFolderId: selectedFolderId,
          onFolderSelected: (folderId) {
            ref.read(selectedFolderIdProvider.notifier).setSelectedFolderId(folderId);
            context.go('/yuutai?folderId=$folderId');
            Navigator.pop(context);
          },
          onAllCouponsTapped: () {
            ref.read(selectedFolderIdProvider.notifier).setSelectedFolderId(null);
            context.go('/yuutai'); // Navigate to yuutai with no specific filter
            Navigator.pop(context);
          },
          onHistoryTapped: () {
            ref.read(selectedFolderIdProvider.notifier).setSelectedFolderId(null);
            context.go('/yuutai?showHistory=true'); // Navigate to yuutai showing history
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
        body: widget.navigationShell, // Displays the currently selected branch
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '優待'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'マップ'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
          ],
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _goBranch,
        ),
        floatingActionButton: fab,
      );
    }
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '優待リスト';
      case 1:
        return 'マップ';
      case 2:
        return '設定';
      default:
        return 'Yuutai';
    }
  }
}
