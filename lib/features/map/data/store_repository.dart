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
      final inValue =
          '(${categories.map((c) => '"${c.replaceAll('"', r'\"')}"').join(',')})';
      query = query.filter('category_tag', 'in', inValue);
    }

    if (prefectures != null && prefectures.isNotEmpty) {
      // PostgREST 'in' for text: use ("val1","val2") format
      final inValue =
          '(${prefectures.map((p) => '"${p.replaceAll('"', r'\"')}"').join(',')})';
      query = query.filter('prefecture', 'in', inValue);
    }

    final res = await query;
    final list = res as List<dynamic>? ?? [];

    // Skip rows missing required fields (lat/lng can be null in DB)
    return list
        .where(_hasRequiredStoreFields)
        .map((row) => Store.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }

  static bool _hasRequiredStoreFields(dynamic row) {
    if (row is! Map) return false;
    return row['id'] != null &&
        row['name'] != null &&
        row['lat'] != null &&
        row['lng'] != null;
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
