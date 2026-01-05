import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the Notifier class
class SelectedFolderIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null; // Initial state is null
  }

  void setSelectedFolderId(String? folderId) {
    state = folderId; // Update the state
  }
}

// Expose the NotifierProvider
final selectedFolderIdProvider =
    NotifierProvider<SelectedFolderIdNotifier, String?>(() {
  return SelectedFolderIdNotifier();
});