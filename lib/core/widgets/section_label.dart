import 'package:flutter/material.dart';

/// フィルターやフォームのセクション見出し用ラベル。
class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
