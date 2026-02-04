import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/app/presentation/widgets/app_bar_search_field.dart';
import 'package:flutter_stock/features/app/presentation/widgets/app_drawer.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';

/// この幅以上で NavigationRail レイアウトに切り替える
const double _largeScreenBreakpoint = 600;

/// 検索入力のデバウンス時間（ミリ秒）
const int _searchDebounceMs = 250;

/// ボトムナビの高さ
const double _bottomNavHeight = 64;

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  final TextEditingController _yuutaiSearchController = TextEditingController();
  Timer? _yuutaiSearchDebounce;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void dispose() {
    _yuutaiSearchDebounce?.cancel();
    _yuutaiSearchController.dispose();
    super.dispose();
  }

  void _setYuutaiSearchQuery(BuildContext context, String query) {
    final currentUri =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri;
    final nextParams = Map<String, String>.from(currentUri.queryParameters);

    final normalized = query.trim();
    if (normalized.isEmpty) {
      nextParams.remove('search');
    } else {
      nextParams['search'] = normalized;
    }

    context.go(
      Uri(
        path: '/yuutai',
        queryParameters: nextParams.isEmpty ? null : nextParams,
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedFolderId = ref.watch(selectedFolderIdProvider);
    final isLargeScreen =
        MediaQuery.of(context).size.width >= _largeScreenBreakpoint;

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
      final currentUri =
          GoRouter.of(context).routerDelegate.currentConfiguration.uri;
      final currentSearch = currentUri.queryParameters['search'] ?? '';
      if (_yuutaiSearchController.text != currentSearch) {
        _yuutaiSearchController.value = TextEditingValue(
          text: currentSearch,
          selection: TextSelection.collapsed(offset: currentSearch.length),
        );
      }

      return Scaffold(
        appBar: widget.navigationShell.currentIndex == 0
            ? AppBar(
                titleSpacing: 0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: AppBarSearchField(
                    controller: _yuutaiSearchController,
                    hintText: '企業名・証券コードで検索',
                    onChanged: (value) {
                      _yuutaiSearchDebounce?.cancel();
                      _yuutaiSearchDebounce = Timer(
                        const Duration(milliseconds: _searchDebounceMs),
                        () => _setYuutaiSearchQuery(context, value),
                      );
                    },
                    onClear: () {
                      _yuutaiSearchDebounce?.cancel();
                      _yuutaiSearchController.clear();
                      _setYuutaiSearchQuery(context, '');
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      _yuutaiSearchDebounce?.cancel();
                      _setYuutaiSearchQuery(context, value);
                    },
                  ),
                ),
              )
            : null,
        drawer: widget.navigationShell.currentIndex == 0
            ? AppDrawer(
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
                  ref
                      .read(yuutaiListSettingsProvider.notifier)
                      .setListFilter(YuutaiListFilter.all);
                  context.go('/yuutai');
                  Navigator.pop(context);
                },
                onHistoryTapped: () {
                  ref
                      .read(selectedFolderIdProvider.notifier)
                      .setSelectedFolderId(null);
                  ref
                      .read(yuutaiListSettingsProvider.notifier)
                      .setListFilter(YuutaiListFilter.used);
                  context.go('/yuutai?showHistory=true');
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
              )
            : null,
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(
                      alpha: 0.12,
                    ),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            height: _bottomNavHeight,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.list_alt_rounded,
                  color: AppTheme.placeholderColor(context),
                ),
                selectedIcon: Icon(
                  Icons.list_alt_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'List',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.map_outlined,
                  color: AppTheme.placeholderColor(context),
                ),
                selectedIcon: Icon(
                  Icons.map_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Map',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: AppTheme.placeholderColor(context),
                ),
                selectedIcon: Icon(
                  Icons.settings_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
    }
  }
}
