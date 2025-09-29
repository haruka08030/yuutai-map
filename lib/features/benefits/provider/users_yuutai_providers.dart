import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/local/drift/database.dart';
import 'package:flutter_stock/data/repositories/users_yuutai_repository_facade.dart';
import 'package:flutter_stock/data/repositories/users_yuutai_repository_local.dart';
import 'package:flutter_stock/data/repositories/users_yuutai_repository_supabase.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/domain/repositories/users_yuutai_repository.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

final _dbProvider = Provider<AppDatabase>((ref) => AppDatabase());

final usersYuutaiRepositoryProvider = Provider<UsersYuutaiRepository>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localRepository = UsersYuutaiRepositoryLocal(ref.watch(_dbProvider));
  final supabaseRepository = UsersYuutaiRepositorySupabase(ref.watch(supabaseProvider));

  return UsersYuutaiRepositoryFacade(
    authRepository: authRepository,
    localRepository: localRepository,
    supabaseRepository: supabaseRepository,
  );
});
