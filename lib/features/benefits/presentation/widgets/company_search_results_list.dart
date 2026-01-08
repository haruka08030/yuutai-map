import 'package:flutter/material.dart';

class CompanySearchResultsList extends StatelessWidget {
  const CompanySearchResultsList({super.key, required this.companies});

  final List<String> companies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return ListTile(
          title: Text(company),
          onTap: () => Navigator.of(context).pop(company),
        );
      },
    );
  }
}
