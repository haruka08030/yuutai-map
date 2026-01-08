import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';

const _onboardingCompletedKey = 'onboardingCompleted';

/// Provider to check if onboarding has been completed
final onboardingCompletedProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(_onboardingCompletedKey) ?? false;
});

/// Function to mark onboarding as completed
Future<void> completeOnboarding(Ref ref) async {
  final prefs = ref.read(sharedPreferencesProvider);
  await prefs.setBool(_onboardingCompletedKey, true);
}
