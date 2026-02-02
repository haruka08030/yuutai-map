import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/folders/data/supabase_folder_repository.dart';
import 'package:flutter_stock/core/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/domain/repositories/folder_repository.dart';

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  return FolderRepositorySupabase(ref.watch(supabaseProvider));
});

final foldersProvider = StreamProvider<List<Folder>>((ref) {
  final repo = ref.watch(folderRepositoryProvider);
  return repo.watchFolders();
});
