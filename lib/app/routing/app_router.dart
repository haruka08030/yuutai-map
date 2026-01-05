import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/app/presentation/widgets/shell_screen.dart'; // New import
import 'package:flutter_stock/features/auth/presentation/auth_gate.dart';
import 'package:flutter_stock/features/auth/presentation/login_page.dart';
import 'package:flutter_stock/features/auth/presentation/signup_page.dart';
import 'package:flutter_stock/features/benefits/presentation/company_search_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart'; // Explicitly import UsersYuutaiPage
import 'package:flutter_stock/features/folders/presentation/folder_management_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_selection_page.dart';
import 'package:flutter_stock/features/map/presentation/map_page.dart'; // Explicitly import MapPage
import 'package:flutter_stock/features/map/presentation/store_detail_page.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/features/settings/presentation/notification_settings_page.dart';
import 'package:flutter_stock/features/settings/presentation/settings_page.dart';



final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/', // AuthGate is still the initial entry point
    routes: <RouteBase>[
      // Authentication Routes
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

      // Main application shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return ShellScreen(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // Yuutai List Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/yuutai', // Root for Yuutai List tab
                builder: (BuildContext context, GoRouterState state) => UsersYuutaiPage(
                  searchQuery: state.uri.queryParameters['search'] ?? '',
                  selectedFolderId: state.uri.queryParameters['folderId'],
                  showHistory: state.uri.queryParameters['showHistory'] == 'true',
                ),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const UsersYuutaiEditPage(),
                  ),
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final benefit = state.extra as UsersYuutai?;
                      return UsersYuutaiEditPage(existing: benefit);
                    },
                  ),
                  GoRoute(
                    path: 'folders', // Nested route for folder management
                    builder: (context, state) => const FolderManagementPage(),
                    routes: [
                      GoRoute(
                        path: 'select',
                        builder: (context, state) => const FolderSelectionPage(),
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
                ],
              ),
            ],
          ),

          // Map Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/map', // Root for Map tab
                builder: (BuildContext context, GoRouterState state) => const MapPage(),
                routes: [
                  GoRoute(
                    path: 'store/detail',
                    builder: (context, state) {
                      final place = state.extra as Place;
                      return StoreDetailPage(place: place);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Settings Branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings', // Root for Settings tab
                builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) => const NotificationSettingsPage(),
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
