import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/app.dart';
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize date symbols for Japanese locale used by DateFormat('...', 'ja')
  await initializeDateFormatting('ja');
  await NotificationService.instance.initialize();
  runApp(const ProviderScope(child: YuutaiApp()));
}
