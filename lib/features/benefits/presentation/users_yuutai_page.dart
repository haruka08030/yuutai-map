import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';

class UsersYuutaiPage extends ConsumerWidget {
  const UsersYuutaiPage({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(usersYuutaiRepositoryProvider);

    return StreamBuilder<List<UsersYuutai>>(
      stream: repo.watchActive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var items = snapshot.data ?? const [];
        if (searchQuery.isNotEmpty) {
          items = items.where((benefit) {
            final query = searchQuery.toLowerCase();
            final title = benefit.title.toLowerCase();
            final benefitText = benefit.benefitText?.toLowerCase() ?? '';
            return title.contains(query) || benefitText.contains(query);
          }).toList();
        }

        if (items.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return const Center(child: Text('No results found.'));
          }
          final cs = Theme.of(context).colorScheme;
          final bg = cs.primary.withAlpha(12);
          final fg = cs.onSurface.withAlpha(165);
          final sub = cs.onSurface.withAlpha(114);
          return Container(
            color: bg,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: fg),
                  const SizedBox(height: 12),
                  Text('優待がありません', style: TextStyle(fontSize: 16, color: fg)),
                  const SizedBox(height: 4),
                  Text('右下の + から追加できます', style: TextStyle(color: sub)),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final b = items[index];
            return UsersYuutaiListTile(
              benefit: b,
              subtitle: (b.benefitText?.isNotEmpty ?? false)
                  ? b.benefitText
                  : null,
            );
          },
        );
      },
    );
  }
}
