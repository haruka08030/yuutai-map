import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart' as domain;
import 'package:flutter_stock/domain/repositories/users_yuutai_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersYuutaiRepositorySupabase implements UsersYuutaiRepository {
  UsersYuutaiRepositorySupabase(this._supabase) {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _user = session.user;
      }
    });
  }

  final SupabaseClient _supabase;
  User? _user;

  String get _tableName => 'users_yuutai';

  @override
  Stream<List<domain.UsersYuutai>> watchActive() {
    if (_user == null) {
      return Stream.value([]);
    }
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', _user!.id)
        .map(_rowsToEntities);
  }

  @override
  Future<List<domain.UsersYuutai>> getActive() async {
    if (_user == null) {
      return [];
    }
    final rows = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', _user!.id);
    return _rowsToEntities(rows);
  }

  @override
  Future<void> upsert(
    domain.UsersYuutai b, {
    bool scheduleReminders = true,
  }) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }

    final data = b.toJson();
    data['user_id'] = _user!.id;
    await _supabase.from(_tableName).upsert(data);

    if (scheduleReminders) {
      await NotificationService.instance.reschedulePresetReminders(b);
    }
  }

  @override
  Future<void> toggleUsed(String id, bool isUsed, {bool scheduleReminders = true}) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .update({
          'is_used': isUsed,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .eq('user_id', _user!.id);

    if (isUsed && scheduleReminders) {
      await NotificationService.instance.cancelAllFor(id);
    }
  }

  @override
  Future<void> softDelete(String id, {bool scheduleReminders = true}) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .delete()
        .eq('id', id)
        .eq('user_id', _user!.id);
    if (scheduleReminders) {
      await NotificationService.instance.cancelAllFor(id);
    }
  }

  @override
  Future<List<domain.UsersYuutai>> search(String query) async {
    if (_user == null) {
      return [];
    }
    final rows = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', _user!.id)
        .textSearch('title', query);
    return _rowsToEntities(rows);
  }

  List<domain.UsersYuutai> _rowsToEntities(List<Map<String, dynamic>> rows) =>
      rows.map((r) => domain.UsersYuutai.fromJson(r)).toList();
}
