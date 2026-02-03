import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:flutter_stock/core/widgets/section_label.dart';
import 'package:flutter_stock/core/widgets/segmented_control.dart';
import 'package:flutter_stock/core/widgets/select_menu_button.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/features/map/domain/constants/japanese_regions.dart';
import 'package:flutter_stock/features/map/domain/map_filter_params.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';

class MapFilterBottomSheet extends ConsumerStatefulWidget {
  const MapFilterBottomSheet({
    super.key,
    required this.state,
    required this.onApply,
  });

  final MapState state;
  final void Function(MapFilterParams params) onApply;

  @override
  ConsumerState<MapFilterBottomSheet> createState() =>
      _MapFilterBottomSheetState();

  static Future<void> show({
    required BuildContext context,
    required MapState state,
    required void Function(MapFilterParams params) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          MapFilterBottomSheet(state: state, onApply: onApply),
    );
  }
}

/// showMenu は value: null の項目選択時も null を返すため、「すべて」は sentinel で表現する
const String _kAllLocation = '';
const String _kAllFolderId = '__all__';

class _MapFilterBottomSheetState extends ConsumerState<MapFilterBottomSheet> {
  late bool _tempShowAll;
  late String _tempSelectedCategory;
  late String _tempFolderId;
  late String _tempSelectedRegion;
  late String _tempSelectedPrefecture;

  @override
  void initState() {
    super.initState();
    _tempShowAll = widget.state.showAllStores;
    _tempSelectedCategory = widget.state.selectedCategories.isEmpty
        ? _kAllLocation
        : widget.state.selectedCategories.first;
    _tempFolderId = widget.state.folderId ?? _kAllFolderId;
    _tempSelectedRegion = widget.state.selectedRegion ?? _kAllLocation;
    _tempSelectedPrefecture = widget.state.selectedPrefecture ?? _kAllLocation;
  }

  List<String> get _prefectureOptions {
    if (_tempSelectedRegion != _kAllLocation &&
        JapaneseRegions.regionToPrefectures.containsKey(_tempSelectedRegion)) {
      return JapaneseRegions.regionToPrefectures[_tempSelectedRegion]!;
    }
    return JapaneseRegions.prefectureNames;
  }

  MapFilterParams get _currentParams => (
        showAllStores: _tempShowAll,
        selectedCategories: _tempSelectedCategory == _kAllLocation
            ? <String>{}
            : {_tempSelectedCategory},
        folderId: _tempFolderId == _kAllFolderId ? null : _tempFolderId,
        selectedRegion:
            _tempSelectedRegion == _kAllLocation ? null : _tempSelectedRegion,
        selectedPrefecture: _tempSelectedPrefecture == _kAllLocation
            ? null
            : _tempSelectedPrefecture,
      );

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
              const BottomSheetDragHandle(),
              const SizedBox(height: 24),
              _buildStoreModeSection(),
              _buildLocationSection(),
              _buildCategorySection(),
              _buildFolderSection(foldersAsync),
              const SizedBox(height: 40),
              _buildApplyButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreModeSection() {
    if (widget.state.isGuest) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SegmentedControl(
            labels: const ['優待あり', '全店舗'],
            selectedIndex: _tempShowAll ? 1 : 0,
            onChanged: (index) => setState(() => _tempShowAll = index == 1),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: '場所'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectMenuButton<String>(
                value: _tempSelectedRegion,
                hint: 'すべての地方',
                items: [
                  const SelectMenuItem(value: _kAllLocation, label: 'すべての地方'),
                  ...JapaneseRegions.regionNames.map(
                    (region) => SelectMenuItem(value: region, label: region),
                  ),
                ],
                onSelected: (value) {
                  setState(() {
                    _tempSelectedRegion = value;
                    if (value != _kAllLocation &&
                        (!JapaneseRegions.regionToPrefectures
                                .containsKey(value) ||
                            !JapaneseRegions.regionToPrefectures[value]!
                                .contains(_tempSelectedPrefecture))) {
                      _tempSelectedPrefecture = _kAllLocation;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SelectMenuButton<String>(
                value: _tempSelectedPrefecture,
                hint: 'すべての都道府県',
                items: [
                  const SelectMenuItem(value: _kAllLocation, label: 'すべての都道府県'),
                  ..._prefectureOptions.map(
                    (pref) => SelectMenuItem(value: pref, label: pref),
                  ),
                ],
                onSelected: (value) =>
                    setState(() => _tempSelectedPrefecture = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'カテゴリ'),
        const SizedBox(height: 12),
        SelectMenuButton<String>(
          value: _tempSelectedCategory,
          hint: 'すべてのカテゴリ',
          items: [
            const SelectMenuItem(value: _kAllLocation, label: 'すべてのカテゴリ'),
            ...widget.state.availableCategories.map(
              (category) => SelectMenuItem(value: category, label: category),
            ),
          ],
          onSelected: (value) => setState(() => _tempSelectedCategory = value),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFolderSection(AsyncValue foldersAsync) {
    if (widget.state.isGuest) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'フォルダ'),
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
        ],
      );
    }
    if (_tempShowAll) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'フォルダで絞り込み'),
        const SizedBox(height: 12),
        foldersAsync.when(
          data: (folders) => SelectMenuButton<String>(
            value: _tempFolderId,
            hint: 'すべてのフォルダ',
            items: [
              const SelectMenuItem(value: _kAllFolderId, label: 'すべてのフォルダ'),
              ...folders
                  .where((f) => f.id != null && f.id!.isNotEmpty)
                  .map((f) => SelectMenuItem(value: f.id!, label: f.name)),
            ],
            onSelected: (value) => setState(() => _tempFolderId = value),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('フォルダの読み込みに失敗しました'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onApply(_currentParams);
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
    );
  }
}
