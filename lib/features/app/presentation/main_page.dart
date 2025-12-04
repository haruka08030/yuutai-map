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

  AppBar? _buildAppBar(BuildContext context) {
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider);
    final List<Widget> widgetOptions = <Widget>[
      UsersYuutaiPage(searchQuery: _searchQuery),
      const MapPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: _buildAppBar(context),
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
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0 && !isGuest
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
          : null,
    );
  }
}
