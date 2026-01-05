import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';

final companyListProvider = FutureProvider.family<List<String>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }
  final supabase = ref.watch(supabaseProvider);
  final escapedQuery = query.replaceAll('%', r'\%').replaceAll('_', r'\_');
  final builder = supabase
      .from('companies')
      .select('name')
      .ilike('name', escapedQuery);

  final response = await builder;

  if (response.isEmpty) {
    return [];
  }

  return (response as List).map((item) => item['name'] as String).toList();
});
