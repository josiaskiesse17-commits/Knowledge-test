import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEF2F2);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color outline = Color(0xFFCBD5E1);
}

extension AppColorsExtension on BuildContext {
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get backgroundColor => Theme.of(this).colorScheme.surface;
  Color get textPrimaryColor => Theme.of(this).colorScheme.onSurface;
  Color get textSecondaryColor => Theme.of(this).colorScheme.onSurfaceVariant;
}