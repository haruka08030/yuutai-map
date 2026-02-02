import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/search_bar_theme.dart' as app_theme;
import 'package:flutter_stock/features/app/presentation/widgets/app_drawer.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  // Keeping track of history and search query for initial tab might be handled by each branch's root page
  // or by passing initial state via extra if needed. For now, removing from here.
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
                  child: _AppBarSearchField(
                    controller: _yuutaiSearchController,
                    hintText: '企業名または証券コードで検索',
                    onChanged: (value) {
                      _yuutaiSearchDebounce?.cancel();
                      _yuutaiSearchDebounce = Timer(
                        const Duration(milliseconds: 250),
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
                  context.go('/yuutai');
                  Navigator.pop(context);
                },
                onHistoryTapped: () {
                  ref
                      .read(selectedFolderIdProvider.notifier)
                      .setSelectedFolderId(null);
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

class _AppBarSearchField extends StatefulWidget {
  const _AppBarSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;

  @override
  State<_AppBarSearchField> createState() => _AppBarSearchFieldState();
}

class _AppBarSearchFieldState extends State<_AppBarSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _AppBarSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: app_theme.AppSearchBarStyle.height,
      decoration: BoxDecoration(
        color: const Color(0xFFECF0F5),
        borderRadius: app_theme.AppSearchBarStyle.borderRadiusValue,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          fontSize: app_theme.AppSearchBarStyle.hintFontSize,
          fontWeight: app_theme.AppSearchBarStyle.hintFontWeight,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: app_theme.AppSearchBarStyle.hintColor,
            fontSize: app_theme.AppSearchBarStyle.hintFontSize,
            fontWeight: app_theme.AppSearchBarStyle.hintFontWeight,
          ),
          border: InputBorder.none,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: app_theme.AppSearchBarStyle.prefixIconPaddingLeft,
              right: app_theme.AppSearchBarStyle.prefixIconPaddingRight,
            ),
            child: Icon(
              Icons.search_rounded,
              size: app_theme.AppSearchBarStyle.prefixIconSize,
              color: app_theme.AppSearchBarStyle.hintColor,
            ),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: app_theme.AppSearchBarStyle.suffixIconSize,
                    color: app_theme.AppSearchBarStyle.hintColor,
                  ),
                  onPressed: widget.onClear,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: app_theme.AppSearchBarStyle.contentPaddingVertical,
          ),
        ),
      ),
    );
  }
}
