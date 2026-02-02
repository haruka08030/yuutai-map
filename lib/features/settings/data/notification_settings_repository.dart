import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';

const _defaultNotifyDaysKey = 'defaultNotifyDays';
const List<int> _initialDefaultDays = [30, 7, 0];

class NotificationSettingsRepository {
  NotificationSettingsRepository(this._ref);

  final Ref _ref;

  List<int> getDefaultNotifyDays() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final stored = prefs.getStringList(_defaultNotifyDaysKey);
    if (stored == null) {
      return _initialDefaultDays;
    }
    final parsed = stored.map((s) => int.tryParse(s)).whereType<int>().toList();
    return parsed.isEmpty ? _initialDefaultDays : parsed;
  }

  Future<void> setDefaultNotifyDays(List<int> days) async {
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs.setStringList(
      _defaultNotifyDaysKey,
      days.map((d) => d.toString()).toList(),
    );
  }
}

final notificationSettingsRepositoryProvider =
    Provider<NotificationSettingsRepository>((ref) {
      return NotificationSettingsRepository(ref);
    });

final defaultNotifyDaysProvider =
    NotifierProvider<DefaultNotifyDaysNotifier, List<int>>(
      DefaultNotifyDaysNotifier.new,
    );

class DefaultNotifyDaysNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    final repository = ref.watch(notificationSettingsRepositoryProvider);
    return repository.getDefaultNotifyDays();
  }

  Future<void> updateDays(List<int> days) async {
    final repository = ref.read(notificationSettingsRepositoryProvider);
    await repository.setDefaultNotifyDays(days);
    state = days;
  }
}
