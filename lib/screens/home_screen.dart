import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/benefit_repository.dart';
import '../models/shareholder_benefit.dart';
import 'add_benefit_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BenefitRepository repo;
  late Future<List<ShareholderBenefit>> _future;

  @override
  void initState() {
    super.initState();
    repo = BenefitRepository(Supabase.instance.client);
    _future = repo.listMyBenefits();
  }

  void _refresh() {
    setState(() => _future = repo.listMyBenefits());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('株主優待一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MapScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ShareholderBenefit>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final benefits = snapshot.data!;
          if (benefits.isEmpty) return const Center(child: Text('まだ追加されていません'));
          return ListView.separated(
            itemCount: benefits.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final b = benefits[index];
              return ListTile(
                leading: Checkbox(
                  value: b.isUsed,
                  onChanged: (val) async {
                    await repo.updateBenefit(b.copyWith(isUsed: val ?? false));
                    _refresh();
                  },
                ),
                title: Text(b.companyId ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (b.benefitDetails.isNotEmpty) Text(b.benefitDetails),
                    Text(b.expirationDate.toIso8601String().substring(0, 10)),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddBenefitScreen(benefit: b),
                    ),
                  );
                  _refresh();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBenefitScreen()),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
