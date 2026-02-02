import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/features/benefits/domain/entities/company_search_item.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';

/// 優待一覧に含まれる企業ID一覧（証券番号取得用）
final benefitCompanyIdsProvider =
    Provider.family<List<int>, bool>((ref, showHistory) {
  final async = ref.watch(
    showHistory ? historyUsersYuutaiProvider : activeUsersYuutaiProvider,
  );
  return async.when(
    data: (list) =>
        list.map((b) => b.companyId).whereType<int>().toSet().toList()..sort(),
    loading: () => <int>[],
    error: (_, __) => <int>[],
  );
});

/// 企業ID → 証券番号（優待一覧の表示・検索用）
final companyStockCodesProvider =
    FutureProvider.family<Map<int, String>, List<int>>((ref, companyIds) async {
  if (companyIds.isEmpty) return {};
  final supabase = ref.watch(supabaseProvider);
  final res = await supabase
      .from('companies')
      .select('id, stock_code')
      .filter('id', 'in', '(${companyIds.join(',')})');
  return Map.fromEntries(
    (res as List).map(
      (r) => MapEntry(r['id'] as int, (r['stock_code'] as String?) ?? ''),
    ),
  );
});

final companyListProvider =
    FutureProvider.family<List<CompanySearchItem>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }
  final supabase = ref.watch(supabaseProvider);
  final escapedQuery = query.replaceAll('%', r'\%').replaceAll('_', r'\_');
  final pattern = '%$escapedQuery%';
  final response = await supabase
      .from('companies')
      .select('id, name, stock_code')
      .or('name.ilike.$pattern,stock_code.ilike.$pattern');

  if (response.isEmpty) {
    return [];
  }

  return (response as List)
      .map((item) => CompanySearchItem(
            id: item['id'] as int,
            name: item['name'] as String,
            stockCode: item['stock_code'] as String?,
          ))
      .toList();
});
