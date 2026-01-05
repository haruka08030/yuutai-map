import 'package:flutter_stock/domain/entities/folder.dart';
import 'package:flutter_stock/domain/repositories/folder_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FolderRepositorySupabase implements FolderRepository {
  FolderRepositorySupabase(this._supabase) {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      _user = session?.user;
    });
  }

  final SupabaseClient _supabase;
  User? _user;

  String get _tableName => 'folders';

  @override
  Stream<List<Folder>> watchFolders() {
    final user = _user;
    if (user == null) {
      return Stream.value([]);
    }
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('sort_order')
        .map(_rowsToEntities);
  }

  @override
  Future<List<Folder>> getFolders() async {
    final user = _user;
    if (user == null) {
      return [];
    }
    final rows = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', user.id)
        .order('sort_order');
    return _rowsToEntities(rows);
  }

  @override
  Future<void> createFolder(String name) async {
    final user = _user;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Get the max sort_order
    final result = await _supabase
        .from(_tableName)
        .select('sort_order')
        .eq('user_id', user.id)
        .order('sort_order', ascending: false)
        .limit(1);
    final maxOrder = result.isEmpty ? 0 : result.first['sort_order'] as int;

    await _supabase.from(_tableName).insert({
      'user_id': user.id,
      'name': name,
      'sort_order': maxOrder + 1,
    });
  }

  @override
  Future<void> updateFolder(String id, String name, int sortOrder) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .update({'name': name, 'sort_order': sortOrder})
        .eq('id', id)
        .eq('user_id', _user!.id);
  }

  @override
  Future<void> deleteFolder(String id) async {
    final user = _user;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Use RPC or rely on database cascading rules
    // If database has ON DELETE SET NULL constraint, you can remove the first query
    // Otherwise, consider using an RPC function for atomicity
    try {
      await _supabase
          .from('users_yuutai')
          .update({'folder_id': null})
          .eq('folder_id', id)
          .eq('user_id', user.id);

      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', user.id);
    } catch (e) {
      // Consider logging or rethrowing with context
      rethrow;
    }
  }

  List<Folder> _rowsToEntities(List<Map<String, dynamic>> rows) =>
      rows.map((r) => Folder.fromJson(r)).toList();
}
