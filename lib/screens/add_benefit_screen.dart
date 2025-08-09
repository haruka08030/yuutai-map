import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company.dart';

class AddBenefitScreen extends StatefulWidget {
  const AddBenefitScreen({super.key});

  @override
  _AddBenefitScreenState createState() => _AddBenefitScreenState();
}

class _AddBenefitScreenState extends State<AddBenefitScreen> {
  String? _selectedCompanyId;
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _saveBenefit() async {
    if (_selectedCompanyId == null ||
        _detailsController.text.isEmpty ||
        _dateController.text.isEmpty) {
      // バリデーションエラー処理
      return;
    }

    final expirationDate = DateTime.tryParse(_dateController.text);
    if (expirationDate == null) {
      // 日付フォーマットエラー処理
      return;
    }

    await FirebaseFirestore.instance.collection('shareholder_benefits').add({
      'company_id': _selectedCompanyId,
      'benefit_details': _detailsController.text,
      'expiration_date': Timestamp.fromDate(expirationDate),
      'is_used': false,
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Benefit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 会社選択ドロップダウン
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('companies')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final companies = snapshot.data!.docs
                    .map((doc) => Company.fromFirestore(doc))
                    .toList();

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Company'),
                  value: _selectedCompanyId,
                  items: companies.map((company) {
                    return DropdownMenuItem(
                      value: company.id,
                      child: Text(company.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCompanyId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Benefit Details'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Expiration Date (YYYY-MM-DD)',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveBenefit,
              child: const Text('Save Benefit'),
            ),
          ],
        ),
      ),
    );
  }
}
