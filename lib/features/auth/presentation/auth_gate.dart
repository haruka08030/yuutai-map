import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/app/presentation/main_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // By watching authStateChangesProvider, we ensure that the app will
    // rebuild relevant widgets when the user logs in or out.
    ref.watch(authStateChangesProvider);

    // Always show the main page. The UI inside MainPage and its children
    // will adapt based on the login state (using isGuestProvider).
    return const MainPage();
  }
}
