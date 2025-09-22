import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stock/screens/map_screen.dart';
import '../models/shareholder_benefit.dart';
import '../models/company.dart';
import 'add_benefit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String fmtDate(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('株主優待一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('shareholder_benefits')
            .stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final benefits = snapshot.data
              ?.map((data) => ShareholderBenefit.fromSupabase(data))
              .toList() ?? [];

          if (benefits.isEmpty) {
            return const Center(child: Text('まだ追加されていません'));
          }

          return ListView.separated(
            itemCount: benefits.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final b = benefits[index];

              // company_id から会社名を取得
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: Supabase.instance.client
                    .from('companies')
                    .select()
                    .eq('id', b.companyId),
                builder: (context, companySnap) {
                  String companyName = b.companyId; // フォールバック
                  
                  if (companySnap.hasData && companySnap.data!.isNotEmpty) {
                    final company = Company.fromSupabase(companySnap.data!.first);
                    companyName = company.name;
                  }

                  return ListTile(
                    // ← タイトルを企業名に
                    title: Text(companyName),
                    // ← サブタイトルに優待内容（例：5000円分）
                    subtitle: Text(
                      (b.benefitDetails.isEmpty) ? '—' : b.benefitDetails,
                    ),
                    trailing: Text('Expires: ${fmtDate(b.expirationDate)}'),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBenefitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
