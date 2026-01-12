// 開発用プレビュー: ログイン済みユーザー画面を表示
// 実行方法: flutter run -t test/dev_preview.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/app/presentation/widgets/shell_screen.dart';
import 'package:flutter_stock/features/app/providers/app_providers.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/auth/provider/auth_notifier.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/domain/repositories/users_yuutai_repository.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/domain/repositories/folder_repository.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/features/map/presentation/controllers/map_controller.dart';
import 'package:flutter_stock/features/map/presentation/map_page.dart';
import 'package:flutter_stock/features/map/presentation/state/map_state.dart';
import 'package:flutter_stock/features/settings/presentation/account_detail_page.dart';
import 'package:flutter_stock/features/settings/presentation/email_edit_page.dart';
import 'package:flutter_stock/features/settings/presentation/settings_page.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/routing/app_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock Providers & Classes
class FakeAuthNotifier extends ChangeNotifier implements AuthNotifier {
  @override
  bool get isLoggedIn => true;

  @override
  bool get isGuest => false;
}

class MockAuthRepository extends ChangeNotifier implements AuthRepository {
  @override
  User? get currentUser => const User(
    id: 'preview_user_id',
    appMetadata: {},
    userMetadata: {'username': 'Preview User'},
    aud: 'authenticated',
    createdAt: '2023-01-01T00:00:00.000Z',
  );

  @override
  bool get isGuest => false;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  Future<void> signInAsGuest() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> updateUserProfile({String? username}) async {}

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
  }) async {}

  @override
  Future<void> resendConfirmationEmail({required String email}) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> resetPasswordForEmail({required String email}) async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<void> updateUserEmail({required String newEmail}) async {}
}

class MockUsersYuutaiRepository implements UsersYuutaiRepository {
  @override
  Stream<List<UsersYuutai>> watchAll() {
    return const Stream.empty();
  }

  @override
  Stream<List<UsersYuutai>> watchActive() => watchAll();

  @override
  Future<List<UsersYuutai>> getActive() async => [];

  @override
  Future<void> upsert(
    UsersYuutai benefit, {
    bool scheduleReminders = true,
  }) async {}

  @override
  Future<void> updateStatus(
    int id,
    BenefitStatus status, {
    bool scheduleReminders = true,
  }) async {}

  @override
  Future<void> delete(int id, {bool scheduleReminders = true}) async {}

  @override
  Future<List<UsersYuutai>> search(String query) async => [];
}

class MockFolderRepository implements FolderRepository {
  @override
  Stream<List<Folder>> watchFolders() {
    return Stream.value([
      const Folder(id: '1', name: '食事', sortOrder: 0),
      const Folder(id: '2', name: '買い物', sortOrder: 1),
    ]);
  }

  @override
  Future<List<Folder>> getFolders() async => [];

  @override
  Future<void> createFolder(String name) async {}

  @override
  Future<void> updateFolder(String id, String name, int sortOrder) async {}

  @override
  Future<void> deleteFolder(String id) async {}
}

// Mock Map Controller
class MockMapController extends AsyncNotifier<MapState>
    implements MapController {
  @override
  Future<MapState> build() async {
    return MapState(
      items: [],
      currentPosition: Position(
        longitude: 139.7671,
        latitude: 35.6812,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      ),
      availableCategories: ['飲食', 'ファッション'],
      showAllStores: true,
      selectedCategories: {},
      isGuest: false,
    );
  }

  @override
  Future<void> applyFilters({
    required bool showAllStores,
    required Set<String> selectedCategories,
    String? folderId,
  }) async {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await initializeDateFormatting('ja_JP');

  // SharedPreferencesの初期化（モック）
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();

  // モックデータ
  final mockYuutaiList = [
    const UsersYuutai(
      id: 1,
      companyName: 'テスト株式会社',
      benefitDetail: '10%割引券',
      status: BenefitStatus.active,
      expiryDate: null,
      folderId: '1',
    ),
    UsersYuutai(
      id: 2,
      companyName: 'サンプルフード',
      benefitDetail: '食事券 1000円分',
      status: BenefitStatus.active,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      folderId: '1',
    ),
  ];

  // Mock Repository initialization
  final mockUsersYuutaiRepository = MockUsersYuutaiRepository();
  final mockFolderRepository = MockFolderRepository();
  final fakeAuthNotifier = FakeAuthNotifier();
  final mockAuthRepository = MockAuthRepository();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        authNotifierProvider.overrideWith((ref) => fakeAuthNotifier),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        isGuestProvider.overrideWithValue(false),
        activeUsersYuutaiProvider.overrideWith(
          (ref) => Stream.value(mockYuutaiList),
        ),
        usersYuutaiRepositoryProvider.overrideWithValue(
          mockUsersYuutaiRepository,
        ),
        folderRepositoryProvider.overrideWithValue(mockFolderRepository),
        foldersProvider.overrideWith(
          (ref) => mockFolderRepository.watchFolders(),
        ),

        // Map Mock
        mapControllerProvider.overrideWith(() => MockMapController()),

        // Package Info Mock
        packageInfoProvider.overrideWith(
          (ref) async => PackageInfo(
            appName: 'Flutter Stock',
            packageName: 'com.example.flutter_stock',
            version: '1.0.0',
            buildNumber: '1',
          ),
        ),

        // Router Override for Full App Experience
        routerProvider.overrideWith((ref) {
          return GoRouter(
            initialLocation: '/yuutai',
            routes: [
              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) {
                  return ShellScreen(navigationShell: navigationShell);
                },
                branches: [
                  // List Branch
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: '/yuutai',
                        builder: (context, state) {
                          final folderId =
                              state.uri.queryParameters['folderId'];
                          final searchQuery =
                              state.uri.queryParameters['search'] ?? '';

                          // Update provider if needed based on query params (simplified for preview)
                          if (folderId != null) {
                            Future.microtask(
                              () => ref
                                  .read(selectedFolderIdProvider.notifier)
                                  .setSelectedFolderId(folderId),
                            );
                          }

                          return UsersYuutaiPage(
                            searchQuery: searchQuery,
                            selectedFolderId: folderId,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'search',
                            builder: (context, state) => Scaffold(
                              appBar: AppBar(
                                title: const Text('Search Placeholder'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Map Branch
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: '/map',
                        builder: (context, state) => const MapPage(),
                      ),
                    ],
                  ),

                  // Settings Branch
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: '/settings',
                        builder: (context, state) => const SettingsPage(),
                        routes: [
                          GoRoute(
                            path: 'account',
                            builder: (context, state) =>
                                const AccountDetailPage(),
                            routes: [
                              GoRoute(
                                path: 'email/edit',
                                builder: (context, state) =>
                                    const EmailEditPage(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Other global routes
              GoRoute(
                path: '/yuutai/add',
                builder: (context, state) => const UsersYuutaiEditPage(),
              ),
              GoRoute(
                path: '/yuutai/edit',
                builder: (context, state) {
                  final extra = state.extra;
                  if (extra is UsersYuutai) {
                    return UsersYuutaiEditPage(existing: extra);
                  }
                  return const UsersYuutaiEditPage();
                },
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Login'))),
              ),
              GoRoute(
                path: '/signup',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Signup'))),
              ),
            ],
          );
        }),
      ],
      child: const PreviewApp(),
    ),
  );
}

class PreviewApp extends ConsumerWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Yuutai Map Preview',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', 'JP')],
    );
  }
}
