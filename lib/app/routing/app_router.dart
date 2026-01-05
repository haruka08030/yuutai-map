import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/app/presentation/widgets/shell_screen.dart';
import 'package:flutter_stock/features/auth/presentation/auth_gate.dart';
import 'package:flutter_stock/features/auth/presentation/login_page.dart';
import 'package:flutter_stock/features/auth/presentation/signup_page.dart';
import 'package:flutter_stock/features/auth/provider/auth_notifier.dart';
import 'package:flutter_stock/features/benefits/presentation/company_search_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_management_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_selection_page.dart';
import 'package:flutter_stock/features/map/presentation/map_page.dart';
import 'package:flutter_stock/features/map/presentation/store_detail_page.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/features/settings/presentation/notification_settings_page.dart';
import 'package:flutter_stock/features/settings/presentation/account_detail_page.dart';
import 'package:flutter_stock/features/settings/presentation/settings_page.dart';
import 'package:flutter_stock/features/benefits/presentation/yuutai_search_page.dart';
import 'package:flutter_stock/features/onboarding/presentation/onboarding_page.dart';
import 'package:flutter_stock/features/onboarding/provider/onboarding_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final location = state.uri.path;

      // Check if onboarding needs to be shown (only on first launch)
      if (!onboardingCompleted && location != '/onboarding') {
        return '/onboarding';
      }

      final isAuthPath =
          location == '/' || location == '/login' || location == '/signup';

      if (isLoggedIn && isAuthPath) {
        return '/yuutai';
      }

      final isProtectedSubRoute =
          location.startsWith('/yuutai/') ||
          location.startsWith('/settings/') ||
          location == '/folders';

      if (!isLoggedIn && isProtectedSubRoute) {
        return '/';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const AuthGate()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),

      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return ShellScreen(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/yuutai',
                builder: (BuildContext context, GoRouterState state) =>
                    UsersYuutaiPage(
                      searchQuery: state.uri.queryParameters['search'] ?? '',
                      selectedFolderId: state.uri.queryParameters['folderId'],
                      showHistory:
                          state.uri.queryParameters['showHistory'] == 'true',
                    ),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const UsersYuutaiEditPage(),
                  ),
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final extra = state.extra;
                      if (extra is! UsersYuutai?) {
                        return const Scaffold(
                          body: Center(child: Text('Invalid benefit data')),
                        );
                      }
                      return UsersYuutaiEditPage(existing: extra);
                    },
                  ),
                  GoRoute(
                    path: 'folders',
                    builder: (context, state) => const FolderManagementPage(),
                    routes: [
                      GoRoute(
                        path: 'select',
                        builder: (context, state) =>
                            const FolderSelectionPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'company/search',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: const CompanySearchPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              final tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                      );
                    },
                  ),
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => YuutaiSearchPage(
                      initialQuery: state.uri.queryParameters['q'],
                    ),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/map',
                builder: (BuildContext context, GoRouterState state) =>
                    const MapPage(),
                routes: [
                  GoRoute(
                    path: 'store/detail',
                    builder: (context, state) {
                      final extra = state.extra;
                      if (extra is! Place) {
                        return const Scaffold(
                          body: Center(child: Text('Invalid store data')),
                        );
                      }
                      return StoreDetailPage(place: extra);
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) =>
                        const NotificationSettingsPage(),
                  ),
                  GoRoute(
                    path: 'account',
                    builder: (context, state) => const AccountDetailPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
