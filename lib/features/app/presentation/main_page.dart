import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/home_search_bar.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart';
import 'package:flutter_stock/features/map/presentation/map_page.dart';
import 'package:flutter_stock/features/settings/presentation/settings_page.dart';
import 'package:flutter_stock/features/app/presentation/widgets/app_drawer.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  bool _showHistory = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar? _buildAppBar(BuildContext context, bool isLargeScreen) {
    if (_selectedIndex == 0) {
      return AppBar(
        title: CompanySearchBar(
          controller: _searchController,
        ),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider);
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 600;

    final List<Widget> widgetOptions = <Widget>[
      UsersYuutaiPage(
        searchQuery: _searchQuery,
        selectedFolderId: selectedFolderId,
        showHistory: _showHistory,
      ),
      const MapPage(),
      const SettingsPage(),
    ];

    final FloatingActionButton? fab =
        _selectedIndex == 0 && !isGuest
            ? FloatingActionButton(
                onPressed: () {
                  context.push('/yuutai/add');
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null;

    if (isLargeScreen) {
      return Scaffold(
        appBar: _buildAppBar(context, isLargeScreen),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
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
                  IndexedStack(index: _selectedIndex, children: widgetOptions),
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
        appBar: _buildAppBar(context, isLargeScreen),
        drawer: AppDrawer(
          selectedFolderId: selectedFolderId,
          onFolderSelected: (folderId) {
            ref.read(selectedFolderIdProvider.notifier).setSelectedFolderId(folderId);
            setState(() {
              _showHistory = false;
              _selectedIndex = 0;
            });
            Navigator.pop(context);
          },
          onAllCouponsTapped: () {
            ref.read(selectedFolderIdProvider.notifier).setSelectedFolderId(null);
            setState(() {
              _showHistory = false;
              _selectedIndex = 0;
            });
            Navigator.pop(context);
          },
          onHistoryTapped: () {
            ref.read(selectedFolderIdProvider.notifier).setSelectedFolderId(null);
            setState(() {
              _showHistory = true;
              _selectedIndex = 0;
            });
            Navigator.pop(context);
          },
          onMapTapped: () {
            setState(() {
              _selectedIndex = 1;
            });
            Navigator.pop(context);
          },
          onSettingsTapped: () {
            setState(() {
              _selectedIndex = 2;
            });
            Navigator.pop(context);
          },
        ),
        body: IndexedStack(index: _selectedIndex, children: widgetOptions),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: fab,
      );
    }
  }
}
