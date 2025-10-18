import 'package:flutter/material.dart';

class CompanySearchBar extends StatelessWidget {
  const CompanySearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search for your task...',
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    // スクショの雰囲気に合わせた色味
    const borderColor = Color(0xFFE0E0E0); // ごく薄いグレー
    const placeholderColor = Color(0xFFAFAFAF); // 文字は薄め

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // 角の丸み
      borderSide: const BorderSide(color: borderColor, width: 1),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 40), // 背丈は控えめ
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(height: 1.2), // 行間を詰めて中央寄せ
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: placeholderColor),
          // 左の虫眼鏡（線が細いのでCustomPaintで再現）
          prefixIcon: const _MagnifierIcon(),
          // アイコンとテキストの間隔をスクショ寄りに
          prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 20),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          filled: true,
          fillColor: Colors.white, // 背景は白
          enabledBorder: baseBorder,
          disabledBorder: baseBorder,
          focusedBorder: baseBorder, // 焦点時も色はほぼ変えない（スクショ準拠）
        ),
      ),
    );
  }
}

/// 細い線の虫眼鏡（円と柄）を描く
class _MagnifierIcon extends StatelessWidget {
  const _MagnifierIcon();

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFFAFAFAF);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 6),
      child: CustomPaint(
        size: const Size(18, 18),
        painter: _MagnifierPainter(iconColor),
      ),
    );
  }
}

class _MagnifierPainter extends CustomPainter {
  _MagnifierPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    // ルーペの円
    final r = size.width * 0.38; // 少し余白を持たせる
    final center = Offset(size.width * 0.45, size.height * 0.45);
    canvas.drawCircle(center, r, paint);

    // 柄（45度）
    final handleStart = Offset(center.dx + r * 0.7, center.dy + r * 0.7);
    final handleEnd = Offset(size.width * 0.92, size.height * 0.92);
    canvas.drawLine(handleStart, handleEnd, paint);
  }

  @override
  bool shouldRepaint(covariant _MagnifierPainter oldDelegate) =>
      oldDelegate.color != color;
}