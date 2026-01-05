import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';

class MapFilterBottomSheet extends StatefulWidget {
  final MapState state;
  final Function({
    required bool showAllStores,
    required Set<String> selectedCategories,
    String? folderId,
  }) onApply;

  const MapFilterBottomSheet({
    super.key,
    required this.state,
    required this.onApply,
  });

  @override
  State<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();

  static Future<void> show({
    required BuildContext context,
    required MapState state,
    required Function({
      required bool showAllStores,
      required Set<String> selectedCategories,
      String? folderId,
    }) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => MapFilterBottomSheet(
        state: state,
        onApply: onApply,
      ),
    );
  }
}

class _MapFilterBottomSheetState extends State<MapFilterBottomSheet> {
  late bool _tempShowAll;
  late Set<String> _tempSelectedCategories;

  @override
  void initState() {
    super.initState();
    _tempShowAll = widget.state.showAllStores;
    _tempSelectedCategories = Set<String>.from(widget.state.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'フィルター',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 24),
            if (!widget.state.isGuest)
              SwitchListTile(
                title: const Text('すべての店舗を表示'),
                subtitle: const Text('オフにすると保有優待の店舗のみ表示'),
                value: _tempShowAll,
                onChanged: (value) => setState(() => _tempShowAll = value),
              ),
            Text(
              'カテゴリ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.state.availableCategories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: _tempSelectedCategories.contains(category),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _tempSelectedCategories.add(category);
                      } else {
                        _tempSelectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(
                    showAllStores: _tempShowAll,
                    selectedCategories: _tempSelectedCategories,
                    folderId: widget.state.folderId,
                  );
                  context.pop();
                },
                child: const Text('適用'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
