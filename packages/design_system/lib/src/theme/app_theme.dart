import 'package:design_system/src/theme/extensions/app_radius_theme.dart';
import 'package:design_system/src/theme/extensions/app_spacing_theme.dart';
import 'package:design_system/src/tokens/radius.dart';
import 'package:design_system/src/tokens/spacing.dart';
import 'package:flutter/material.dart';

/// Application theme configuration and management
///
/// This class provides a centralized way to define and manage the application's
/// theme configuration for both light and dark modes. It uses Material 3 design
/// principles and provides consistent theming across the application.
///
/// The theme is built using a seed color (deep purple) that generates a
/// cohesive color scheme for both light and dark variants.
///
/// Example usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   themeMode: ThemeMode.system,
/// )
/// ```
class AppTheme {
  /// Creates an instance of [AppTheme]
  ///
  /// This constructor is const to allow for efficient instantiation
  /// and static access to theme configurations.
  const AppTheme();

  static const List<ThemeExtension<dynamic>> _extensions = [
    AppSpacingTheme(),
    AppRadiusTheme(),
  ];

  /// Gets the light theme configuration
  ///
  /// Returns a pre-configured [ThemeData] for light mode using Material 3
  /// design principles. The theme is generated from a deep purple seed color.
  ///
  /// Returns:
  /// A [ThemeData] configured for light mode
  static ThemeData get lightTheme => const AppTheme().toLightTheme();

  /// Gets the dark theme configuration
  ///
  /// Returns a pre-configured [ThemeData] for dark mode using Material 3
  /// design principles. The theme is generated from a deep purple seed color
  /// with dark brightness.
  ///
  /// Returns:
  /// A [ThemeData] configured for dark mode
  static ThemeData get darkTheme => const AppTheme().toDarkTheme();

  /// Converts the theme configuration to light theme data
  ///
  /// Creates a complete [ThemeData] configuration for light mode with:
  /// - Material 3 design system enabled
  /// - Color scheme generated from deep purple seed color
  /// - Custom AppBar theme with inverse primary background
  /// - Consistent foreground colors
  ///
  /// Returns:
  /// A fully configured [ThemeData] for light mode
  ThemeData toLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      cardColor: colorScheme.surfaceContainerLowest,
      cardShadowOpacity: 0.08,
    );
  }

  static TextTheme _buildTextTheme(Color onSurface) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.15,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: onSurface.withValues(alpha: 0.8),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: onSurface,
      ),
    );
  }

  /// Converts the theme configuration to dark theme data
  ///
  /// Creates a complete [ThemeData] configuration for dark mode with:
  /// - Material 3 design system enabled
  /// - Color scheme generated from deep purple seed color with dark brightness
  /// - Custom AppBar theme with inverse primary background
  /// - Consistent foreground colors optimized for dark mode
  ///
  /// Returns:
  /// A fully configured [ThemeData] for dark mode
  ThemeData toDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      cardColor: colorScheme.surfaceContainerLow,
      cardShadowOpacity: 0.2,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color cardColor,
    required double cardShadowOpacity,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: _extensions,
      textTheme: _buildTextTheme(colorScheme.onSurface),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: cardShadowOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        color: cardColor,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
        ),
      ),
    );
  }
}
