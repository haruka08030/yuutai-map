import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  final IconData? icon;
  final String? imagePath;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ), // Added horizontal margin
                child: ClipRRect(
                  // Added ClipRRect for rounded corners
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Apply desired radius
                  child: Image.asset(
                    imagePath!,
                    fit: BoxFit.contain, // Ensure proper scaling
                  ),
                ),
              )
            else if (icon != null)
              Icon(icon, size: 80, color: AppTheme.dividerColor(context))
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                ), // Added horizontal margin
                child: ClipRRect(
                  // Added ClipRRect for rounded corners
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Apply desired radius
                  child: Image.asset(
                    'assets/images/empty_state.png',
                    fit: BoxFit.contain, // Ensure proper scaling
                  ),
                ),
              ),
            const SizedBox(height: 32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.secondaryTextColor(context),
                  height: 1.5,
                ),
              ),
            ],
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  actionLabel!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
