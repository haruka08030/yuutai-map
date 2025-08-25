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

  Future<void> _pickExpirationDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final formatted =
          '${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      setState(() {
        _dateController.text = formatted;
      });
    }
  }

  Future<void> _saveBenefit() async {
    if (_selectedCompanyId == null ||
        _detailsController.text.isEmpty ||
        _dateController.text.isEmpty) {
      // TODO: 簡易バリデーション表示
      return;
    }

    final expirationDate = DateTime.tryParse(_dateController.text);
    if (expirationDate == null) {
      // TODO: 日付フォーマットエラー表示
      return;
    }

    await FirebaseFirestore.instance.collection('shareholder_benefits').add({
      'company_id': _selectedCompanyId, // Stringで保存（応急）
      'benefit_details': _detailsController.text,
      'expiration_date': Timestamp.fromDate(expirationDate),
      'is_used': false,
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Benefit')),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 会社選択ドロップダウン
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('companies')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 56,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Failed to load companies: ${snapshot.error}');
                }
                final companies =
                    snapshot.data?.docs
                        .map((doc) => Company.fromFirestore(doc))
                        .toList() ??
                    [];

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Company'),
                  value: _selectedCompanyId,
                  items: companies.map((company) {
                    return DropdownMenuItem<String>(
                      value: company.id, // ← String
                      child: Text(company.name),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCompanyId = value),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: '概要'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Expiration Date (YYYY-MM-DD)',
              ),
              readOnly: true,
              onTap: _pickExpirationDate,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveBenefit,
                child: const Text('優待を保存する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
