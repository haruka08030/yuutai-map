import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/search_bar_theme.dart' as app_theme;

/// AppBar用の検索テキストフィールド。URLと同期する検索クエリ用。
class AppBarSearchField extends StatefulWidget {
  const AppBarSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<String> onSubmitted;

  @override
  State<AppBarSearchField> createState() => _AppBarSearchFieldState();
}

class _AppBarSearchFieldState extends State<AppBarSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppBarSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: app_theme.AppSearchBarStyle.height,
      decoration: BoxDecoration(
        color: app_theme.AppSearchBarStyle.appBarSearchFieldBackgroundColor,
        borderRadius: app_theme.AppSearchBarStyle.borderRadiusValue,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: const TextStyle(
          fontSize: app_theme.AppSearchBarStyle.hintFontSize,
          fontWeight: app_theme.AppSearchBarStyle.hintFontWeight,
        ),
        decoration: app_theme.AppSearchBarStyle.inputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.controller.text.isNotEmpty
              ? app_theme.AppSearchBarStyle.clearIcon(onPressed: widget.onClear)
              : null,
        ),
      ),
    );
  }
}
