import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/core/widgets/app_error_view.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersYuutaiPage extends ConsumerStatefulWidget {
  const UsersYuutaiPage({
    super.key,
    required this.searchQuery,
    this.selectedFolderId,
    this.showHistory = false,
  });

  final String searchQuery;
  final String? selectedFolderId;
  final bool showHistory;

  @override
  ConsumerState<UsersYuutaiPage> createState() => _UsersYuutaiPageState();
}

class _UsersYuutaiPageState extends ConsumerState<UsersYuutaiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _searchQuery = widget.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(yuutaiListSettingsProvider);
    final isGuest = ref.watch(isGuestProvider);
    final settingsNotifier = ref.read(yuutaiListSettingsProvider.notifier);

    final asyncBenefits = !widget.showHistory
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    return Scaffold(
      body: Column(
        children: [
          _buildSearchAndFilterSection(context, settings, settingsNotifier),
          Expanded(
            child: asyncBenefits.when(
              loading: () => ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) =>
                    const UsersYuutaiSkeletonTile(),
              ),
              error: (err, stack) => AppErrorView(
                message: AppException.from(err).message,
                onRetry: () => ref.invalidate(activeUsersYuutaiProvider),
              ),
              data: (data) {
                var items = data;

                // Apply folder filter from URL or settings
                final effectiveFolderId =
                    widget.selectedFolderId ?? settings.folderId;
                if (effectiveFolderId != null) {
                  items = items
                      .where((benefit) => benefit.folderId == effectiveFolderId)
                      .toList();
                }

                // Apply search filter
                final searchQuery =
                    _searchQuery.isNotEmpty ? _searchQuery : widget.searchQuery;
                if (searchQuery.isNotEmpty) {
                  items = items.where((benefit) {
                    final query = searchQuery.toLowerCase();
                    final title = benefit.companyName.toLowerCase();
                    final benefitText =
                        benefit.benefitDetail?.toLowerCase() ?? '';
                    return title.contains(query) || benefitText.contains(query);
                  }).toList();
                }

                // Apply Sorting
                switch (settings.sortOrder) {
                  case YuutaiSortOrder.expiryDate:
                    // For expiryDate, we keep nulls (no expiry) at the end
                    items.sort((a, b) {
                      if (a.expiryDate == null && b.expiryDate == null) {
                        return 0;
                      }
                      if (a.expiryDate == null) {
                        return 1;
                      }
                      if (b.expiryDate == null) {
                        return -1;
                      }
                      return a.expiryDate!.compareTo(b.expiryDate!);
                    });
                    break;
                  case YuutaiSortOrder.companyName:
                    items.sort(
                      (a, b) => a.companyName.compareTo(b.companyName),
                    );
                    break;
                  case YuutaiSortOrder.createdAt:
                    // id is auto-incrementing in many cases, or we can use id as proxy for creation order
                    // If we had createdAt in UsersYuutai, we would use that.
                    // For now, let's sort by id descending (newest first)
                    items.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
                    break;
                }

                if (items.isEmpty) {
                  if (widget.showHistory) {
                    return const EmptyStateView(
                      icon: Icons.history_toggle_off,
                      title: '使用履歴がありません',
                      subtitle: '使用した優待はここに表示されます',
                    );
                  }

                  final displayQuery = _searchQuery.isNotEmpty
                      ? _searchQuery
                      : widget.searchQuery;
                  if (displayQuery.isNotEmpty) {
                    return EmptyStateView(
                      icon: Icons.search_off,
                      title: '「$displayQuery」は見つかりませんでした',
                      subtitle: '別のキーワードで試してみてください',
                    );
                  }

                  return EmptyStateView(
                    imagePath: 'assets/images/empty_state.png',
                    title: '優待を登録しよう！',
                    subtitle:
                        isGuest ? 'ログインすると優待を登録して管理できます' : '右下の「＋」ボタンから追加できます',
                  );
                }

                if (widget.showHistory) {
                  return _buildSimpleList(items);
                }

                if (settings.sortOrder == YuutaiSortOrder.expiryDate) {
                  final expiringSoon = items.where((b) {
                    if (b.expiryDate == null) return false;
                    final today = DateTime.now();
                    final diff = DateTime(
                      b.expiryDate!.year,
                      b.expiryDate!.month,
                      b.expiryDate!.day,
                    )
                        .difference(
                          DateTime(today.year, today.month, today.day),
                        )
                        .inDays;
                    return diff >= 0 && diff <= 30;
                  }).toList();

                  final others =
                      items.where((b) => !expiringSoon.contains(b)).toList();

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      if (expiringSoon.isNotEmpty) ...[
                        _buildSectionHeader(
                          context,
                          '期限間近',
                          Icons.timer_outlined,
                          const Color(0xFFEF4444),
                        ),
                        ...expiringSoon.map((b) => _buildTile(b)),
                        const SizedBox(height: 24),
                      ],
                      if (others.isNotEmpty) ...[
                        if (expiringSoon.isNotEmpty)
                          _buildSectionHeader(
                            context,
                            'すべて',
                            Icons.list_alt_rounded,
                            null,
                          ),
                        ...others.map((b) => _buildTile(b)),
                      ],
                    ],
                  );
                }

                // Plain list for other sort orders
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _buildTile(items[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/yuutai/add'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 28),
            ),
    );
  }

  Widget _buildSearchAndFilterSection(
    BuildContext context,
    YuutaiListSettings settings,
    YuutaiListSettingsNotifier notifier,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Box
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFECF0F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '企業名で検索...',
                hintStyle: GoogleFonts.outfit(
                  color: const Color(0xFF64748B),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.outfit(
                color: const Color(0xFF1E293B),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'すべて',
                  selected: true,
                  onTap: () {
                    // TODO: フィルター機能を実装
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '期限間近',
                  selected: false,
                  onTap: () {
                    // TODO: フィルター機能を実装
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '有効',
                  selected: false,
                  onTap: () {
                    // TODO: フィルター機能を実装
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '使用済み',
                  selected: false,
                  onTap: () {
                    // TODO: フィルター機能を実装
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Sort Section
          InkWell(
            onTap: () {
              _showSortOptions(context, settings, notifier);
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.sort_rounded,
                  size: 18,
                  color: AppTheme.secondaryTextColor(context),
                ),
                const SizedBox(width: 8),
                Text(
                  '並び替え：',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryTextColor(context),
                  ),
                ),
                Text(
                  _getSortLabel(settings.sortOrder),
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Color(0xFF2DD4BF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(YuutaiSortOrder sortOrder) {
    switch (sortOrder) {
      case YuutaiSortOrder.expiryDate:
        return '期限日';
      case YuutaiSortOrder.companyName:
        return '企業名';
      case YuutaiSortOrder.createdAt:
        return '登録日';
    }
  }

  void _showSortOptions(
    BuildContext context,
    YuutaiListSettings settings,
    YuutaiListSettingsNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '並び替え',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SortOption(
              label: '期限日',
              selected: settings.sortOrder == YuutaiSortOrder.expiryDate,
              onTap: () {
                notifier.setSortOrder(YuutaiSortOrder.expiryDate);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: '企業名',
              selected: settings.sortOrder == YuutaiSortOrder.companyName,
              onTap: () {
                notifier.setSortOrder(YuutaiSortOrder.companyName);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: '登録日',
              selected: settings.sortOrder == YuutaiSortOrder.createdAt,
              onTap: () {
                notifier.setSortOrder(YuutaiSortOrder.createdAt);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color? color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(UsersYuutai b) {
    return UsersYuutaiListTile(
      benefit: b,
      subtitle: (b.benefitDetail?.isNotEmpty ?? false) ? b.benefitDetail : null,
    );
  }

  Widget _buildSimpleList(List<UsersYuutai> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildTile(items[index]),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2DD4BF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  const BoxShadow(
                    color: Color(0x332DD3BE),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                    spreadRadius: -1,
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? const Color(0xFF2DD4BF)
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_rounded,
                color: Color(0xFF2DD4BF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
