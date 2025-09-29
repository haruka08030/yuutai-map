
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/domain/repositories/users_yuutai_repository.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

class UsersYuutaiRepositoryFacade implements UsersYuutaiRepository {
  UsersYuutaiRepositoryFacade({
    required this.authRepository,
    required this.localRepository,
    required this.supabaseRepository,
  });

  final AuthRepository authRepository;
  final UsersYuutaiRepository localRepository;
  final UsersYuutaiRepository supabaseRepository;

  UsersYuutaiRepository get _repository =>
      authRepository.currentUser != null ? supabaseRepository : localRepository;

  @override
  Stream<List<UsersYuutai>> watchActive() {
    return _repository.watchActive();
  }

  @override
  Future<List<UsersYuutai>> getActive() {
    return _repository.getActive();
  }

  @override
  Future<void> upsert(UsersYuutai benefit, {bool scheduleReminders = true}) {
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
  Future<List<UsersYuutai>> search(String query) {
    return _repository.search(query);
  }
}
