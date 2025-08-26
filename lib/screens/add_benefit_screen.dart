import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shareholder_benefit.dart';
import '../models/company.dart';
import '../data/benefit_repository.dart';
import '../data/company_repository.dart';

class AddBenefitScreen extends StatefulWidget {
  final ShareholderBenefit? benefit;
  const AddBenefitScreen({super.key, this.benefit});

  @override
  State<AddBenefitScreen> createState() => _AddBenefitScreenState();
}

class _AddBenefitScreenState extends State<AddBenefitScreen> {
  late final BenefitRepository benefitRepo;
  late final CompanyRepository companyRepo;
  final _detailsController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isUsed = false;
  String? _selectedCompanyId;
  List<Company> companies = [];

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    benefitRepo = BenefitRepository(client);
    companyRepo = CompanyRepository(client);
    if (widget.benefit != null) {
      _selectedCompanyId = widget.benefit!.companyId;
      _detailsController.text = widget.benefit!.benefitDetails;
      _dateController.text = widget.benefit!.expirationDate
          .toIso8601String()
          .substring(0, 10);
      _isUsed = widget.benefit!.isUsed;
    }
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    companies = await companyRepo.listCompanies();
    setState(() {});
  }

  Future<void> _save() async {
    final benefit = ShareholderBenefit(
      id: widget.benefit?.id ?? '',
      companyId: _selectedCompanyId,
      benefitDetails: _detailsController.text.trim(),
      expirationDate: DateTime.parse(_dateController.text),
      isUsed: _isUsed,
      memo: null,
    );
    if (widget.benefit == null) {
      await benefitRepo.addBenefit(benefit);
    } else {
      await benefitRepo.updateBenefit(benefit.copyWith(id: widget.benefit!.id));
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.benefit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Benefit' : 'Add New Benefit'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: '企業'),
            value: companies.any((c) => c.id == _selectedCompanyId)
                ? _selectedCompanyId
                : null,
            items: companies
                .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                .toList(),
            onChanged: (value) => setState(() => _selectedCompanyId = value),
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
              onPressed: _save,
              child: const Text('優待を保存する'),
            ),
          ),
        ],
      ),
    );
  }
}
