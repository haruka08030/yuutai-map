import 'package:flutter/material.dart';

/// 検索バーのサイズ・角丸・ヒント文字サイズを画面を超えて統一するための定数。
/// （Flutter の SearchBarTheme と区別するため AppSearchBarStyle とする）
class AppSearchBarStyle {
  AppSearchBarStyle._();

  /// 検索バーの高さ（全画面共通）
  static const double height = 48;

  /// 角丸の半径（全画面共通）
  static const double borderRadius = 16;

  /// ライトモード時の検索バー枠色（一覧・マップ共通）
  static const Color borderLight = Color(0x7FE2E7EF);

  /// ライトモード時の検索バー影色（一覧・マップ共通）
  static const Color shadowLight = Color(0x0C000000);

  /// ヒントテキストのフォントサイズ
  static const double hintFontSize = 14;

  /// ヒントテキストのフォントウェイト
  static const FontWeight hintFontWeight = FontWeight.w500;

  /// ヒント・入力テキストのグレー色
  static const Color hintColor = Color(0xFF64748B);

  /// AppBar内検索フィールドの背景色（枠なしのグレー）
  static const Color appBarSearchFieldBackgroundColor = Color(0xFFECF0F5);

  /// 検索バー内の縦パディング（contentPadding vertical）
  static const double contentPaddingVertical = 14;

  /// プレフィックス（虫眼鏡）アイコンサイズ
  static const double prefixIconSize = 20;

  /// プレフィックスアイコンの左パディング
  static const double prefixIconPaddingLeft = 16;

  /// プレフィックスアイコンの右パディング（アイコンとテキストの間）
  static const double prefixIconPaddingRight = 10;

  /// サフィックス（クリア）アイコンサイズ
  static const double suffixIconSize = 20;

  /// 角丸の BorderRadius
  static BorderRadius get borderRadiusValue =>
      BorderRadius.circular(borderRadius);

  /// 検索バーコンテナの装飾（一覧・マップで共通。ライトは白+枠、ダークはテーマ色）
  static BoxDecoration containerDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      final scheme = Theme.of(context).colorScheme;
      return BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: borderRadiusValue,
        border: Border.all(color: scheme.outlineVariant),
      );
    }
    return BoxDecoration(
      color: Colors.white,
      borderRadius: borderRadiusValue,
      border: Border.all(color: borderLight),
    );
  }

  /// 検索用 TextField の共通 InputDecoration（prefixIcon・hintStyle・padding を統一）
  static InputDecoration inputDecoration({
    required String hintText,
    Widget? suffixIcon,
    InputBorder? border,
    bool filled = false,
    Color? fillColor,

    /// 未指定時は [hintColor]。マップヘッダーなどでプレフィックスだけ別色にする場合に指定。
    Color? prefixIconColor,
  }) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: hintColor,
          fontSize: hintFontSize,
          fontWeight: hintFontWeight,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: prefixIconPaddingLeft,
            right: prefixIconPaddingRight,
          ),
          child: Icon(
            Icons.search_rounded,
            size: prefixIconSize,
            color: prefixIconColor ?? hintColor,
          ),
        ),
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: contentPaddingVertical),
        border: border ?? InputBorder.none,
        filled: filled,
        fillColor: fillColor,
      );

  /// クリアボタン用アイコン（suffixIcon で共通利用）
  static Widget clearIcon({VoidCallback? onPressed, Color? color}) =>
      IconButton(
        icon: Icon(
          Icons.clear_rounded,
          size: suffixIconSize,
          color: color ?? hintColor,
        ),
        onPressed: onPressed,
      );
}
