import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._ref) {
    _init();
    // Listen to AuthRepository for changes in guest status
    _ref.read(authRepositoryProvider).addListener(_onAuthRepositoryChange);
  }

  final Ref _ref;
  ProviderSubscription<AsyncValue<AuthState>>? _subscription;
  bool _isLoggedIn = false;
  bool _isGuest = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;

  void _init() {
    _subscription = _ref.listen(authStateChangesProvider, (previous, next) {
      next.whenData((state) {
        final newIsLoggedIn = state.session != null;
        if (_isLoggedIn != newIsLoggedIn) {
          _isLoggedIn = newIsLoggedIn;
          // When login state changes, guest state must be false
          _isGuest = false;
          notifyListeners();
        }
      });
    }, fireImmediately: true);

    // Set initial state
    final authState = _ref.read(authStateChangesProvider).value;
    _isLoggedIn = authState?.session != null;
    _isGuest = _ref.read(authRepositoryProvider).isGuest;
  }

  void _onAuthRepositoryChange() {
    final newIsGuest = _ref.read(authRepositoryProvider).isGuest;
    if (_isGuest != newIsGuest) {
      _isGuest = newIsGuest;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ref.read(authRepositoryProvider).removeListener(_onAuthRepositoryChange);
    _subscription?.close();
    super.dispose();
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});
