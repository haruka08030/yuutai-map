import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shareholder_benefit.dart';
import '../models/company.dart';
import 'add_benefit_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 企業情報をキャッシュするためのマップ
  final Map<String, String> _companyNames = {};

  Future<String> _fetchCompanyName(String companyId) async {
    // キャッシュにあればそれを返す
    if (_companyNames.containsKey(companyId)) {
      return _companyNames[companyId]!;
    }

    try {
      // Firestoreから企業名を取得
      final doc = await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .get();

      if (!doc.exists) {
        return 'Unknown company';
      }

      final company = Company.fromFirestore(doc);

      // キャッシュに保存
      _companyNames[companyId] = company.name;
      return company.name;
    } catch (_) {
      // 取得に失敗した場合はプレースホルダーを返す
      return 'Unknown company';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shareholder Benefits'),
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
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final benefits = snapshot.data!.docs
              .map((doc) => ShareholderBenefit.fromFirestore(doc))
              .toList();

          if (benefits.isEmpty) {
            return const Center(child: Text('No benefits added yet.'));
          }

          return ListView.builder(
            itemCount: benefits.length,
            itemBuilder: (context, index) {
              final benefit = benefits[index];
              return FutureBuilder<String>(
                future: _fetchCompanyName(benefit.companyId),
                builder: (context, companyNameSnapshot) {
                  final subtitle = Text(benefit.benefitDetails);
                  final trailing = Text(
                    'Expires: ${benefit.expirationDate.toIso8601String().substring(0, 10)}',
                  );

                  if (companyNameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: const Text('Loading...'),
                      subtitle: subtitle,
                      trailing: trailing,
                    );
                  }

                  if (companyNameSnapshot.hasError ||
                      !companyNameSnapshot.hasData) {
                    return ListTile(
                      title: const Text('Unknown company'),
                      subtitle: subtitle,
                      trailing: trailing,
                    );
                  }

                  return ListTile(
                    title: Text(companyNameSnapshot.data!),
                    subtitle: subtitle,
                    trailing: trailing,
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
