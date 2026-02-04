import 'package:flutter/material.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/theme/search_bar_theme.dart' as app_theme;
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';

class MapHeader extends StatefulWidget {
  const MapHeader({
    super.key,
    required this.state,
    this.searchController,
    required this.onFilterPressed,
    required this.onCategoryChanged,
    this.onSearchChanged,
  });

  final MapState state;

  /// 検索欄。渡すと親でクリア可能（0件時の「検索をクリア」と同期）
  final TextEditingController? searchController;
  final VoidCallback onFilterPressed;
  final void Function(Set<String> categories) onCategoryChanged;
  final void Function(String query)? onSearchChanged;

  @override
  State<MapHeader> createState() => _MapHeaderState();
}

class _MapHeaderState extends State<MapHeader> {
  late final TextEditingController _searchController;
  static const String _allLabel = 'すべて';

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar + filter button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: app_theme.AppSearchBarStyle.height,
                      decoration:
                          app_theme.AppSearchBarStyle.containerDecoration(
                              context),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                          widget.onSearchChanged?.call(value);
                        },
                        decoration: app_theme.AppSearchBarStyle.inputDecoration(
                          hintText: '店舗を検索',
                          suffixIcon: _searchController.text.isNotEmpty
                              ? app_theme.AppSearchBarStyle.clearIcon(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      widget.onSearchChanged?.call('');
                                    });
                                  },
                                )
                              : null,
                          prefixIconColor:
                              Theme.of(context).colorScheme.onSurface,
                        ).copyWith(
                          hintText: 'エリア・店舗名で検索',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: app_theme.AppSearchBarStyle.hintColor,
                                fontSize:
                                    app_theme.AppSearchBarStyle.hintFontSize,
                                fontWeight:
                                    app_theme.AppSearchBarStyle.hintFontWeight,
                              ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize:
                                  app_theme.AppSearchBarStyle.hintFontSize,
                              fontWeight:
                                  app_theme.AppSearchBarStyle.hintFontWeight,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _FilterIconButton(
                    hasActiveFilter: _hasActiveFilter(widget.state),
                    onTap: widget.onFilterPressed,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Category chips
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: _allLabel,
                      selected: widget.state.categories.isEmpty,
                      onTap: () => widget.onCategoryChanged({}),
                    ),
                    ...widget.state.availableCategories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: _CategoryChip(
                          label: category,
                          selected: widget.state.categories.contains(category),
                          onTap: () => widget.onCategoryChanged({category}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 地方・都道府県・カテゴリ・フォルダのいずれかが適用されていれば true
  static bool _hasActiveFilter(MapState state) {
    if (state.region != null || state.prefecture != null) {
      return true;
    }
    if (state.categories.isNotEmpty) return true;
    if (!state.showAllStores && state.folderId != null) return true;
    return false;
  }
}

/// フィルターボタン。適用中は塗りつぶしアイコン＋primary色で表現
class _FilterIconButton extends StatelessWidget {
  const _FilterIconButton({
    required this.hasActiveFilter,
    required this.onTap,
  });

  final bool hasActiveFilter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor =
        isDark ? theme.colorScheme.surfaceContainerHighest : Colors.white;
    final borderColor = isDark
        ? theme.colorScheme.outlineVariant
        : app_theme.AppSearchBarStyle.borderLight;
    final shadowColor = isDark
        ? theme.colorScheme.shadow.withValues(alpha: 0.08)
        : app_theme.AppSearchBarStyle.shadowLight;
    return Material(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      elevation: 0,
      shadowColor: shadowColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: isDark
                    ? theme.colorScheme.shadow.withValues(alpha: 0.06)
                    : app_theme.AppSearchBarStyle.shadowLight,
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Icon(
            hasActiveFilter
                ? Icons.filter_alt_rounded
                : Icons.filter_list_rounded,
            color: hasActiveFilter
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.primary : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: selected
            ? null
            : Border.all(
                color: isDark
                    ? theme.colorScheme.outlineVariant
                    : app_theme.AppSearchBarStyle.borderLight,
              ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: -2,
                ),
              ]
            : [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.06),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                  spreadRadius: -1,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected
                          ? Theme.of(context).colorScheme.onTertiary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
