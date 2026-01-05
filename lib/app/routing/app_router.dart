import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/app/presentation/main_page.dart';
import 'package:flutter_stock/features/auth/presentation/auth_gate.dart';
import 'package:flutter_stock/features/auth/presentation/login_page.dart';
import 'package:flutter_stock/features/auth/presentation/signup_page.dart';
import 'package:flutter_stock/features/benefits/presentation/company_search_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_management_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_selection_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: FolderManagementPage.routePath, // which is '/folders'
        builder: (context, state) => const FolderManagementPage(),
      ),
      GoRoute(
        path: '/folders/select',
        builder: (context, state) => const FolderSelectionPage(),
      ),
      GoRoute(
        path: '/company/search',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CompanySearchPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/yuutai/add',
        builder: (context, state) => const UsersYuutaiEditPage(),
      ),
      GoRoute(
        path: '/yuutai/edit',
        builder: (context, state) {
          final benefit = state.extra as UsersYuutai?;
          return UsersYuutaiEditPage(existing: benefit);
        },
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
    ],
  );
});
