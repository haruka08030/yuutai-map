
import 'package:flutter_stock/domain/entities/user_benefit.dart';
import 'package:flutter_stock/domain/repositories/user_benefit_repository.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

class UserBenefitRepositoryFacade implements UserBenefitRepository {
  UserBenefitRepositoryFacade({
    required this.authRepository,
    required this.localRepository,
    required this.supabaseRepository,
  });

  final AuthRepository authRepository;
  final UserBenefitRepository localRepository;
  final UserBenefitRepository supabaseRepository;

  UserBenefitRepository get _repository =>
      authRepository.currentUser != null ? supabaseRepository : localRepository;

  @override
  Stream<List<UserBenefit>> watchActive() {
    return _repository.watchActive();
  }

  @override
  Future<List<UserBenefit>> getActive() {
    return _repository.getActive();
  }

  @override
  Future<void> upsert(UserBenefit benefit, {bool scheduleReminders = true}) {
    return _repository.upsert(benefit, scheduleReminders: scheduleReminders);
  }

  @override
  Future<void> toggleUsed(String id, bool isUsed) {
    return _repository.toggleUsed(id, isUsed);
  }

  @override
  Future<void> softDelete(String id) {
    return _repository.softDelete(id);
  }

  @override
  Future<List<UserBenefit>> search(String query) {
    return _repository.search(query);
  }
}
