import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/local/drift/database.dart';
import 'package:flutter_stock/data/repositories/user_benefit_repository_facade.dart';
import 'package:flutter_stock/data/repositories/user_benefit_repository_local.dart';
import 'package:flutter_stock/data/repositories/user_benefit_repository_supabase.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/domain/repositories/user_benefit_repository.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

final _dbProvider = Provider<AppDatabase>((ref) => AppDatabase());

final userBenefitRepositoryProvider = Provider<UserBenefitRepository>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localRepository = UserBenefitRepositoryLocal(ref.watch(_dbProvider));
  final supabaseRepository = UserBenefitRepositorySupabase(ref.watch(supabaseProvider));

  return UserBenefitRepositoryFacade(
    authRepository: authRepository,
    localRepository: localRepository,
    supabaseRepository: supabaseRepository,
  );
});
