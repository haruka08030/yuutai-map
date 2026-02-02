import 'package:flutter/material.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design-accent teal from the map screen mock.
const Color _kMapAccent = Color(0xFF2DD4BF);
const Color _kBorderLight = Color(0x7FE2E7EF);
const Color _kTextPrimary = Color(0xFF1E293B);
const Color _kShadowLight = Color(0x0C000000);

class MapHeader extends StatelessWidget {
  const MapHeader({
    super.key,
    required this.state,
    required this.onFilterPressed,
    required this.onCategoryChanged,
  });

  final MapState state;
  final VoidCallback onFilterPressed;
  final void Function(Set<String> selectedCategories) onCategoryChanged;

  static const String _allLabel = 'すべて';

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
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          // TODO: open search
                        },
                        decoration: InputDecoration(
                          hintText: '店舗・優待を検索',
                          hintStyle: GoogleFonts.outfit(
                            color: const Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: _kTextPrimary,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        style: GoogleFonts.outfit(
                          color: _kTextPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                      onTap: onFilterPressed,
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
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: _kTextPrimary,
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
                      selected: state.selectedCategories.isEmpty,
                      onTap: () => onCategoryChanged({}),
                    ),
                    ...state.availableCategories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: _CategoryChip(
                          label: category,
                          selected: state.selectedCategories.contains(category),
                          onTap: () => onCategoryChanged({category}),
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
        color: selected ? _kMapAccent : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: selected ? null : Border.all(color: _kBorderLight),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x332DD3BE),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: Color(0x332DD3BE),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: -2,
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
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
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? Colors.white : _kTextPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
