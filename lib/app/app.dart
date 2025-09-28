import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/auth/presentation/auth_gate.dart';

class YuutaiApp extends ConsumerWidget {
  const YuutaiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'yuutai-map',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}
