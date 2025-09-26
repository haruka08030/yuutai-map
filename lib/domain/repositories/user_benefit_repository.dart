import 'package:flutter_stock/domain/entities/user_benefit.dart';

abstract class UserBenefitRepository {
  Stream<List<UserBenefit>> watchActive();
  Future<List<UserBenefit>> getActive();
  Future<void> upsert(UserBenefit benefit, {bool scheduleReminders = true});
  Future<void> toggleUsed(String id, bool isUsed);
  Future<void> softDelete(String id);
  Future<List<UserBenefit>> search(String query);
}
