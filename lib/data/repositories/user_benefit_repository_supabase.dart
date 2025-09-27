
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart' as domain;
import 'package:flutter_stock/domain/repositories/user_benefit_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserBenefitRepositorySupabase implements UserBenefitRepository {
  UserBenefitRepositorySupabase(this._supabase) {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _user = session.user;
      }
    });
  }

  final SupabaseClient _supabase;
  User? _user;

  String get _tableName => 'user_benefits';

  @override
  Stream<List<domain.UserBenefit>> watchActive() {
    if (_user == null) {
      return Stream.value([]);
    }
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', _user!.id)
        .map((rows) => rows.where((row) => row['deleted_at'] == null).toList())
        .map(_rowsToEntities);
  }

  @override
  Future<List<domain.UserBenefit>> getActive() async {
    if (_user == null) {
      return [];
    }
    final rows = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', _user!.id)
        .isFilter('deleted_at', null);
    return _rowsToEntities(rows);
  }

  @override
  Future<void> upsert(domain.UserBenefit b, {bool scheduleReminders = true}) async {
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
  Future<void> toggleUsed(String id, bool isUsed) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .update({'is_used': isUsed, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _user!.id);

    if (isUsed) {
      await NotificationService.instance.cancelAllFor(id);
    }
  }

  @override
  Future<void> softDelete(String id) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }
    await _supabase
        .from(_tableName)
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _user!.id);
    await NotificationService.instance.cancelAllFor(id);
  }

  @override
  Future<List<domain.UserBenefit>> search(String query) async {
    if (_user == null) {
      return [];
    }
    final rows = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', _user!.id)
        .isFilter('deleted_at', null)
        .textSearch('title', query);
    return _rowsToEntities(rows);
  }

  List<domain.UserBenefit> _rowsToEntities(List<Map<String, dynamic>> rows) =>
      rows.map((r) => domain.UserBenefit.fromJson(r)).toList();
}
