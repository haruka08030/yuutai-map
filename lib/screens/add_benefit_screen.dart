import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/company.dart';
import '../models/shareholder_benefit.dart';

class AddBenefitScreen extends StatefulWidget {
  final ShareholderBenefit? benefit;
  const AddBenefitScreen({super.key, this.benefit});

  @override
  _AddBenefitScreenState createState() => _AddBenefitScreenState();
}

class _AddBenefitScreenState extends State<AddBenefitScreen> {
  String? _selectedCompanyId;
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isUsed = false;

  @override
  void initState() {
    super.initState();
    final b = widget.benefit;
    if (b != null) {
      _selectedCompanyId = b.companyId;
      _detailsController.text = b.benefitDetails;
      _dateController.text =
          '${b.expirationDate.year.toString().padLeft(4, '0')}-${b.expirationDate.month.toString().padLeft(2, '0')}-${b.expirationDate.day.toString().padLeft(2, '0')}';
      _isUsed = b.isUsed;
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

    final data = {
      'company_id': _selectedCompanyId,
      'benefit_details': _detailsController.text,
      'expiration_date': Timestamp.fromDate(expirationDate),
      'is_used': _isUsed,
    };

    final col = FirebaseFirestore.instance.collection('shareholder_benefits');
    if (widget.benefit == null) {
      await col.add(data);
    } else {
      await col.doc(widget.benefit!.id).update(data);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.benefit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Benefit' : 'Add New Benefit'),
      ),
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
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('使用済み'),
              contentPadding: EdgeInsets.zero,
              value: _isUsed,
              onChanged: (val) => setState(() => _isUsed = val ?? false),
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
