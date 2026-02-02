import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/data/users_yuutai_repository_supabase.dart';
import 'package:flutter_stock/core/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/domain/repositories/users_yuutai_repository.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';

final usersYuutaiRepositoryProvider = Provider<UsersYuutaiRepository>((ref) {
  return UsersYuutaiRepositorySupabase(ref, ref.watch(supabaseProvider));
});

final activeUsersYuutaiProvider = StreamProvider<List<UsersYuutai>>((ref) {
  final repo = ref.watch(usersYuutaiRepositoryProvider);
  return repo.watchActive();
});

final historyUsersYuutaiProvider = StreamProvider<List<UsersYuutai>>((ref) {
  final repo = ref.watch(usersYuutaiRepositoryProvider);
  return repo.watchAll().map(
    (list) => list
        .where(
          (i) =>
              i.status == BenefitStatus.used ||
              i.status == BenefitStatus.expired,
        )
        .toList(),
  );
});
