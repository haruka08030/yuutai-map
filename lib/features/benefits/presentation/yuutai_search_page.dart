import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/home_search_bar.dart';

class YuutaiSearchPage extends ConsumerStatefulWidget {
  const YuutaiSearchPage({
    super.key,
    this.initialQuery,
  });

  final String? initialQuery;

  @override
  ConsumerState<YuutaiSearchPage> createState() => _YuutaiSearchPageState();
}

class _YuutaiSearchPageState extends ConsumerState<YuutaiSearchPage> {
  late final TextEditingController _searchCtl;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchCtl = TextEditingController(text: widget.initialQuery);
    _currentQuery = widget.initialQuery ?? '';
    _searchCtl.addListener(() {
      setState(() {
        _currentQuery = _searchCtl.text;
      });
    });
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    Navigator.of(context).pop(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CompanySearchBar(
          controller: _searchCtl,
          autofocus: true,
          hintText: '検索',
          onSubmitted: _onSearchSubmitted,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Pop with the current query, in case user started typing and then decided to go back
            Navigator.of(context).pop(_currentQuery); 
          },
        ),
      ),
      body: Center(
        child: Text(
          _currentQuery.isEmpty ? 'キーワードを入力してください' : '「$_currentQuery」で検索',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
