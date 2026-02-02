import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/bordered_search_bar.dart';
import 'package:flutter_stock/features/benefits/provider/company_provider.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/company_search_empty_request.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/company_search_results_list.dart';

class CompanySearchPage extends ConsumerStatefulWidget {
  const CompanySearchPage({super.key});

  @override
  ConsumerState<CompanySearchPage> createState() => _CompanySearchPageState();
}

class _CompanySearchPageState extends ConsumerState<CompanySearchPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyList = ref.watch(companyListProvider(_query));
    return Scaffold(
      appBar: AppBar(
        title: BorderedSearchBar(
          controller: _searchController,
          autofocus: true,
          hintText: '企業名・証券コードで検索',
        ),
      ),
      body: companyList.when(
        data: (companies) {
          if (companies.isEmpty && _query.isNotEmpty) {
            return CompanySearchEmptyRequest(query: _query);
          }
          if (companies.isEmpty && _query.isEmpty) {
            return const EmptyStateView(
              icon: Icons.search,
              title: '企業を検索',
              subtitle: '企業名または証券コードを入力してください',
            );
          }
          return CompanySearchResultsList(companies: companies);
        },
        loading: () => const AppLoadingIndicator(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
