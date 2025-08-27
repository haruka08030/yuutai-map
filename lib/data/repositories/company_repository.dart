import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/features/companies/domain/company.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyRepository {
  CompanyRepository(this._client);

  final SupabaseClient _client;

  Future<List<Company>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // TODO: Replace with real implementation
    return const [Company(id: '1', name: 'Demo Company')];
  }
}

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return CompanyRepository(client);
});
