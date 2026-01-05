import 'package:flutter/material.dart';

class MapGuestRegisterDialog extends StatelessWidget {
  final String storeName;
  final VoidCallback onRegisterPressed;

  const MapGuestRegisterDialog({
    super.key,
    required this.storeName,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '「$storeName」の優待を管理するには、アカウント登録が必要です。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onRegisterPressed,
                child: const Text('登録・ログイン画面へ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String storeName,
    required VoidCallback onRegisterPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => MapGuestRegisterDialog(
        storeName: storeName,
        onRegisterPressed: onRegisterPressed,
      ),
    );
  }
}
