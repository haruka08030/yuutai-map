import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/auth/presentation/initial_auth_choice_page.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart'; // New Import
import 'package:go_router/go_router.dart';
import 'package:flutter/scheduler.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (state) {
        final session = state.session;
        if (session != null) {
          // User is logged in, redirect to main app shell
          // Use addPostFrameCallback to avoid calling context.go during build
          SchedulerBinding.instance.addPostFrameCallback((_) {
            context.go('/yuutai');
          });
          // Return a placeholder while redirecting
          return const AppLoadingIndicator();
        }
        // User is not logged in, show initial choice screen
        return const InitialAuthChoicePage();
      },
      loading: () => const AppLoadingIndicator(),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('エラーが発生しました: $error'))),
    );
  }
}
