import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository(this._client) {
    _client.auth.onAuthStateChange.listen((data) {
      // Reset guest status if a real user logs in/out
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.signedOut ||
          data.event == AuthChangeEvent.userUpdated) {
        _isGuest = false;
        notifyListeners();
      }
    });
  }

  final SupabaseClient _client;
  bool _isGuest = false;

  bool get isGuest => _isGuest;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  void signInAsGuest() {
    _isGuest = true;
    notifyListeners();
  }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
      emailRedirectTo: 'io.supabase.flutter_stock://login-callback/',
    );
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> resendConfirmationEmail({required String email}) async {
    await _client.auth.resend(email: email, type: OtpType.signup);
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
    );
  }

  /// 現在のユーザーに紐づくログイン方法（メール・Google・Apple 等）を取得
  Future<List<UserIdentity>> getUserIdentities() async {
    final res = await _client.auth.getUserIdentities();
    return res;
  }

  /// ログイン中のアカウントに Google を連携する（同じメールで登録済みなら統合される）
  Future<void> linkGoogleIdentity() async {
    await _client.auth.linkIdentity(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter_stock://login-callback/',
    );
  }

  Future<void> signInWithApple() async {
    final rawNonce = _client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: credential.identityToken!,
      nonce: rawNonce,
    );
  }

  Future<void> resetPasswordForEmail({required String email}) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.flutter_stock://login-callback/',
    );
  }

  Future<void> signOut() async {
    _isGuest = false;
    await _client.auth.signOut();
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    final response = await _client.functions.invoke('delete-user');
    if (response.status != 200) {
      throw Exception(response.data['error'] ?? 'Failed to delete account');
    }
  }

  Future<void> updateUserProfile({String? username}) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final Map<String, dynamic> newUserMetadata = Map.from(
      user.userMetadata ?? {},
    );
    if (username != null) {
      newUserMetadata['username'] = username;
    }

    await _client.auth.updateUser(UserAttributes(data: newUserMetadata));
    notifyListeners(); // Notify listeners after profile update
  }

  Future<void> updateUserEmail({required String newEmail}) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    await _client.auth.updateUser(UserAttributes(email: newEmail));
    notifyListeners(); // Notify listeners after email update
  }

  User? get currentUser => _client.auth.currentUser;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = Supabase.instance.client;
  return AuthRepository(client);
});

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final isGuestProvider = Provider<bool>((ref) {
  ref.watch(authStateChangesProvider);
  final user = ref.read(authRepositoryProvider).currentUser;
  return user == null;
});

/// 現在のユーザーの連携済みログイン方法（メール・Google・Apple 等）
final userIdentitiesProvider = FutureProvider<List<UserIdentity>>((ref) async {
  ref.watch(authStateChangesProvider);
  final auth = ref.read(authRepositoryProvider);
  if (auth.currentUser == null) return [];
  return auth.getUserIdentities();
});
