import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/supabase/supabase_client_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(supabaseProvider);
    final user = client.auth.currentUser;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('サインイン状態'),
          subtitle: Text(user == null ? '未サインイン' : 'UID: ${user.id}'),
        ),
        const SizedBox(height: 8),
        if (user == null) ...[
          FilledButton.icon(
            onPressed: () async {
              await client.auth.signInWithOAuth(Provider.google);
            },
            icon: const Icon(Icons.login),
            label: const Text('Googleでサインイン'),
          ),
        ] else ...[
          FilledButton.icon(
            onPressed: () async {
              await client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('サインアウト'),
          ),
        ],
        const Divider(height: 32),
        SwitchListTile(
          title: const Text('ダークテーマ'),
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('テーマ切替は後で実装')));
          },
        ),
      ],
    );
  }
}
