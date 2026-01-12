import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';

final yuutaiCountPerFolderProvider = Provider<Map<String, int>>((ref) {
  final activeYuutaiAsync = ref.watch(activeUsersYuutaiProvider);

  return activeYuutaiAsync.when(
    data: (yuutaiList) {
      final counts = <String, int>{};
      for (final yuutai in yuutaiList) {
        if (yuutai.folderId != null) {
          counts.update(
            yuutai.folderId!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }
      return counts;
    },
    loading: () => {},
    error: (error, stack) => {},
  );
});
