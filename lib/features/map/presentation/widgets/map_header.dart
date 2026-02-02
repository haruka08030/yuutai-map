import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/search_bar_theme.dart' as app_theme;
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';

const Color _kBorderLight = Color(0x7FE2E7EF);
const Color _kShadowLight = Color(0x0C000000);

class MapHeader extends StatefulWidget {
  const MapHeader({
    super.key,
    required this.state,
    required this.onFilterPressed,
    required this.onCategoryChanged,
    this.onSearchChanged,
  });

  final MapState state;
  final VoidCallback onFilterPressed;
  final void Function(Set<String> selectedCategories) onCategoryChanged;
  final void Function(String query)? onSearchChanged;

  @override
  State<MapHeader> createState() => _MapHeaderState();
}

class _MapHeaderState extends State<MapHeader> {
  final TextEditingController _searchController = TextEditingController();
  static const String _allLabel = 'すべて';

  @override
  void dispose() {
    _searchController.dispose();
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            app_theme.AppSearchBarStyle.borderRadiusValue,
                        border: Border.all(color: _kBorderLight),
                        boxShadow: const [
                          BoxShadow(
                            color: _kShadowLight,
                            blurRadius: 15,
                            offset: Offset(0, 10),
                            spreadRadius: -3,
                          ),
                          BoxShadow(
                            color: _kShadowLight,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
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
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 0,
                    shadowColor: _kShadowLight,
                    child: InkWell(
                      onTap: widget.onFilterPressed,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _kBorderLight),
                          boxShadow: const [
                            BoxShadow(
                              color: _kShadowLight,
                              blurRadius: 15,
                              offset: Offset(0, 10),
                              spreadRadius: -3,
                            ),
                            BoxShadow(
                              color: _kShadowLight,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.filter_list_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ),
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
                      selected: widget.state.selectedCategories.isEmpty,
                      onTap: () => widget.onCategoryChanged({}),
                    ),
                    ...widget.state.availableCategories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: _CategoryChip(
                          label: category,
                          selected: widget.state.selectedCategories
                              .contains(category),
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
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: selected ? null : Border.all(color: _kBorderLight),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .tertiary
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
