import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/user_benefit_repository.dart';
import '../../../data/supabase/supabase_client_provider.dart';
import '../domain/user_benefit.dart';
import 'benefit_filter.dart';

final benefitFilterProvider = StateProvider<BenefitFilter>(
  (_) => BenefitFilter.today,
);
final searchQueryProvider = StateProvider<String>((_) => '');

final userBenefitRepositoryProvider = Provider<UserBenefitRepository>((ref) {
  final client = ref.read(supabaseProvider);
  return UserBenefitRepository(client);
});

final benefitsProvider = FutureProvider.autoDispose<List<UserBenefit>>((
  ref,
) async {
  final repo = ref.read(userBenefitRepositoryProvider);
  final filter = ref.watch(benefitFilterProvider);
  final q = ref.watch(searchQueryProvider);
  return repo.fetchByFilter(filter: filter, query: q);
});
