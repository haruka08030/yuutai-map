import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/features/auth/presentation/auth_gate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart'; // New import
import 'package:flutter_stock/app/theme/theme_provider.dart'; // New import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('ja_JP');
  await NotificationService.instance.initialize();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final sharedPreferences = await SharedPreferences.getInstance(); // Init SharedPreferences

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences), // Override provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget { // Changed from StatelessWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef ref
    final themeMode = ref.watch(themeProvider); // Watch themeProvider

    return MaterialApp(
      title: 'yuutai-map',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark, // Added darkTheme
      themeMode: themeMode, // Used themeMode from provider
      home: const AuthGate(),
    );
  }
}