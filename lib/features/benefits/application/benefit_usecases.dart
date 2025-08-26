import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/user_benefit.dart';
import 'package:flutter_stock/features/benefits/application/benefits_provider.dart';

final addBenefitUsecase = Provider(
  (ref) => (UserBenefit b) async {
    await ref.read(userBenefitRepositoryProvider).create(b);
    ref.invalidate(benefitsProvider);
  },
);

final updateBenefitUsecase = Provider(
  (ref) => (UserBenefit b) async {
    await ref.read(userBenefitRepositoryProvider).update(b);
    ref.invalidate(benefitsProvider);
  },
);

final deleteBenefitUsecase = Provider(
  (ref) => (String id) async {
    await ref.read(userBenefitRepositoryProvider).delete(id);
    ref.invalidate(benefitsProvider);
  },
);

final toggleUsedUsecase = Provider(
  (ref) => (String id, bool isUsed) async {
    await ref
        .read(userBenefitRepositoryProvider)
        .toggleUsed(id: id, isUsed: isUsed);
    ref.invalidate(benefitsProvider);
  },
);
