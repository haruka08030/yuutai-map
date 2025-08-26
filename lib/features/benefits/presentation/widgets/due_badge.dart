import 'package:flutter/material.dart';

class DueBadge extends StatelessWidget {
  const DueBadge({super.key, required this.daysLeft});
  final int daysLeft;
  @override
  Widget build(BuildContext context) {
    Color bg;
    final String text = daysLeft >= 0 ? 'D-$daysLeft' : '期限切れ';
    if (daysLeft < 0) {
      bg = Colors.red;
    } else if (daysLeft <= 7)
      bg = Colors.orange;
    else if (daysLeft <= 30)
      bg = Colors.amber;
    else
      bg = Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
