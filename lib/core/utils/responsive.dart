import 'package:flutter/material.dart';

/// Screen size classes used to adapt the layouts.
///
/// The app runs on narrow Android phones, large phones and tablets, and on
/// Flutter Web in a desktop or wide browser window, so every screen decides its
/// layout from the available width instead of stretching a phone layout.
enum ScreenSize { phone, tablet, desktop }

/// Breakpoints, in logical pixels, for the size classes.
abstract final class AppBreakpoints {
  /// Below this width the layout is a single narrow column.
  static const double phone = 600;

  /// Below this width the layout keeps a readable single column with padding.
  static const double tablet = 1024;

  /// Resolves the size class of [width].
  static ScreenSize sizeOf(double width) {
    if (width >= tablet) return ScreenSize.desktop;
    if (width >= phone) return ScreenSize.tablet;
    return ScreenSize.phone;
  }

  /// True when [width] can show a two-pane (list plus detail) layout.
  static bool supportsTwoPane(double width) => width >= tablet;

  /// Number of columns of a card grid that fits [width].
  static int gridColumns(double width) => switch (sizeOf(width)) {
        ScreenSize.phone => 1,
        ScreenSize.tablet => 2,
        ScreenSize.desktop => 3,
      };

  /// Content is never stretched across a wide window: it is centered and
  /// capped to a comfortable reading measure.
  static double contentMaxWidth(ScreenSize size) => switch (size) {
        ScreenSize.phone => double.infinity,
        ScreenSize.tablet => 720,
        ScreenSize.desktop => 960,
      };

  /// Horizontal page padding, larger on wide screens.
  static double pagePadding(double width) =>
      sizeOf(width) == ScreenSize.phone ? 16 : 24;
}

/// Convenience accessor on [BuildContext].
extension AppResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  ScreenSize get screenSizeClass => AppBreakpoints.sizeOf(screenWidth);

  bool get isPhone => screenSizeClass == ScreenSize.phone;

  bool get isWide => screenSizeClass != ScreenSize.phone;
}
