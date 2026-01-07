import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/data/repositories/supabase_folder_repository.dart';
import 'package:flutter_stock/data/supabase/supabase_client_provider.dart';
import 'package:flutter_stock/domain/entities/folder.dart';
import 'package:flutter_stock/domain/repositories/folder_repository.dart';

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  return FolderRepositorySupabase(ref.watch(supabaseProvider));
});

final foldersProvider = StreamProvider<List<Folder>>((ref) {
  final repo = ref.watch(folderRepositoryProvider);
  return repo.watchFolders();
});
