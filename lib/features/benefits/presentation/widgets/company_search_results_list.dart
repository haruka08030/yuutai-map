import 'package:flutter/material.dart';
import 'package:flutter_stock/features/benefits/domain/entities/company_search_item.dart';

class CompanySearchResultsList extends StatelessWidget {
  const CompanySearchResultsList({super.key, required this.companies});

  final List<CompanySearchItem> companies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return ListTile(
          title: Text(company.name),
          subtitle: company.stockCode != null && company.stockCode!.isNotEmpty
              ? Text('証券コード: ${company.stockCode}')
              : null,
          onTap: () => Navigator.of(context).pop(company),
        );
      },
    );
  }
}
