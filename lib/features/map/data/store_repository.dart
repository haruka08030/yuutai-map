import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreRepository {
  StoreRepository(this._client);

  final SupabaseClient _client;

  Future<List<Store>> getStores({
    String? brandId,
    String? companyId,
    List<String>? categories,
  }) async {
    var query = _client.from('stores').select('id, name, lat, lng');

    if (brandId != null) {
      query = query.eq('store_brand', brandId);
    }
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }
    if (categories != null && categories.isNotEmpty) {
      query = query.in_('category_tag', categories);
    }

    final res = await query;

    return res.map((map) => Store.fromJson(map)).toList();
  }

  Future<List<String>> getAvailableCategories() async {
    final res = await _client.from('stores').select('category_tag');
    final categories = res
        .map((row) => row['category_tag'] as String?)
        .where((tag) => tag != null && tag.isNotEmpty)
        .toSet() // Use a Set to get unique values
        .toList();
    return categories;
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final client = Supabase.instance.client;
  return StoreRepository(client);
});
