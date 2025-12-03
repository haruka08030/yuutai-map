import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/repositories/users_yuutai_repository_supabase.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/domain/repositories/users_yuutai_repository.dart';



final usersYuutaiRepositoryProvider = Provider<UsersYuutaiRepository>((ref) {
  return UsersYuutaiRepositorySupabase(
    ref.watch(supabaseProvider),
  );
});
