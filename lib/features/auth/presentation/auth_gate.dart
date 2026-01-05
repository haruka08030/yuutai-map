import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart'; // New Import

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (state) {
        final session = state.session;
        if (session != null) {
          // User is logged in. GoRouter's redirect logic will handle
          // navigating away from this page to /yuutai.
          return const AppLoadingIndicator();
        }
        // User is not logged in, defer to GoRouter's redirect
        return const SizedBox.shrink();
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('エラーが発生しました: $error'))),
    );
  }
}
