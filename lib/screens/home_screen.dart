import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stock/screens/map_screen.dart';
import '../models/shareholder_benefit.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shareholder_benefits')
            // .orderBy('expiration_date') // 並び替えしたい場合は有効化
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final benefits = snapshot.data!.docs
              .map((doc) => ShareholderBenefit.fromFirestore(doc))
              .toList();

          if (benefits.isEmpty) {
            return const Center(child: Text('まだ追加されていません'));
          }

          return ListView.separated(
            itemCount: benefits.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final b = benefits[index];

              // company_id から companies/{id} を引いて name を取得
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('companies')
                    .doc(b.companyId.toString())
                    .get(),
                builder: (context, companySnap) {
                  final companyName =
                      companySnap.data?.data()?['name']?.toString() ??
                      b.companyId.toString(); // フォールバック

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
