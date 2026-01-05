import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

class MapFilterBottomSheet extends ConsumerStatefulWidget {
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
  ConsumerState<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();

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

class _MapFilterBottomSheetState extends ConsumerState<MapFilterBottomSheet> {
  late bool _tempShowAll;
  late Set<String> _tempSelectedCategories;
  String? _tempFolderId;

  @override
  void initState() {
    super.initState();
    _tempShowAll = widget.state.showAllStores;
    _tempSelectedCategories = Set<String>.from(widget.state.selectedCategories);
    _tempFolderId = widget.state.folderId;
  }

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(foldersProvider);

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
            if (!_tempShowAll && !widget.state.isGuest) ...[
              const SizedBox(height: 8),
              Text(
                'フォルダで絞り込み',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              foldersAsync.when(
                data: (folders) => InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _tempFolderId,
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('すべてのフォルダ'),
                        ),
                        ...folders.map((f) => DropdownMenuItem(
                              value: f.id,
                              child: Text(f.name),
                            )),
                      ],
                      onChanged: (value) => setState(() => _tempFolderId = value),
                    ),
                  ),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Text('フォルダの読み込みに失敗しました'),
              ),
              const SizedBox(height: 16),
            ],
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
                    folderId: _tempFolderId,
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
