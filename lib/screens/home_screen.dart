import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stock/screens/map_screen.dart';
import '../../models/shareholder_benefit.dart';
import 'add_benefit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              return ListTile(
                title: Text(benefit.benefitDetails),
                subtitle: Text('ID: ${benefit.companyId}'), // 仮表示
                trailing: Text(
                  'Expires: ${benefit.expirationDate.toIso8601String().substring(0, 10)}',
                ),
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
