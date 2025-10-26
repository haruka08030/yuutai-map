import 'package:flutter_stock/domain/entities/users_yuutai.dart';

abstract class UsersYuutaiRepository {
  Stream<List<UsersYuutai>> watchActive();
  Future<List<UsersYuutai>> getActive();
  Future<void> upsert(UsersYuutai benefit, {bool scheduleReminders = true});
  Future<void> toggleUsed(String id, bool isUsed, {bool scheduleReminders = true});
  Future<void> softDelete(String id, {bool scheduleReminders = true});
  Future<List<UsersYuutai>> search(String query);
}
