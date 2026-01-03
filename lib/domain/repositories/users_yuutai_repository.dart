import 'package:flutter_stock/domain/entities/benefit_status.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';

abstract class UsersYuutaiRepository {
  Stream<List<UsersYuutai>> watchAll();
  Stream<List<UsersYuutai>> watchActive();
  Future<List<UsersYuutai>> getActive();
  Future<void> upsert(UsersYuutai benefit, {bool scheduleReminders = true});
  Future<void> updateStatus(int id, BenefitStatus status,
      {bool scheduleReminders = true});
  Future<void> softDelete(int id, {bool scheduleReminders = true});
  Future<List<UsersYuutai>> search(String query);
}
