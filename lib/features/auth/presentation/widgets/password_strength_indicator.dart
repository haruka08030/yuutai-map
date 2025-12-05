import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  // This is a simplified strength check.
  // For a real app, consider using a more robust library or algorithm.
  PasswordStrength _checkStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength.none;
    }
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++; // Uppercase
    if (password.contains(RegExp(r'[a-z]'))) score++; // Lowercase
    if (password.contains(RegExp(r'[0-9]'))) score++; // Digits
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++; // Symbols

    if (score < 2) return PasswordStrength.weak;
    if (score < 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _checkStrength(password);
    Color color;
    double progress;
    String text;

    final appColors = Theme.of(context).extension<AppColors>()!;

    switch (strength) {
      case PasswordStrength.none:
        color = appColors.placeholder;
        progress = 0.0;
        text = 'パスワードを入力してください';
        break;
      case PasswordStrength.weak:
        color = appColors.passwordWeak;
        progress = 0.3;
        text = '弱い';
        break;
      case PasswordStrength.medium:
        color = appColors.passwordMedium;
        progress = 0.6;
        text = '普通';
        break;
      case PasswordStrength.strong:
        color = appColors.passwordStrong;
        progress = 1.0;
        text = '強い';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: appColors.passwordIndicatorBackground,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

enum PasswordStrength {
  none,
  weak,
  medium,
  strong,
}
