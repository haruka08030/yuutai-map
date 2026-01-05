import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitialAuthChoicePage extends StatelessWidget {
  const InitialAuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Yuutai Map へようこそ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(flex: 1),
                ElevatedButton(
                  onPressed: () {
                    context.push('/login');
                  },
                  child: const Text('ログイン'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  child: const Text('新規登録'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    context.go('/main');
                  },
                  child: const Text('ゲストモードで続ける'),
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
