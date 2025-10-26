import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/home_search_bar.dart';
import 'package:flutter_stock/features/benefits/provider/company_provider.dart';

class CompanySearchPage extends ConsumerStatefulWidget {
  const CompanySearchPage({super.key});

  @override
  ConsumerState<CompanySearchPage> createState() => _CompanySearchPageState();
}

class _CompanySearchPageState extends ConsumerState<CompanySearchPage> {
  final _searchCtl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtl.addListener(() {
      setState(() {
        _query = _searchCtl.text;
      });
    });
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyList = ref.watch(companyListProvider(_query));
    return Scaffold(
      appBar: AppBar(
        title: CompanySearchBar(
          controller: _searchCtl,
          autofocus: true,
          hintText: '企業名で検索',
        ),
      ),
      body: companyList.when(
        data: (companies) {
          if (companies.isEmpty && _query.isNotEmpty) {
            return Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text('"$_query" を企業名として追加'),
                onPressed: () {
                  Navigator.of(context).pop(_query);
                },
              ),
            );
          }
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
