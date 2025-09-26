import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/local/drift/database.dart';
import 'package:flutter_stock/data/repositories/user_benefit_repository_local.dart';
import 'package:flutter_stock/domain/repositories/user_benefit_repository.dart';

final _dbProvider = Provider<AppDatabase>((ref) => AppDatabase());

final userBenefitRepositoryProvider = Provider<UserBenefitRepository>((ref) {
  final db = ref.watch(_dbProvider);
  return UserBenefitRepositoryLocal(db);
});
