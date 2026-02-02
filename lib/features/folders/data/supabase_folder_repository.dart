import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/domain/repositories/folder_repository.dart';

class FolderRepositorySupabase implements FolderRepository {
  FolderRepositorySupabase(this._supabase) {
    _user = _supabase.auth.currentUser;
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
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
  Future<Folder> createFolder(String name) async {
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
    final raw = result.isEmpty ? null : result.first['sort_order'];
    final maxOrder = raw == null ? 0 : (raw as num).toInt();

    final rows = await _supabase.from(_tableName).insert({
      'user_id': user.id,
      'name': name,
      'sort_order': maxOrder + 1,
    }).select();
    if (rows.isEmpty) throw Exception('Failed to create folder');
    return Folder.fromJson(rows.first);
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

    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', user.id);
    } catch (e) {
      debugPrint('Error deleting folder: $e');
      rethrow;
    }
  }

  List<Folder> _rowsToEntities(List<Map<String, dynamic>> rows) =>
      rows.map((r) => Folder.fromJson(r)).toList();
}
