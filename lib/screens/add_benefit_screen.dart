import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../models/shareholder_benefit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/benefit_repository.dart';

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
    repo = BenefitRepository(Supabase.instance.client);
    if (widget.benefit != null) {
      _selectedCompanyId = widget.benefit!.companyId;
      _detailsController.text = widget.benefit!.benefitDetails;
      _dateController.text =
          '${widget.benefit!.expirationDate.year.toString().padLeft(4, '0')}-${widget.benefit!.expirationDate.month.toString().padLeft(2, '0')}-${widget.benefit!.expirationDate.day.toString().padLeft(2, '0')}';
      _isUsed = widget.benefit!.isUsed;
    }
  }

  Future<void> _save() async {
    final b = ShareholderBenefit(
      id: widget.benefit?.id ?? '', // insert時は未使用
      companyId: _selectedCompanyId,
      benefitDetails: _detailsController.text.trim(),
      expirationDate: DateTime.parse(_dateController.text),
      memo: null,
      isUsed: _isUsed,
    );
    if (widget.benefit == null) {
      await repo.addBenefit(b);
    } else {
      await repo.updateBenefit(b.copyWith(id: widget.benefit!.id));
    }
    if (mounted) Navigator.pop(context, true);
  }
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

                final uniqueCompanies = {
                  for (final c in companies) c.id: c,
                }.values.toList();

                final items = uniqueCompanies
                    .map(
                      (company) => DropdownMenuItem<String>(
                        value: company.id,
                        child: Text(company.name),
                      ),
                    )
                    .toList();

                // Only keep the selected value if it exists in the items list
                final selected =
                    uniqueCompanies.any((c) => c.id == _selectedCompanyId)
                    ? _selectedCompanyId
                    : null;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: '企業'),
                  value: selected,
                  items: items,
                  onChanged: (value) =>
                      setState(() => _selectedCompanyId = value),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: '優待内容'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: '有効期限 (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
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
