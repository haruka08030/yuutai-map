import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart'
    as domain;
import 'package:flutter_stock/features/benefits/domain/repositories/users_yuutai_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersYuutaiRepositorySupabase implements UsersYuutaiRepository {
  UsersYuutaiRepositorySupabase(this._ref, this._supabase) {
    _user = _supabase.auth.currentUser;
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
    });
  }

  final Ref _ref;
  final SupabaseClient _supabase;
  User? _user;

  String get _tableName => 'users_yuutai';

  @override
  Stream<List<domain.UsersYuutai>> watchAll() {
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
  Stream<List<domain.UsersYuutai>> watchActive() {
    return watchAll().map(
      (list) => list.where((i) => i.status == BenefitStatus.active).toList(),
    );
  }

  @override
  Future<List<domain.UsersYuutai>> getActive() async {
    if (_user == null) {
      return [];
    }
    final rows = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', _user!.id)
        .eq('status', 'active');
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
    // Remove id if null to let DB auto-increment
    if (data['id'] == null) {
      data.remove('id');
    }

    final res = await _supabase.from(_tableName).upsert(data).select().single();
    final inserted = domain.UsersYuutai.fromJson(res);

    if (scheduleReminders) {
      await _ref
          .read(notificationServiceProvider)
          .reschedulePresetReminders(inserted);
    }
  }

  @override
  Future<void> updateStatus(
    int id,
    BenefitStatus status, {
    bool scheduleReminders = true,
  }) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .update({'status': status.name})
        .eq('id', id)
        .eq('user_id', _user!.id);

    if (status == BenefitStatus.used && scheduleReminders) {
      await _ref.read(notificationServiceProvider).cancelAllFor(id.toString());
    }
  }

  @override
  Future<void> delete(int id, {bool scheduleReminders = true}) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .delete()
        .eq('id', id)
        .eq('user_id', _user!.id);
    if (scheduleReminders) {
      await _ref.read(notificationServiceProvider).cancelAllFor(id.toString());
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
        .textSearch('company_name', query);
    return _rowsToEntities(rows);
  }

  List<domain.UsersYuutai> _rowsToEntities(List<Map<String, dynamic>> rows) =>
      rows.map((r) => domain.UsersYuutai.fromJson(r)).toList();
}
