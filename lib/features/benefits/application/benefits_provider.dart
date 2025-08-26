import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/user_benefit.dart';
import 'package:flutter_stock/data/repositories/user_benefit_repository.dart';

final userBenefitRepositoryProvider = Provider<UserBenefitRepository>((ref) {
  return UserBenefitRepository();
});

final benefitListProvider = FutureProvider.autoDispose<List<UserBenefit>>((
  ref,
) async {
  final repo = ref.watch(userBenefitRepositoryProvider);
  return repo.list();
});
