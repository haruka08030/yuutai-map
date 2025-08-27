import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/repositories/user_benefit_repository.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/features/benefits/domain/user_benefit.dart';

final userBenefitRepositoryProvider = Provider<UserBenefitRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return UserBenefitRepository(client);
});

final benefitListProvider = FutureProvider.autoDispose<List<UserBenefit>>((
  ref,
) async {
  final repo = ref.watch(userBenefitRepositoryProvider);
  return repo.list();
});
