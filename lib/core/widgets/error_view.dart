import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('エラー: $error'));
  }
}
