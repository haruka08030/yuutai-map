// 開発用プレビュー: ログイン済みユーザー画面を表示
// 実行方法: flutter run -t test/dev_preview.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:flutter_stock/app/routing/app_router.dart';
import 'package:flutter_stock/features/auth/provider/auth_notifier.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/domain/repositories/users_yuutai_repository.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_page.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// モックAuthNotifier: 常にログイン済みを返す
class FakeAuthNotifier extends ChangeNotifier implements AuthNotifier {
  @override
  bool get isLoggedIn => true;

  @override
  bool get isGuest => false;
}

class MockUsersYuutaiRepository implements UsersYuutaiRepository {
  @override
  Stream<List<UsersYuutai>> watchAll() {
    return Stream.value([
      const UsersYuutai(
        id: 1,
        companyName: 'テスト株式会社',
        benefitDetail: '10%割引券',
        status: BenefitStatus.active,
        expiryDate: null,
        folderId: null,
      ),
      UsersYuutai(
        id: 2,
        companyName: 'サンプルフード',
        benefitDetail: '食事券 1000円分',
        status: BenefitStatus.active,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
        folderId: null,
      ),
    ]);
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
      folderId: null,
    ),
    UsersYuutai(
      id: 2,
      companyName: 'サンプルフード',
      benefitDetail: '食事券 1000円分',
      status: BenefitStatus.active,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      folderId: null,
    ),
  ];

  // Mock Repository initialization
  final mockRepository = MockUsersYuutaiRepository();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier()),
        isGuestProvider.overrideWithValue(false),
        activeUsersYuutaiProvider.overrideWith(
          (ref) => Stream.value(mockYuutaiList),
        ),
        usersYuutaiRepositoryProvider.overrideWithValue(mockRepository),
        // AuthGateや他の場所でrouterProviderが参照されるため、ここもオーバーライドして直接画面を出します
        // AuthGateや他の場所でrouterProviderが参照されるため、ここもオーバーライドして直接画面を出します
        routerProvider.overrideWith((ref) {
          return GoRouter(
            initialLocation: '/yuutai',
            routes: [
              GoRoute(
                path: '/yuutai',
                builder: (context, state) => const UsersYuutaiPage(
                  searchQuery: '',
                  selectedFolderId: null,
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
                      if (extra is UsersYuutai) {
                        return UsersYuutaiEditPage(existing: extra);
                      }
                      return const UsersYuutaiEditPage();
                    },
                  ),
                ],
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

    return MaterialApp.router(
      title: 'Yuutai Map Preview',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light, // 固定または設定可能
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
