import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._ref) {
    _init();
  }

  final Ref _ref;
  ProviderSubscription<AsyncValue<AuthState>>? _subscription;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void _init() {
    _subscription = _ref.listen(authStateChangesProvider, (previous, next) {
      next.whenData((state) {
        final newIsLoggedIn = state.session != null;
        if (_isLoggedIn != newIsLoggedIn) {
          _isLoggedIn = newIsLoggedIn;
          notifyListeners();
        }
      });
    }, fireImmediately: true); // Added fireImmediately for initial state if needed

    // Set initial state
    final authState = _ref.read(authStateChangesProvider).value;
    _isLoggedIn = authState?.session != null;
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});
