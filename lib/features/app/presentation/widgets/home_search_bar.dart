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
        decoration: app_theme.AppSearchBarStyle.inputDecoration(
          hintText: widget.hintText,
          suffixIcon: _textController.text.isNotEmpty
              ? app_theme.AppSearchBarStyle.clearIcon(
                  onPressed: () {
                    _textController.clear();
                    widget.onChanged?.call('');
                  },
                )
              : null,
          border: baseBorder,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ).copyWith(
          isDense: true,
          enabledBorder: baseBorder,
          disabledBorder: baseBorder,
          focusedBorder: baseBorder,
        ),
      ),
    );
  }
}
