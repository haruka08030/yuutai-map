import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatelessWidget {
  const LoadingElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            )
          : child,
    );
  }
}
