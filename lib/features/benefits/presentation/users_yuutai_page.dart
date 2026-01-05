import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/widgets/empty_state_view.dart';
import 'package:flutter_stock/app/widgets/app_error_view.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';



class UsersYuutaiPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBenefits = !showHistory
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    return Column(
      children: [
        Expanded(
          child: asyncBenefits.when(
            loading: () => ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const UsersYuutaiSkeletonTile(),
            ),
            error: (err, stack) => AppErrorView(
              message: AppException.from(err).message,
              onRetry: () => ref.invalidate(activeUsersYuutaiProvider),
            ),
            data: (data) {
              var items = data;
              
              // Apply folder filter
              if (selectedFolderId != null) {
                items = items.where((benefit) => benefit.folderId == selectedFolderId).toList();
              }
              
              if (searchQuery.isNotEmpty) {
                items = items.where((benefit) {
                  final query = searchQuery.toLowerCase();
                  final title = benefit.companyName.toLowerCase();
                  final benefitText =
                      benefit.benefitDetail?.toLowerCase() ?? '';
                  return title.contains(query) || benefitText.contains(query);
                }).toList();
              }

              if (items.isEmpty) {
                if (showHistory) {
                  return const EmptyStateView(
                    icon: Icons.history_toggle_off,
                    title: '使用履歴がありません',
                    subtitle: '使用した優待はここに表示されます',
                  );
                }

                if (searchQuery.isNotEmpty) {
                  return EmptyStateView(
                    icon: Icons.search_off,
                    title: '「$searchQuery」は見つかりませんでした',
                    subtitle: '別のキーワードで試してみてください',
                  );
                }

                return const EmptyStateView(
                  icon: Icons.inbox_outlined,
                  title: '優待を登録しよう！',
                  subtitle: '右下の「＋」ボタンから追加できます',
                );
              }

              if (showHistory) {
                return _buildSimpleList(items);
              }

              // Filter for active benefits only when grouping
              final expiringSoon = items.where((b) {
                if (b.expiryDate == null) return false;
                final today = DateTime.now();
                final diff = DateTime(b.expiryDate!.year, b.expiryDate!.month, b.expiryDate!.day)
                    .difference(DateTime(today.year, today.month, today.day))
                    .inDays;
                return diff >= 0 && diff <= 30;
              }).toList();

              // Sort expiring soon by date
              expiringSoon.sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));

              final others = items.where((b) => !expiringSoon.contains(b)).toList();

              return ListView(
                children: [
                  if (expiringSoon.isNotEmpty) ...[
                    _buildSectionHeader(context, '期限間近', Icons.timer_outlined, Colors.orange),
                    ...expiringSoon.map((b) => _buildTile(b)),
                    const SizedBox(height: 16),
                  ],
                  if (others.isNotEmpty) ...[
                    if (expiringSoon.isNotEmpty)
                      _buildSectionHeader(context, 'すべて', Icons.list_alt, null),
                    ...others.map((b) => _buildTile(b)),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color? color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(UsersYuutai b) {
    return Column(
      children: [
        UsersYuutaiListTile(
          benefit: b,
          subtitle: (b.benefitDetail?.isNotEmpty ?? false) ? b.benefitDetail : null,
        ),
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: AppTheme.dividerColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleList(List<UsersYuutai> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.dividerColor(context),
        ),
      ),
      itemBuilder: (context, index) {
        final b = items[index];
        return UsersYuutaiListTile(
          benefit: b,
          subtitle: (b.benefitDetail?.isNotEmpty ?? false) ? b.benefitDetail : null,
        );
      },
    );
  }
}
