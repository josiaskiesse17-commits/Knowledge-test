import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_colors.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';

ThemeData createLightTheme() {
  const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0x333B82F6),
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0x3310B981),
    onSecondaryContainer: AppColors.secondary,
    tertiary: AppColors.warning,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0x33D97706),
    onTertiaryContainer: AppColors.warning,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.error,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.outline,
    outlineVariant: AppColors.border,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.primaryLight,
    surfaceTint: AppColors.primary,
  );

  final TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppDimensions.fontSizeXxxl,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontSize: AppDimensions.fontSizeXxl,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineLarge: TextStyle(
      fontSize: AppDimensions.fontSizeXxl,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: AppDimensions.fontSizeXl,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    headlineSmall: TextStyle(
      fontSize: AppDimensions.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      fontSize: AppDimensions.fontSizeLg,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: AppDimensions.fontSizeMd,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: AppDimensions.fontSizeSm,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontSize: AppDimensions.fontSizeMd,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: AppDimensions.fontSizeSm,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: AppDimensions.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: AppColors.textTertiary,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: AppDimensions.fontSizeMd,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: AppDimensions.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: AppDimensions.fontSizeXs,
      fontWeight: FontWeight.w500,
      color: AppColors.textTertiary,
      height: 1.4,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: AppColors.surface,
    fontFamily: 'Inter',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: AppDimensions.cardElevation,
      shadowColor: Colors.black.withValues(alpha: 0.03),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
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
        foregroundColor: AppColors.primary,
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
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      labelStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.textSecondary,
      ),
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.textTertiary,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.error,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.border,
      thickness: AppDimensions.dividerThickness,
      space: AppDimensions.spacingLg,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingXs,
      ),
      titleTextStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      leadingAndTrailingTextStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      iconColor: AppColors.textSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
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
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return textTheme.labelSmall?.copyWith(
          color: AppColors.textTertiary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.primary, size: AppDimensions.iconMd);
        }
        return IconThemeData(color: AppColors.textTertiary, size: AppDimensions.iconMd);
      }),
      height: 72,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      actionTextColor: AppColors.primaryLight,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surface,
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
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      disabledColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
      labelStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.textSecondary,
      ),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      side: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
    ),
  );
}