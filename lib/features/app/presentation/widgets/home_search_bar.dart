import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/theme/search_bar_theme.dart' as app_theme;

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
    final borderColor = AppTheme.dividerColor(context);

    final baseBorder = OutlineInputBorder(
      borderRadius: app_theme.AppSearchBarStyle.borderRadiusValue,
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
          height: app_theme.AppSearchBarStyle.height),
      child: TextField(
        controller: _textController,
        onSubmitted: widget.onSubmitted,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          height: 1.2,
          fontSize: app_theme.AppSearchBarStyle.hintFontSize,
          fontWeight: app_theme.AppSearchBarStyle.hintFontWeight,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: app_theme.AppSearchBarStyle.hintColor,
            fontSize: app_theme.AppSearchBarStyle.hintFontSize,
            fontWeight: app_theme.AppSearchBarStyle.hintFontWeight,
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(
              left: app_theme.AppSearchBarStyle.prefixIconPaddingLeft,
              right: app_theme.AppSearchBarStyle.prefixIconPaddingRight,
            ),
            child: Icon(
              Icons.search_rounded,
              size: app_theme.AppSearchBarStyle.prefixIconSize,
              color: app_theme.AppSearchBarStyle.hintColor,
            ),
          ),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: app_theme.AppSearchBarStyle.suffixIconSize,
                    color: app_theme.AppSearchBarStyle.hintColor,
                  ),
                  onPressed: () {
                    _textController.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!('');
                    }
                  },
                )
              : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: app_theme.AppSearchBarStyle.contentPaddingVertical,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          enabledBorder: baseBorder,
          disabledBorder: baseBorder,
          focusedBorder: baseBorder,
        ),
      ),
    );
  }
}
