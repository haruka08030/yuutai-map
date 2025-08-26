import 'package:flutter_riverpod/flutter_riverpod.dart';

class Preferences {
  // TODO: implement via shared_preferences or flutter_secure_storage
  List<int> get defaultReminderDays => const [30, 7, 1, 0];
}

final preferencesProvider = Provider((_) => Preferences());
