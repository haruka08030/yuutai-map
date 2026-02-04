import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.secondaryText,
    required this.divider,
    required this.placeholder,
    required this.benefitChipBackground,
    required this.folderActionBackground,
    required this.editActionBackground,
    required this.deleteActionBackground,
    required this.deleteActionForeground,
    required this.googleButtonBackground,
    required this.googleButtonForeground,
    required this.appleButtonBackground,
    required this.appleButtonForeground,
    required this.drawerHeaderBackground,
    required this.drawerHeaderForeground,
    required this.skeletonBase,
    required this.passwordWeak,
    required this.passwordMedium,
    required this.passwordStrong,
    required this.passwordIndicatorBackground,
    required this.expiringSoon,
    required this.expiringUrgent,
    required this.cardBackground,
    required this.chipForeground,
  });

  final Color secondaryText;
  final Color divider;
  final Color placeholder;
  final Color benefitChipBackground;
  final Color folderActionBackground;
  final Color editActionBackground;
  final Color deleteActionBackground;
  final Color deleteActionForeground;
  final Color googleButtonBackground;
  final Color googleButtonForeground;
  final Color appleButtonBackground;
  final Color appleButtonForeground;
  final Color drawerHeaderBackground;
  final Color drawerHeaderForeground;
  final Color skeletonBase;
  final Color passwordWeak;
  final Color passwordMedium;
  final Color passwordStrong;
  final Color passwordIndicatorBackground;
  final Color expiringSoon;
  final Color expiringUrgent;
  final Color cardBackground;
  final Color chipForeground;

  @override
  AppColors copyWith({
    Color? secondaryText,
    Color? divider,
    Color? placeholder,
    Color? benefitChipBackground,
    Color? folderActionBackground,
    Color? editActionBackground,
    Color? deleteActionBackground,
    Color? deleteActionForeground,
    Color? googleButtonBackground,
    Color? googleButtonForeground,
    Color? appleButtonBackground,
    Color? appleButtonForeground,
    Color? drawerHeaderBackground,
    Color? drawerHeaderForeground,
    Color? skeletonBase,
    Color? passwordWeak,
    Color? passwordMedium,
    Color? passwordStrong,
    Color? passwordIndicatorBackground,
    Color? expiringSoon,
    Color? expiringUrgent,
    Color? cardBackground,
    Color? chipForeground,
  }) {
    return AppColors(
      secondaryText: secondaryText ?? this.secondaryText,
      divider: divider ?? this.divider,
      placeholder: placeholder ?? this.placeholder,
      benefitChipBackground:
          benefitChipBackground ?? this.benefitChipBackground,
      folderActionBackground:
          folderActionBackground ?? this.folderActionBackground,
      editActionBackground: editActionBackground ?? this.editActionBackground,
      deleteActionBackground:
          deleteActionBackground ?? this.deleteActionBackground,
      deleteActionForeground:
          deleteActionForeground ?? this.deleteActionForeground,
      googleButtonBackground:
          googleButtonBackground ?? this.googleButtonBackground,
      googleButtonForeground:
          googleButtonForeground ?? this.googleButtonForeground,
      appleButtonBackground:
          appleButtonBackground ?? this.appleButtonBackground,
      appleButtonForeground:
          appleButtonForeground ?? this.appleButtonForeground,
      drawerHeaderBackground:
          drawerHeaderBackground ?? this.drawerHeaderBackground,
      drawerHeaderForeground:
          drawerHeaderForeground ?? this.drawerHeaderForeground,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      passwordWeak: passwordWeak ?? this.passwordWeak,
      passwordMedium: passwordMedium ?? this.passwordMedium,
      passwordStrong: passwordStrong ?? this.passwordStrong,
      passwordIndicatorBackground:
          passwordIndicatorBackground ?? this.passwordIndicatorBackground,
      expiringSoon: expiringSoon ?? this.expiringSoon,
      expiringUrgent: expiringUrgent ?? this.expiringUrgent,
      cardBackground: cardBackground ?? this.cardBackground,
      chipForeground: chipForeground ?? this.chipForeground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      benefitChipBackground: Color.lerp(
        benefitChipBackground,
        other.benefitChipBackground,
        t,
      )!,
      folderActionBackground: Color.lerp(
        folderActionBackground,
        other.folderActionBackground,
        t,
      )!,
      editActionBackground: Color.lerp(
        editActionBackground,
        other.editActionBackground,
        t,
      )!,
      deleteActionBackground: Color.lerp(
        deleteActionBackground,
        other.deleteActionBackground,
        t,
      )!,
      deleteActionForeground: Color.lerp(
        deleteActionForeground,
        other.deleteActionForeground,
        t,
      )!,
      googleButtonBackground: Color.lerp(
        googleButtonBackground,
        other.googleButtonBackground,
        t,
      )!,
      googleButtonForeground: Color.lerp(
        googleButtonForeground,
        other.googleButtonForeground,
        t,
      )!,
      appleButtonBackground: Color.lerp(
        appleButtonBackground,
        other.appleButtonBackground,
        t,
      )!,
      appleButtonForeground: Color.lerp(
        appleButtonForeground,
        other.appleButtonForeground,
        t,
      )!,
      drawerHeaderBackground: Color.lerp(
        drawerHeaderBackground,
        other.drawerHeaderBackground,
        t,
      )!,
      drawerHeaderForeground: Color.lerp(
        drawerHeaderForeground,
        other.drawerHeaderForeground,
        t,
      )!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      passwordWeak: Color.lerp(passwordWeak, other.passwordWeak, t)!,
      passwordMedium: Color.lerp(passwordMedium, other.passwordMedium, t)!,
      passwordStrong: Color.lerp(passwordStrong, other.passwordStrong, t)!,
      passwordIndicatorBackground: Color.lerp(
        passwordIndicatorBackground,
        other.passwordIndicatorBackground,
        t,
      )!,
      expiringSoon: Color.lerp(expiringSoon, other.expiringSoon, t)!,
      expiringUrgent: Color.lerp(expiringUrgent, other.expiringUrgent, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      chipForeground: Color.lerp(chipForeground, other.chipForeground, t)!,
    );
  }

  static const light = AppColors(
    secondaryText: Color(0xFF64748B), // Slate 500
    divider: Color(0xFFE2E8F0), // Slate 200
    placeholder: Color(0xFF94A3B8), // Slate 400
    benefitChipBackground: Color(0xFFF0FDFA), // Teal 50
    chipForeground: Color(0xFF0D9488), // Teal 600
    folderActionBackground: Color(0xFF2563EB), // Blue 600
    editActionBackground: Color(0xFF0D9488), // Teal 600
    deleteActionBackground: Color(0xFFEF4444), // Red 500
    deleteActionForeground: Color(0xFFFFFFFF),
    googleButtonBackground: Color(0xFFFFFFFF),
    googleButtonForeground: Color(0xFF111827), // Gray 900
    appleButtonBackground: Color(0xFF000000),
    appleButtonForeground: Color(0xFFFFFFFF),
    drawerHeaderBackground: Color(0xFF24A19C),
    drawerHeaderForeground: Color(0xFFFFFFFF),
    skeletonBase: Color(0xFFF3F4F6), // Gray 100
    passwordWeak: Color(0xFFEF4444),
    passwordMedium: Color(0xFFF59E0B),
    passwordStrong: Color(0xFF10B981),
    passwordIndicatorBackground: Color(0xFFE5E7EB),
    expiringSoon: Color(0xFFF59E0B),
    expiringUrgent: Color(0xFFEF4444),
    cardBackground: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    secondaryText: Color(0xFF94A3B8), // Slate 400
    divider: Color(0xFF334155), // Slate 700
    placeholder: Color(0xFF64748B), // Slate 500
    benefitChipBackground: Color(0xFF134E4A), // Teal 900
    chipForeground: Color(0xFF2DD4BF), // Teal 400
    folderActionBackground: Color(0xFF60A5FA), // Blue 400
    editActionBackground: Color(0xFF2DD4BF), // Teal 400
    deleteActionBackground: Color(0xFFF87171), // Red 400
    deleteActionForeground: Color(0xFFFFFFFF),
    googleButtonBackground: Color(0xFF1F2937), // Gray 800
    googleButtonForeground: Color(0xFFFFFFFF),
    appleButtonBackground: Color(0xFFFFFFFF),
    appleButtonForeground: Color(0xFF000000),
    drawerHeaderBackground: Color(0xFF134E4A), // Teal 900
    drawerHeaderForeground: Color(0xFFFFFFFF),
    skeletonBase: Color(0xFF1F2937),
    passwordWeak: Color(0xFFF87171),
    passwordMedium: Color(0xFFFBBF24),
    passwordStrong: Color(0xFF34D399),
    passwordIndicatorBackground: Color(0xFF374151),
    expiringSoon: Color(0xFFFBBF24),
    expiringUrgent: Color(0xFFF87171),
    cardBackground: Color(0xFF1F2937),
  );
}
