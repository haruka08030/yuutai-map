# Design Rules

This document outlines the design principles, UI patterns, and development workflows for the Yuutai Map project.

## Navigation
- **Labels**: Navigation bars (`BottomNavigationBar`, `NavigationRail`) should not display text labels. Use clear and intuitive icons only.
  - Set `showSelectedLabels: false` and `showUnselectedLabels: false` for `BottomNavigationBar`.
  - Set `labelType: NavigationRailLabelType.none` for `NavigationRail`.
- **AppBar Titles**: AppBars in the main shell should not display text titles. Maintain a minimal aesthetic.

## Coding Standards
- **Color Opacity**: Use `.withValues(alpha: value)` instead of the deprecated `.withOpacity(value)`.
- **Hooks**: Use `HookConsumerWidget` and `useMemoized` for expensive objects like `GlobalKey<FormState>`.

## Development Workflow & Reliability
- **State Model Changes**: Do NOT modify `@freezed` class fields without verifying the structure of existing generated files or immediately running code generation. Confirming the field names in the controller state is critical before updating UI dependencies.
- **Continuous Analysis**: Run `flutter analyze` after completing any logical change (e.g., a new UI section or state logic) to catch syntax errors, unused imports, and deprecations immediately.
- **Structural Integrity**: When using multi-line replacements, always verify that methods remain within class boundaries and that braces `{}` are correctly balanced. Avoid leaving "stray" code at the bottom of files.
