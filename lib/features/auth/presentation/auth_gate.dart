import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart'; // New Import
import 'package:flutter_stock/features/auth/provider/auth_notifier.dart'; // New Import

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final authNotifier = ref.watch(authNotifierProvider); // Watch AuthNotifier

    return authState.when(
      data: (state) {
        final isLoggedIn = authNotifier.isLoggedIn;
        final isGuest = authNotifier.isGuest;

        if (isLoggedIn || isGuest) {
          // User is logged in or is a guest. GoRouter's redirect logic will handle
          // navigating away from this page to /yuutai.
          return const AppLoadingIndicator();
        }
        // User is neither logged in nor a guest, defer to GoRouter's redirect
        return const SizedBox.shrink();
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('エラーが発生しました: $error'))),
    );
  }
}
