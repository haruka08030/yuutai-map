import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/benefit_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/benefit_list_tile.dart';
import 'package:flutter_stock/features/benefits/presentation/benefit_edit_page.dart';

class BenefitsPage extends ConsumerWidget {
  const BenefitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(userBenefitRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('優待一覧')),
      body: StreamBuilder(
        stream: repo.watchActive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            final cs = Theme.of(context).colorScheme;
            final bg = cs.primary.withValues(alpha: 0.05);
            final fg = cs.onSurface.withValues(alpha: 0.65);
            final sub = cs.onSurface.withValues(alpha: 0.45);
            return Container(
              width: double.infinity,
              height: double.infinity,
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
              return BenefitListTile(
                benefit: b,
                subtitle: b.benefitText?.isNotEmpty == true
                    ? b.benefitText
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: true,
            useSafeArea: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (ctx) => const FractionallySizedBox(
              heightFactor: 0.6,
              child: BenefitEditPage(asSheet: true),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
