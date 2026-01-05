import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/presentation/controllers/users_yuutai_edit_controller.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/users_yuutai_form.dart';

class UsersYuutaiEditPage extends ConsumerWidget {
  const UsersYuutaiEditPage({super.key, this.existing});
  final UsersYuutai? existing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final controller = ref.watch(usersYuutaiEditControllerProvider(existing));
    final notifier = ref.read(usersYuutaiEditControllerProvider(existing).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(existing == null ? '優待を追加' : '優待を編集'),
        actions: [
          if (controller.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            IconButton(
              onPressed: () => notifier.save(context, formKey),
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: UsersYuutaiForm(existing: existing, formKey: formKey),
        ),
      ),
    );
  }
}