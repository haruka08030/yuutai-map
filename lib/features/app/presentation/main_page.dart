import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/home_search_bar.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart';
import 'package:flutter_stock/features/map/presentation/map_page.dart';
import 'package:flutter_stock/features/settings/presentation/settings_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
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
    } else if (_selectedIndex == 1) {
      // 地図タブではAppBarを非表示
      return null;
    } else {
      return AppBar(
        title: const Text(''),
        // On large screens, settings page might not need a drawer button
        leading: isLargeScreen ? null : null, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider);
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 600;

    final List<Widget> widgetOptions = <Widget>[
      UsersYuutaiPage(searchQuery: _searchQuery),
      const MapPage(),
      const SettingsPage(),
    ];

    final FloatingActionButton? fab =
        _selectedIndex == 0 && !isGuest // Only show FAB on the benefits page for non-guests
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UsersYuutaiEditPage(),
                    ),
                  );
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              )
            : null;

    if (isLargeScreen) {
      // Build for large screens with NavigationRail
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
              child: Stack( // Use Stack to position FAB on top of content
                children: [
                  IndexedStack(index: _selectedIndex, children: widgetOptions),
                  if (fab != null) // Position FAB if it exists
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
      // Build for small screens with BottomNavigationBar
      return Scaffold(
        appBar: _buildAppBar(context, isLargeScreen),
        drawer: isGuest
            ? null
            : Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Text(
                        'メニュー',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('ログアウト'),
                      onTap: () async {
                        await ref.read(authRepositoryProvider).signOut();
                        // AuthGate will handle navigation
                      },
                    ),
                  ],
                ),
              ),
        body: IndexedStack(index: _selectedIndex, children: widgetOptions),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '優待'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'マップ'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: fab,
      );
    }
  }
}
