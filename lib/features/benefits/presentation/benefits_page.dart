import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/auth/presentation/auth_gate.dart';
import 'package:flutter_stock/features/benefits/provider/benefit_providers.dart';
import 'package:flutter_stock/features/benefits/presentation/benefit_edit_page.dart';
import 'package:flutter_stock/features/benefits/widgets/benefit_list_tile.dart';

class BenefitsPage extends ConsumerStatefulWidget {
  const BenefitsPage({super.key});

  @override
  ConsumerState<BenefitsPage> createState() => _BenefitsPageState();
}

class _BenefitsPageState extends ConsumerState<BenefitsPage> {
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider);

    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search benefits...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text('優待リスト'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
          if (isGuest)
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                  (route) => false,
                );
              },
              child: const Text('ログイン/登録'),
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(userBenefitRepositoryProvider);
    final isGuest = ref.watch(isGuestProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: isGuest
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(
                      'メニュー',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('ログアウト'),
                    onTap: () async {
                      await ref.read(authRepositoryProvider).signOut();
                      // AuthGate will handle navigation
                    },
                  ),
                ],
              ),
            ),
      body: StreamBuilder<List<UserBenefit>>(
        stream: repo.watchActive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var items = snapshot.data ?? const [];
          if (_searchQuery.isNotEmpty) {
            items = items.where((benefit) {
              final query = _searchQuery.toLowerCase();
              final title = benefit.title.toLowerCase();
              final benefitText = benefit.benefitText?.toLowerCase() ?? '';
              return title.contains(query) || benefitText.contains(query);
            }).toList();
          }

          if (items.isEmpty) {
            if (_searchQuery.isNotEmpty) {
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
              return BenefitListTile(
                benefit: b,
                subtitle: (b.benefitText?.isNotEmpty ?? false)
                    ? b.benefitText
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BenefitEditPage()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
