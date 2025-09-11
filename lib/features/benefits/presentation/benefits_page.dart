import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/benefit_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/benefit_list_tile.dart';
import 'package:flutter_stock/features/benefits/presentation/benefit_edit_page.dart';

class BenefitsPage extends ConsumerStatefulWidget {
  const BenefitsPage({super.key});

  @override
  ConsumerState<BenefitsPage> createState() => _BenefitsPageState();
}

class _BenefitsPageState extends ConsumerState<BenefitsPage> {
  final _searchCtl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(userBenefitRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All'),
        actions: const [SizedBox(width: 8)],
      ),
      body: StreamBuilder(
        stream: repo.watchActive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? const [];
          // Filter by query
          final q = _query.trim().toLowerCase();
          final filtered = q.isEmpty
              ? items
              : items.where((b) {
                  final t = (b.title).toLowerCase();
                  final s = (b.benefitText ?? '').toLowerCase();
                  return t.contains(q) || s.contains(q);
                }).toList();
          if (items.isEmpty) {
            final cs = Theme.of(context).colorScheme;
            final bg = cs.primary.withValues(alpha: 0.05);
            final fg = cs.onSurface.withValues(alpha: 0.65);
            final sub = cs.onSurface.withValues(alpha: 0.45);
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
          return Column(
            children: [
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Builder(builder: (context) {
                  final cs = Theme.of(context).colorScheme;
                  final searchBg = cs.onSurface.withValues(alpha: 0.06);
                  final hint = cs.onSurface.withValues(alpha: 0.45);
                  final icon = cs.onSurface.withValues(alpha: 0.50);
                  return TextField(
                    controller: _searchCtl,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: searchBg,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: hint),
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: icon,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black.withValues(alpha: 0.05),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final b = filtered[index];
                          return BenefitListTile(
                            benefit: b,
                            subtitle: (b.benefitText?.isNotEmpty ?? false)
                                ? b.benefitText
                                : null,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
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
