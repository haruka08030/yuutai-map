import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/map/domain/entities/store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreRepository {
  StoreRepository(this._client);

  final SupabaseClient _client;

  Future<List<Store>> getStores({
    String? brandId,
    String? companyId,
    List<String>? companyIds,
    List<String>? categories,
    List<String>? prefectures,
  }) async {
    var query = _client.from('stores').select(
          'id, name, lat, lng, category_tag, address, prefecture, company_id',
        );

    if (brandId != null) {
      query = query.eq('store_brand', brandId);
    }

    // Merge companyId and companyIds into a single filter
    final allCompanyIds = <String>[
      if (companyId != null) companyId,
      if (companyIds != null) ...companyIds,
    ];

    if (allCompanyIds.isNotEmpty) {
      if (allCompanyIds.length == 1) {
        query = query.eq('company_id', allCompanyIds.first);
      } else {
        query = query.filter('company_id', 'in', allCompanyIds);
      }
    }

    if (categories != null && categories.isNotEmpty) {
      query = query.filter('category_tag', 'in', categories);
    }

    if (prefectures != null && prefectures.isNotEmpty) {
      query = query.filter('prefecture', 'in', prefectures);
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
    return categories.whereType<String>().toList();
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final client = Supabase.instance.client;
  return StoreRepository(client);
});
