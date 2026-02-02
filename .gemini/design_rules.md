# Design Rules

This document outlines the design principles, UI patterns, and development
workflows for the Yuutai Map project.

## Navigation

- **Labels**: Navigation bars (`BottomNavigationBar`, `NavigationRail`) should
  not display text labels. Use clear and intuitive icons only.
  - Set `showSelectedLabels: false` and `showUnselectedLabels: false` for
    `BottomNavigationBar`.
  - Set `labelType: NavigationRailLabelType.none` for `NavigationRail`.
- **AppBar Titles**: AppBars in the main shell should not display text titles.
  Maintain a minimal aesthetic.
