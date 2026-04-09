import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stitch PRD Timetable design tokens and theme helpers.
///
/// Source: Google Stitch `designTheme.designMd` + named colors export.
abstract final class TimetableScanTheme {
  /// CTA gradient end color from the Stitch export.
  static const Color primaryDim = Color(0xFF3D30D4);

  /// Returns the timetable scan color palette for the requested brightness.
  static ColorScheme colorScheme({
    Brightness brightness = Brightness.light,
  }) {
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A40E0),
      brightness: brightness,
    );
    return switch (brightness) {
      Brightness.light => base.copyWith(
        primary: const Color(0xFF4A40E0),
        onPrimary: const Color(0xFFF4F1FF),
        primaryContainer: const Color(0xFF9795FF),
        onPrimaryContainer: const Color(0xFF14007E),
        secondary: const Color(0xFFB00D6A),
        onSecondary: const Color(0xFFFFEFF2),
        secondaryContainer: const Color(0xFFFFC1D6),
        onSecondaryContainer: const Color(0xFF8E0054),
        tertiary: const Color(0xFF006947),
        onTertiary: const Color(0xFFC8FFE0),
        tertiaryContainer: const Color(0xFF69F6B8),
        onTertiaryContainer: const Color(0xFF005A3C),
        error: const Color(0xFFB41340),
        onError: const Color(0xFFFFEFEF),
        errorContainer: const Color(0xFFF74B6D),
        surface: const Color(0xFFFAF4FF),
        onSurface: const Color(0xFF241B3F),
        onSurfaceVariant: const Color(0xFF4B4268),
        outline: const Color(0xFF7B719C),
        outlineVariant: const Color(0xFFB2A6D5),
        surfaceContainerLowest: const Color(0xFFFFFFFF),
        surfaceContainerLow: const Color(0xFFF5EEFF),
        surfaceContainer: const Color(0xFFEDE4FF),
        surfaceContainerHigh: const Color(0xFFE8DEFF),
        surfaceContainerHighest: const Color(0xFFE2D7FF),
      ),
      Brightness.dark => base.copyWith(
        primary: const Color(0xFFC4BDFF),
        onPrimary: const Color(0xFF20126F),
        primaryContainer: const Color(0xFF35289B),
        onPrimaryContainer: const Color(0xFFE7E1FF),
        secondary: const Color(0xFFFFAFD1),
        onSecondary: const Color(0xFF67003E),
        secondaryContainer: const Color(0xFF8E0054),
        onSecondaryContainer: const Color(0xFFFFD9E6),
        tertiary: const Color(0xFF89DBB4),
        onTertiary: const Color(0xFF003824),
        tertiaryContainer: const Color(0xFF005A3C),
        onTertiaryContainer: const Color(0xFFA4F7D0),
        error: const Color(0xFFFFB2C0),
        onError: const Color(0xFF680021),
        errorContainer: const Color(0xFF8D1738),
        onErrorContainer: const Color(0xFFFFD9DF),
        surface: const Color(0xFF151121),
        onSurface: const Color(0xFFF1ECFF),
        onSurfaceVariant: const Color(0xFFD1C5F4),
        outline: const Color(0xFF988DB9),
        outlineVariant: const Color(0xFF4D4567),
        surfaceContainerLowest: const Color(0xFF100D1A),
        surfaceContainerLow: const Color(0xFF1D182C),
        surfaceContainer: const Color(0xFF251F35),
        surfaceContainerHigh: const Color(0xFF2E2740),
        surfaceContainerHighest: const Color(0xFF39314C),
      ),
    };
  }

  /// Returns the shared elevated card shadow for timetable scan surfaces.
  static List<BoxShadow> ambientCardShadow(Color onSurface) {
    return <BoxShadow>[
      BoxShadow(
        color: onSurface.withValues(alpha: 0.08),
        blurRadius: 32,
        offset: const Offset(0, 12),
        spreadRadius: -4,
      ),
    ];
  }

  /// Returns the primary CTA gradient for timetable scan buttons.
  static LinearGradient primaryCtaGradient(ColorScheme scheme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        scheme.primary,
        primaryDim,
      ],
    );
  }

  /// Applies the timetable scan palette and typography to an app theme.
  static ThemeData appTheme(ThemeData parent) {
    final scheme = colorScheme(brightness: parent.brightness);
    final manrope = GoogleFonts.manropeTextTheme(parent.textTheme);
    final merged = GoogleFonts.interTextTheme(manrope);
    final overlay = ThemeData.from(
      colorScheme: scheme,
      textTheme: _buildReadableTextTheme(merged, scheme),
      useMaterial3: true,
    );
    return overlay.copyWith(
      extensions: parent.extensions.values,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: scheme.primary,
        ),
      ),
    );
  }

  static TextTheme _buildReadableTextTheme(
    TextTheme base,
    ColorScheme scheme,
  ) {
    final strong = scheme.onSurface;
    final muted = scheme.onSurfaceVariant;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: strong,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: strong,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: strong,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: strong,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: strong,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: strong,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: strong,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: strong,
        height: 1.55,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: strong,
        height: 1.5,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: muted,
        height: 1.45,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: strong,
        fontWeight: FontWeight.w700,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: muted,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: muted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Build-context helpers for timetable scan spacing and radii.
extension TimetableScanThemeX on BuildContext {
  /// Shared spacing tokens sourced from the design system theme.
  AppSpacingTheme get timetableScanSpacing =>
      Theme.of(this).extension<AppSpacingTheme>() ?? const AppSpacingTheme();

  AppRadiusTheme get _radiusTheme =>
      Theme.of(this).extension<AppRadiusTheme>() ?? const AppRadiusTheme();

  /// Large rounded blocks used by hero and card surfaces.
  BorderRadius get timetableScanLargeRadius =>
      BorderRadius.circular(_radiusTheme.l);

  /// Medium rounded inset sections nested inside cards.
  BorderRadius get timetableScanSectionRadius =>
      BorderRadius.circular(_radiusTheme.m);

  /// Fully rounded button and chip corners.
  BorderRadius get timetableScanPillRadius =>
      BorderRadius.circular(_radiusTheme.pill);
}
