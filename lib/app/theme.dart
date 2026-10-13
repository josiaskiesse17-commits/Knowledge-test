import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_colors.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';

/// Brightness-aware color palette used by both light and dark themes.
class _AppColorPalette {
  const _AppColorPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.error,
    required this.errorContainer,
    required this.success,
    required this.warning,
    required this.outline,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color error;
  final Color errorContainer;
  final Color success;
  final Color warning;
  final Color outline;
}

const _lightPalette = _AppColorPalette(
  primary: AppColors.primary,
  primaryLight: AppColors.primaryLight,
  primaryDark: AppColors.primaryDark,
  secondary: AppColors.secondary,
  secondaryLight: AppColors.secondaryLight,
  background: AppColors.background,
  surface: AppColors.surface,
  surfaceVariant: AppColors.surfaceVariant,
  textPrimary: AppColors.textPrimary,
  textSecondary: AppColors.textSecondary,
  textTertiary: AppColors.textTertiary,
  border: AppColors.border,
  error: AppColors.error,
  errorContainer: AppColors.errorContainer,
  success: AppColors.success,
  warning: AppColors.warning,
  outline: AppColors.outline,
);

const _darkPalette = _AppColorPalette(
  primary: Color(0xFF60A5FA), // primaryLight for dark
  primaryLight: Color(0xFF93C5FD),
  primaryDark: Color(0xFF3B82F6),
  secondary: Color(0xFF34D399), // secondaryLight for dark
  secondaryLight: Color(0xFF6EE7B7),
  background: Color(0xFF0F172A),
  surface: Color(0xFF1E293B),
  surfaceVariant: Color(0xFF334155),
  textPrimary: Color(0xFFF8FAFC),
  textSecondary: Color(0xFFCBD5E1),
  textTertiary: Color(0xFF94A3B8),
  border: Color(0xFF334155),
  error: Color(0xFFF87171),
  errorContainer: Color(0xFF7F1D1D),
  success: Color(0xFF4ADE80),
  warning: Color(0xFFFBBF24),
  outline: Color(0xFF475569),
);

/// Creates a [ColorScheme] from the given palette and brightness.
ColorScheme _colorSchemeFromPalette(_AppColorPalette p, Brightness brightness) {
  return ColorScheme(
    brightness: brightness,
    primary: p.primary,
    onPrimary: brightness == Brightness.light ? Colors.white : p.background,
    primaryContainer: p.primary.withValues(alpha: 0.15),
    onPrimaryContainer: p.primaryLight,
    secondary: p.secondary,
    onSecondary: brightness == Brightness.light ? Colors.white : p.background,
    secondaryContainer: p.secondary.withValues(alpha: 0.15),
    onSecondaryContainer: p.secondaryLight,
    tertiary: p.warning,
    onTertiary: brightness == Brightness.light ? Colors.white : p.background,
    tertiaryContainer: p.warning.withValues(alpha: 0.15),
    onTertiaryContainer: p.warning,
    error: p.error,
    onError: Colors.white,
    errorContainer: p.errorContainer,
    onErrorContainer: p.error,
    surface: p.surface,
    onSurface: p.textPrimary,
    surfaceContainerHighest: p.surfaceVariant,
    onSurfaceVariant: p.textSecondary,
    outline: p.outline,
    outlineVariant: p.border,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: brightness == Brightness.light ? p.textPrimary : p.background,
    onInverseSurface: brightness == Brightness.light ? p.surface : p.textPrimary,
    inversePrimary: brightness == Brightness.light ? p.primaryDark : p.primaryLight,
    surfaceTint: p.primary,
  );
}

/// Shared text theme used by both light and dark themes.
TextTheme _buildTextTheme(_AppColorPalette p) {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: AppDimensions.fontSizeXxxl,
      fontWeight: FontWeight.w700,
      color: p.textPrimary,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontSize: AppDimensions.fontSizeXxl,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.3,
    ),
    headlineLarge: TextStyle(
      fontSize: AppDimensions.fontSizeXxl,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: AppDimensions.fontSizeXl,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.4,
    ),
    headlineSmall: TextStyle(
      fontSize: AppDimensions.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      fontSize: AppDimensions.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: AppDimensions.fontSizeMd,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: AppDimensions.fontSizeSm,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontSize: AppDimensions.fontSizeMd,
      fontWeight: FontWeight.w400,
      color: p.textPrimary,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: AppDimensions.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: p.textSecondary,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: AppDimensions.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: p.textTertiary,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: AppDimensions.fontSizeMd,
      fontWeight: FontWeight.w600,
      color: p.textPrimary,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: AppDimensions.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: p.textSecondary,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: AppDimensions.fontSizeXs,
      fontWeight: FontWeight.w500,
      color: p.textTertiary,
      height: 1.4,
    ),
  );
}

/// Builds the complete [ThemeData] for the given palette and brightness.
ThemeData _buildTheme(_AppColorPalette p, Brightness brightness) {
  final colorScheme = _colorSchemeFromPalette(p, brightness);
  final textTheme = _buildTextTheme(p);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: p.background,
    fontFamily: 'Inter',
    appBarTheme: AppBarTheme(
      backgroundColor: p.surface,
      foregroundColor: p.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: p.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: p.surface,
      elevation: AppDimensions.cardElevation,
      shadowColor: Colors.black.withValues(alpha: brightness == Brightness.light ? 0.03 : 0.2),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: p.outline.withValues(alpha: 0.2)),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: brightness == Brightness.light ? Colors.white : p.background,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        side: BorderSide(color: p.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingSm,
          vertical: AppDimensions.spacingXs,
        ),
        textStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: p.outline.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: p.outline.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: p.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: p.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: p.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: p.outline.withValues(alpha: 0.2)),
      ),
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: p.textSecondary,
      ),
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: p.textTertiary,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: p.error,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: p.border,
      thickness: AppDimensions.dividerThickness,
      space: AppDimensions.spacingLg,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingXs,
      ),
      titleTextStyle: textTheme.bodyLarge?.copyWith(
        color: p.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: p.textSecondary,
      ),
      leadingAndTrailingTextStyle: textTheme.bodyMedium?.copyWith(
        color: p.textSecondary,
      ),
      iconColor: p.textSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: p.surface,
      selectedItemColor: p.primary,
      unselectedItemColor: p.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w400,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.surface,
      indicatorColor: p.primary.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelSmall?.copyWith(
            color: p.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return textTheme.labelSmall?.copyWith(
          color: p.textTertiary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: p.primary, size: AppDimensions.iconMd);
        }
        return IconThemeData(color: p.textTertiary, size: AppDimensions.iconMd);
      }),
      height: 72,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.textPrimary,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.background),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      actionTextColor: p.primaryLight,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: p.textPrimary,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: p.textSecondary,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      modalBarrierColor: Colors.black.withValues(alpha: 0.5),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.surfaceVariant,
      selectedColor: p.primary.withValues(alpha: 0.1),
      disabledColor: p.surfaceVariant.withValues(alpha: 0.5),
      labelStyle: textTheme.labelMedium?.copyWith(
        color: p.textSecondary,
      ),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: p.primary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        side: BorderSide(color: p.outline.withValues(alpha: 0.3)),
      ),
      side: BorderSide(color: p.outline.withValues(alpha: 0.3)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: p.primary,
      foregroundColor: brightness == Brightness.light ? Colors.white : p.background,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: p.primary,
      unselectedLabelColor: p.textTertiary,
      indicatorColor: p.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
      dividerColor: Colors.transparent,
    ),
  );
}

/// Creates the light theme for the application.
ThemeData createLightTheme() => _buildTheme(_lightPalette, Brightness.light);

/// Creates the dark theme for the application.
ThemeData createDarkTheme() => _buildTheme(_darkPalette, Brightness.dark);