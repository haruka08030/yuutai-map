import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreRepository {
  StoreRepository(this._client);

  final SupabaseClient _client;

  Future<List<Store>> getStores({
    String? brandId,
    String? companyId,
  }) async {
    var query = _client.from('stores').select('id, name, lat, lng');

    if (brandId != null) {
      query = query.eq('store_brand', brandId);
    }
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }

    final res = await query;

    return res.map((map) => Store.fromJson(map)).toList();
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final client = Supabase.instance.client;
  return StoreRepository(client);
});
