import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

/// 保存完了をテキストなしでカードの動きだけで表現するオーバーレイ。
/// 表示後、アニメーション完了で [onComplete] を呼ぶ。
void showSaveSuccessCardOverlay(
  BuildContext context, {
  required VoidCallback onComplete,
}) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black26,
    barrierDismissible: false,
    builder: (dialogContext) => _SaveSuccessCardOverlay(
      onComplete: () {
        Navigator.of(dialogContext).pop();
        onComplete();
      },
    ),
  );
}

class _SaveSuccessCardOverlay extends StatefulWidget {
  const _SaveSuccessCardOverlay({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_SaveSuccessCardOverlay> createState() =>
      _SaveSuccessCardOverlayState();
}

class _SaveSuccessCardOverlayState extends State<_SaveSuccessCardOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        widget.onComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              size: 44,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
