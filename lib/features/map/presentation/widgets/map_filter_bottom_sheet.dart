import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/map/domain/constants/japanese_regions.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

class MapFilterBottomSheet extends ConsumerStatefulWidget {
  final MapState state;
  final Function({
    required bool showAllStores,
    required Set<String> selectedCategories,
    String? folderId,
    String? selectedRegion,
    String? selectedPrefecture,
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
      String? selectedRegion,
      String? selectedPrefecture,
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
  String? _tempSelectedRegion;
  String? _tempSelectedPrefecture;

  @override
  void initState() {
    super.initState();
    _tempShowAll = widget.state.showAllStores;
    _tempSelectedCategory = widget.state.selectedCategories.length <= 1
        ? widget.state.selectedCategories.firstOrNull
        : null;
    _tempFolderId = widget.state.folderId;
    _tempSelectedRegion = widget.state.selectedRegion;
    _tempSelectedPrefecture = widget.state.selectedPrefecture;
  }

  List<String> get _prefectureOptions {
    if (_tempSelectedRegion != null &&
        JapaneseRegions.regionToPrefectures.containsKey(_tempSelectedRegion)) {
      return JapaneseRegions.regionToPrefectures[_tempSelectedRegion!]!;
    }
    return JapaneseRegions.prefectureNames;
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
        child: SingleChildScrollView(
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
              if (!widget.state.isGuest) ...[
                Center(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: _tempShowAll
                                ? AppTheme.dividerColor(context)
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(4),
                            ),
                            child: InkWell(
                              onTap: () => setState(() => _tempShowAll = false),
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  '優待あり',
                                  style: TextStyle(
                                    color: _tempShowAll
                                        ? AppTheme.secondaryTextColor(context)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: _tempShowAll
                                ? Theme.of(context).colorScheme.primary
                                : AppTheme.dividerColor(context),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(4),
                              right: Radius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () => setState(() => _tempShowAll = true),
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(4),
                                right: Radius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '全店舗',
                                  style: TextStyle(
                                    color: _tempShowAll
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : AppTheme.secondaryTextColor(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (widget.state.isGuest) ...[
                Text(
                  'フォルダ',
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
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                '場所',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.dividerColor(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _tempSelectedRegion,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('すべての地方'),
                            ),
                            ...JapaneseRegions.regionNames.map(
                              (region) => DropdownMenuItem(
                                value: region,
                                child: Text(region),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _tempSelectedRegion = value;
                              if (value != null &&
                                  (_tempSelectedPrefecture == null ||
                                      !JapaneseRegions.regionToPrefectures
                                          .containsKey(value) ||
                                      !JapaneseRegions
                                          .regionToPrefectures[value]!
                                          .contains(_tempSelectedPrefecture))) {
                                _tempSelectedPrefecture = null;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.dividerColor(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _tempSelectedPrefecture,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('すべての都道府県'),
                            ),
                            ..._prefectureOptions.map(
                              (pref) => DropdownMenuItem(
                                value: pref,
                                child: Text(pref),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _tempSelectedPrefecture = value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                      selectedRegion: _tempSelectedRegion,
                      selectedPrefecture: _tempSelectedPrefecture,
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
      ),
    );
  }
}
