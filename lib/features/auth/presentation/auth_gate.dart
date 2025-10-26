import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/app/presentation/main_page.dart';
import 'package:flutter_stock/features/auth/presentation/login_page.dart';
import 'package:flutter_stock/features/auth/presentation/signup_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (state) {
        final session = state.session;
        if (session != null) {
          // User is logged in, ensure guest mode is off
          Future.microtask(
            () => ref.read(isGuestProvider.notifier).state = false,
          );
          return const MainPage();
        }
        return const AuthOptions();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('エラーが発生しました: $error'))),
    );
  }
}

class AuthOptions extends ConsumerWidget {
  const AuthOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ゲストモードの場合はMainPageを表示
    final isGuest = ref.watch(isGuestProvider);
    if (isGuest) {
      return const MainPage();
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                Text(
                  'おかえりなさい',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(flex: 1),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('ログイン'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text('新規登録'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    ref.read(isGuestProvider.notifier).state = true;
                  },
                  child: const Text('ゲストとして利用する'),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
