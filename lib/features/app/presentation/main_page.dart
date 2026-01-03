import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/home_search_bar.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart';
import 'package:flutter_stock/features/map/presentation/map_page.dart';
import 'package:flutter_stock/features/settings/presentation/settings_page.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedFolderId; // null means "All", specific ID means filter by folder
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
      UsersYuutaiPage(
        searchQuery: _searchQuery,
        selectedFolderId: _selectedFolderId,
      ),
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
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).extension<AppColors>()?.drawerHeaderBackground ?? 
                               Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'メニュー',
                        style: TextStyle(
                          color: Theme.of(context).extension<AppColors>()?.drawerHeaderForeground ?? 
                                 Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    // Folders Section
                    _FoldersSection(
                      selectedFolderId: _selectedFolderId,
                      onFolderSelected: (folderId) {
                        setState(() {
                          _selectedFolderId = folderId;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                    // All Coupons
                    ListTile(
                      leading: const Icon(Icons.confirmation_number),
                      title: const Text('すべての優待'),
                      selected: _selectedFolderId == null,
                      onTap: () {
                        setState(() {
                          _selectedFolderId = null;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    // Map
                    ListTile(
                      leading: const Icon(Icons.map),
                      title: const Text('マップ'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    // Settings
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('設定'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                    // Used Coupons (Moved to bottom)
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('使用済み'),
                      onTap: () {
                        // TODO: Navigate to history view
                        Navigator.pop(context);
                      },
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
        floatingActionButton: fab,
      );
    }
  }
}

class _FoldersSection extends ConsumerWidget {
  const _FoldersSection({
    required this.selectedFolderId,
    required this.onFolderSelected,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return foldersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (folders) {
        if (folders.isEmpty) {
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('フォルダ'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showCreateFolderDialog(context, ref),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'フォルダ',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () => _showCreateFolderDialog(context, ref),
                  ),
                ],
              ),
            ),
            ...folders.map((folder) => ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(folder.name),
                  selected: selectedFolderId == folder.id,
                  onTap: () => onFolderSelected(folder.id),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showFolderOptions(context, ref, folder),
                  ),
                )),
          ],
        );
      },
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新しいフォルダ'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'フォルダ名',
            hintText: '例: 食事、旅行',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await ref
                    .read(folderRepositoryProvider)
                    .createFolder(controller.text.trim());
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('作成'),
          ),
        ],
      ),
    );
  }

  void _showFolderOptions(BuildContext context, WidgetRef ref, folder) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('名前を変更'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameFolderDialog(context, ref, folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('削除', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('フォルダを削除'),
                    content: Text('「${folder.name}」を削除しますか？\n中の優待は未分類になります。'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('キャンセル'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await ref.read(folderRepositoryProvider).deleteFolder(folder.id!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameFolderDialog(BuildContext context, WidgetRef ref, folder) {
    final controller = TextEditingController(text: folder.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('フォルダ名を変更'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'フォルダ名'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await ref.read(folderRepositoryProvider).updateFolder(
                      folder.id!,
                      controller.text.trim(),
                      folder.sortOrder,
                    );
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
