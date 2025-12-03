
import 'dart:async';

import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/domain/repositories/users_yuutai_repository.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersYuutaiRepositoryFacade implements UsersYuutaiRepository {
  UsersYuutaiRepositoryFacade({
    required this.authRepository,
    required this.localRepository,
    required this.supabaseRepository,
  }) {
    _init();
  }

  final AuthRepository authRepository;
  final UsersYuutaiRepository localRepository;
  final UsersYuutaiRepository supabaseRepository;

  // The getter is now only used for non-stream methods
  UsersYuutaiRepository get _repository =>
      authRepository.currentUser != null ? supabaseRepository : localRepository;

  late final StreamController<List<UsersYuutai>> _streamController;
  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<List<UsersYuutai>>? _repositorySubscription;

  void _init() {
    _streamController = StreamController<List<UsersYuutai>>.broadcast();
    _authSubscription = authRepository.authStateChanges.listen((_) {
      _switchRepositoryStream();
    });
    _switchRepositoryStream(); // Initial setup
  }

  void _switchRepositoryStream() {
    _repositorySubscription?.cancel();
    final repo =
        authRepository.currentUser != null ? supabaseRepository : localRepository;
    _repositorySubscription = repo.watchActive().listen((data) {
      if (!_streamController.isClosed) {
        _streamController.add(data);
      }
    });
  }

  @override
  Stream<List<UsersYuutai>> watchActive() {
    return _streamController.stream;
  }

  void dispose() {
    _authSubscription?.cancel();
    _repositorySubscription?.cancel();
    _streamController.close();
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
  Future<void> toggleUsed(String id, bool isUsed, {bool scheduleReminders = true}) {
    return _repository.toggleUsed(id, isUsed, scheduleReminders: scheduleReminders);
  }

  @override
  Future<void> softDelete(String id, {bool scheduleReminders = true}) {
    return _repository.softDelete(id, scheduleReminders: scheduleReminders);
  }

  @override
  Future<List<UsersYuutai>> search(String query) {
    return _repository.search(query);
  }
}
