
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Store {
  Store({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'] as int,
      name: map['name'] as String,
      latitude: (map['lat'] as num).toDouble(),
      longitude: (map['lng'] as num).toDouble(),
    );
  }
}

class StoreRepository {
  StoreRepository(this._client);

  final SupabaseClient _client;

  Future<List<Store>> getStores({
    String? brandId,
    String? companyId,
  }) async {
    if (brandId == null && companyId == null) {
      return [];
    }

    var query = _client.from('stores').select('id, name, lat, lng');

    if (brandId != null) {
      query = query.eq('store_brand', brandId);
    }
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }

    final res = await query;

    return res.map((map) => Store.fromMap(map)).toList();
  }
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final client = Supabase.instance.client;
  return StoreRepository(client);
});
