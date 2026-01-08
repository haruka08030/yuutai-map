import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

sealed class AppException implements Exception {
  AppException(this.message);
  final String message;

  factory AppException.from(dynamic error) {
    if (error is AuthException) {
      // Supabase Auth specific error mapping
      switch (error.code) {
        case 'invalid_credentials':
          return AuthExceptionApp('メールアドレスまたはパスワードが正しくありません。');
        case 'email_not_confirmed':
          return AuthExceptionApp('メールアドレスが確認されていません。');
        case 'user_not_found':
          return AuthExceptionApp('ユーザーが見つかりませんでした。');
        case 'email_exists':
          return AuthExceptionApp('このメールアドレスは既に登録されています。');
        default:
          return AuthExceptionApp('認証エラーが発生しました。しばらく時間をおいて再度お試しください。');
      }
    }

    if (error is SocketException || error is IOException) {
      return NetworkExceptionApp('ネットワーク接続エラーが発生しました。通信環境を確認してください。');
    }

    if (error is PostgrestException) {
      return DatabaseExceptionApp('データの取得または保存中にエラーが発生しました。');
    }

    return UnknownExceptionApp('予期せぬエラーが発生しました。');
  }
}

class AuthExceptionApp extends AppException {
  AuthExceptionApp(super.message);
}

class NetworkExceptionApp extends AppException {
  NetworkExceptionApp(super.message);
}

class DatabaseExceptionApp extends AppException {
  DatabaseExceptionApp(super.message);
}

class UnknownExceptionApp extends AppException {
  UnknownExceptionApp(super.message);
}
