import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/company.dart';

class CompanyRepository {
  final SupabaseClient _sb;
  CompanyRepository(this._sb);

  Future<List<Company>> listCompanies() async {
    final rows = await _sb
        .from('company')
        .select('id, name, code')
        .order('name');
    return (rows as List)
        .map((r) => Company.fromMap(Map<String, dynamic>.from(r)))
        .toList();
  }
}
