import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

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
  ConsumerState<MapFilterBottomSheet> createState() =>
      _MapFilterBottomSheetState();

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
      backgroundColor: Colors.transparent, // Allow custom background in builder
      builder: (context) =>
          MapFilterBottomSheet(state: state, onApply: onApply),
    );
  }
}

class _MapFilterBottomSheetState extends ConsumerState<MapFilterBottomSheet> {
  late bool _tempShowAll;
  late String? _tempSelectedCategory;
  String? _tempFolderId;

  @override
  void initState() {
    super.initState();
    _tempShowAll = widget.state.showAllStores;
    _tempSelectedCategory = widget.state.selectedCategories.length <= 1
        ? widget.state.selectedCategories.firstOrNull
        : null;
    _tempFolderId = widget.state.folderId;
  }

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(foldersProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'フィルター',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            if (!widget.state.isGuest) ...[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ToggleButtons(
                    isSelected: [!_tempShowAll, _tempShowAll],
                    onPressed: (index) {
                      setState(() {
                        _tempShowAll = index == 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    borderColor: Colors.transparent,
                    selectedBorderColor: Colors.transparent,
                    fillColor: Theme.of(context).colorScheme.primary,
                    selectedColor: Theme.of(context).colorScheme.onPrimary,
                    color: AppTheme.secondaryTextColor(context),
                    constraints: BoxConstraints(
                      minHeight: 40,
                      minWidth:
                          (MediaQuery.of(context).size.width - 48 - 4) / 2,
                    ),
                    children: const [Text('優待あり'), Text('全店舗')],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            if (widget.state.isGuest) ...[
              Text(
                'フォルダで絞り込み',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.dividerColor(context)),
                ),
                child: Text(
                  'ログインするとフォルダで絞り込みができます',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
            ] else if (!_tempShowAll) ...[
              Text(
                'フォルダで絞り込み',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              foldersAsync.when(
                data: (folders) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.dividerColor(context)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _tempFolderId,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('すべてのフォルダ'),
                        ),
                        ...folders.map(
                          (f) => DropdownMenuItem(
                            value: f.id,
                            child: Text(f.name),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _tempFolderId = value),
                    ),
                  ),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('フォルダの読み込みに失敗しました'),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              'カテゴリ',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.dividerColor(context)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _tempSelectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('すべてのカテゴリ'),
                    ),
                    ...widget.state.availableCategories.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _tempSelectedCategory = value),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    showAllStores: _tempShowAll,
                    selectedCategories: _tempSelectedCategory != null
                        ? {_tempSelectedCategory!}
                        : {},
                    folderId: _tempFolderId,
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '適用する',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
