import 'package:flutter/material.dart';

import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_constants.dart';

/// ゲスト用ドロワー本文（新規登録・ログイン）
class DrawerGuestBody extends StatelessWidget {
  const DrawerGuestBody({
    super.key,
    required this.onSignUp,
    required this.onLogin,
  });

  final VoidCallback onSignUp;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
        );
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: kDrawerHorizontalPadding,
        vertical: kDrawerVerticalPadding,
      ),
      children: [
        ListTile(
          leading: const Icon(Icons.person_add_outlined),
          title: Text('新規登録', style: style),
          onTap: onSignUp,
        ),
        ListTile(
          leading: const Icon(Icons.login),
          title: Text('ログイン', style: style),
          onTap: onLogin,
        ),
      ],
    );
  }
}
