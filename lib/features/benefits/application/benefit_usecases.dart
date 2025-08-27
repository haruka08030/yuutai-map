import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/user_benefit.dart';
import 'package:flutter_stock/features/benefits/application/benefits_provider.dart';

final addBenefitUsecase = Provider(
  (ref) => (UserBenefit b) async {
    await ref.read(userBenefitRepositoryProvider).add(b);
    ref.invalidate(benefitListProvider);
  },
);

final updateBenefitUsecase = Provider(
  (ref) => (UserBenefit b) async {
    await ref.read(userBenefitRepositoryProvider).update(b);
    ref.invalidate(benefitListProvider);
  },
);

final deleteBenefitUsecase = Provider(
  (ref) => (String id) async {
    await ref.read(userBenefitRepositoryProvider).delete(id);
    ref.invalidate(benefitListProvider);
  },
);

final toggleUsedUsecase = Provider(
  (ref) => (String id) async {
    await ref.read(userBenefitRepositoryProvider).toggleUsed(id);
    ref.invalidate(benefitListProvider);
  },
);
