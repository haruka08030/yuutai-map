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
  final void Function(FilterParams params) onApply;

  @override
  ConsumerState<MapFilterBottomSheet> createState() =>
      _MapFilterBottomSheetState();

  static Future<void> show({
    required BuildContext context,
    required MapState state,
    required void Function(FilterParams params) onApply,
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

/// showMenu は value: null の項目選択時も null を返すため、「すべて」は sentinel で表現
const String _kAll = '';
const String _kAllFolder = '__all__';

const double _sheetTopRadius = 24;
const EdgeInsets _sheetPadding = EdgeInsets.fromLTRB(24, 12, 24, 32);
const double _sectionSpacing = 24;
const double _bottomSpacing = 40;
const double _rowSpacing = 12;
const double _guestMessageFontSize = 14;
const double _guestMessageBorderRadius = 12;
const double _applyButtonPaddingVertical = 16;

class _MapFilterBottomSheetState extends ConsumerState<MapFilterBottomSheet> {
  late bool _showAll;
  late String _category;
  late String _folderId;
  late String _region;
  late String _prefecture;

  @override
  void initState() {
    super.initState();
    _showAll = widget.state.showAllStores;
    _category =
        widget.state.categories.isEmpty ? _kAll : widget.state.categories.first;
    _folderId = widget.state.folderId ?? _kAllFolder;
    _region = widget.state.region ?? _kAll;
    _prefecture = widget.state.prefecture ?? _kAll;
  }

  List<String> get _prefectureOptions {
    if (_region != _kAll &&
        JapaneseRegions.regionToPrefectures.containsKey(_region)) {
      return JapaneseRegions.regionToPrefectures[_region]!;
    }
    return JapaneseRegions.prefectureNames;
  }

  FilterParams get _currentParams => (
        showAllStores: _showAll,
        categories: _category == _kAll ? <String>{} : {_category},
        folderId: _folderId == _kAllFolder ? null : _folderId,
        region: _region == _kAll ? null : _region,
        prefecture: _prefecture == _kAll ? null : _prefecture,
      );

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(foldersProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_sheetTopRadius),
        ),
      ),
      padding: _sheetPadding,
      child: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetDragHandle(),
              const SizedBox(height: _sectionSpacing),
              _buildStoreModeSection(),
              _buildLocationSection(),
              _buildCategorySection(),
              _buildFolderSection(foldersAsync),
              const SizedBox(height: _bottomSpacing),
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
            selectedIndex: _showAll ? 1 : 0,
            onChanged: (index) => setState(() => _showAll = index == 1),
          ),
        ),
        const SizedBox(height: _sectionSpacing),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: '場所'),
        const SizedBox(height: _rowSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectMenuButton<String>(
                value: _region,
                hint: 'すべての地方',
                items: [
                  const SelectMenuItem(value: _kAll, label: 'すべての地方'),
                  ...JapaneseRegions.regionNames.map(
                    (region) => SelectMenuItem(value: region, label: region),
                  ),
                ],
                onSelected: (value) {
                  setState(() {
                    _region = value;
                    if (value != _kAll &&
                        (!JapaneseRegions.regionToPrefectures
                                .containsKey(value) ||
                            !JapaneseRegions.regionToPrefectures[value]!
                                .contains(_prefecture))) {
                      _prefecture = _kAll;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: _rowSpacing),
            Expanded(
              child: SelectMenuButton<String>(
                value: _prefecture,
                hint: 'すべての都道府県',
                items: [
                  const SelectMenuItem(value: _kAll, label: 'すべての都道府県'),
                  ..._prefectureOptions.map(
                    (pref) => SelectMenuItem(value: pref, label: pref),
                  ),
                ],
                onSelected: (value) => setState(() => _prefecture = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: _sectionSpacing),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'カテゴリ'),
        const SizedBox(height: _rowSpacing),
        SelectMenuButton<String>(
          value: _category,
          hint: 'すべてのカテゴリ',
          items: [
            const SelectMenuItem(value: _kAll, label: 'すべてのカテゴリ'),
            ...widget.state.availableCategories.map(
              (category) => SelectMenuItem(value: category, label: category),
            ),
          ],
          onSelected: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: _sectionSpacing),
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
          const SizedBox(height: _rowSpacing),
          _buildGuestFolderMessage(context),
          const SizedBox(height: _sectionSpacing),
        ],
      );
    }
    if (_showAll) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'フォルダで絞り込み'),
        const SizedBox(height: _rowSpacing),
        foldersAsync.when(
          data: (folders) => SelectMenuButton<String>(
            value: _folderId,
            hint: 'すべてのフォルダ',
            items: [
              const SelectMenuItem(value: _kAllFolder, label: 'すべてのフォルダ'),
              ...folders
                  .where((f) => f.id != null && f.id!.isNotEmpty)
                  .map((f) => SelectMenuItem(value: f.id!, label: f.name)),
            ],
            onSelected: (value) => setState(() => _folderId = value),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('フォルダの読み込みに失敗しました'),
        ),
        const SizedBox(height: _sectionSpacing),
      ],
    );
  }

  Widget _buildGuestFolderMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_guestMessageBorderRadius),
        border: Border.all(color: AppTheme.dividerColor(context)),
      ),
      child: Text(
        'ログインするとフォルダで絞り込みができます',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: _guestMessageFontSize,
        ),
        textAlign: TextAlign.center,
      ),
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
          padding: const EdgeInsets.symmetric(vertical: _applyButtonPaddingVertical),
        ),
        child: const Text(
          '適用する',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
