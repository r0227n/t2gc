import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stitch PRD Timetable — design system **Luminous Ledger** tokens.
///
/// Source: Google Stitch `designTheme.designMd` + namedColors export.
abstract final class TimetableScanStitchTokens {
  /// `primary_dim` from Stitch named colors (primary CTA gradient end).
  static const Color primaryDim = Color(0xFF3D30D4);

  /// Light [ColorScheme] aligned with Stitch named colors.
  static ColorScheme colorScheme() {
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A40E0),
    );
    return base.copyWith(
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
      onSurface: const Color(0xFF32294F),
      onSurfaceVariant: const Color(0xFF5F557F),
      outline: const Color(0xFF7B719C),
      outlineVariant: const Color(0xFFB2A6D5),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF5EEFF),
      surfaceContainer: const Color(0xFFEDE4FF),
      surfaceContainerHigh: const Color(0xFFE8DEFF),
      surfaceContainerHighest: const Color(0xFFE2D7FF),
    );
  }

  /// Ambient card shadow (on-surface tint, not pure black).
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

  /// Primary CTA gradient (135° `primary` → `primary_dim` per Stitch).
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

  /// Manrope (display) + Inter (body) text themes over [parent].
  static ThemeData appTheme(ThemeData parent) {
    final scheme = colorScheme();
    final manrope = GoogleFonts.manropeTextTheme(parent.textTheme);
    final merged = GoogleFonts.interTextTheme(manrope);
    final overlay = ThemeData.from(
      colorScheme: scheme,
      textTheme: merged,
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
}

/// Spacing and radii for timetable scan widgets.
extension TimetableScanThemeX on BuildContext {
  /// Spacing tokens sourced from the shared design system theme.
  AppSpacingTheme get timetableScanSpacing =>
      Theme.of(this).extension<AppSpacingTheme>() ?? const AppSpacingTheme();

  AppRadiusTheme get _radiusTheme =>
      Theme.of(this).extension<AppRadiusTheme>() ?? const AppRadiusTheme();

  /// Large rounded blocks (hero inset, OCR / warning cards).
  BorderRadius get timetableScanLargeRadius =>
      BorderRadius.circular(_radiusTheme.l);

  /// Inset sections (chips row, nested panels).
  BorderRadius get timetableScanSectionRadius =>
      BorderRadius.circular(_radiusTheme.m);

  /// Fully rounded buttons and chips.
  BorderRadius get timetableScanPillRadius =>
      BorderRadius.circular(_radiusTheme.pill);
}
