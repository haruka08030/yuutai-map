import 'package:flutter_stock/features/folders/domain/entities/folder.dart';

abstract class FolderRepository {
  Stream<List<Folder>> watchFolders();
  Future<List<Folder>> getFolders();
  Future<void> createFolder(String name);
  Future<void> updateFolder(String id, String name, int sortOrder);
  Future<void> deleteFolder(String id);
}
