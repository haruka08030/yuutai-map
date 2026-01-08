import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart'; // New Import

class CompanySearchBar extends StatefulWidget {
  const CompanySearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = '優待を検索',
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool autofocus;

  @override
  State<CompanySearchBar> createState() => _CompanySearchBarState();
}

class _CompanySearchBarState extends State<CompanySearchBar> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant CompanySearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      _textController.removeListener(_onTextChanged);
      _textController = widget.controller ?? TextEditingController();
      _textController.addListener(_onTextChanged);
    }
  }

  void _onTextChanged() {
    setState(() {}); // Rebuild to update suffixIcon visibility
    if (widget.onChanged != null) {
      widget.onChanged!(_textController.text);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // スクショの雰囲気に合わせた色味
    final borderColor = AppTheme.dividerColor(context);
    final placeholderColor = AppTheme.placeholderColor(context);

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // 角の丸み
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 40), // 背丈は控えめ
      child: TextField(
        controller: _textController,
        // onChanged is handled by _onTextChanged listener
        onSubmitted: widget.onSubmitted,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(height: 1.2), // 行間を詰めて中央寄せ
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: placeholderColor),
          // 左の虫眼鏡（線が細いのでCustomPaintで再現）
          prefixIcon: const _MagnifierIcon(),
          // アイコンとテキストの間隔をスクショ寄りに
          prefixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 20,
          ),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: placeholderColor),
                  onPressed: () {
                    _textController.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!('');
                    }
                  },
                )
              : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surface, // Background is surface color
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
    final iconColor = AppTheme.placeholderColor(context);
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
