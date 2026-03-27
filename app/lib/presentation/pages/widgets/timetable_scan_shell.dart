import 'dart:ui' show ImageFilter;

import 'package:app/core/gen/slang.g.dart';
import 'package:flutter/material.dart';

/// Stitch layout: sticky top bar, optional fixed side nav, decorative blurs.
class TimetableScanShell extends StatelessWidget {
  /// Creates the shell.
  const TimetableScanShell({
    required this.body,
    this.showSideRail = true,
  });

  /// Main scrollable content (placed beside the rail when [showSideRail]).
  final Widget body;

  /// Whether to show the desktop side navigation (hidden on narrow layouts).
  final bool showSideRail;

  static const double _topBarHeight = 64;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= 960;

    return Stack(
      children: [
        _BackgroundDecor(scheme: scheme, wide: wide),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TopBar(height: _topBarHeight),
            Expanded(child: body),
          ],
        ),
      ],
    );
  }
}

class _BackgroundDecor extends StatelessWidget {
  const _BackgroundDecor({
    required this.scheme,
    required this.wide,
  });

  final ColorScheme scheme;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -120,
            child: _BlurOrb(
              size: 500,
              color: scheme.primary.withValues(alpha: 0.05),
            ),
          ),
          if (wide)
            Positioned(
              bottom: -40,
              left: 200,
              child: _BlurOrb(
                size: 300,
                color: scheme.secondary.withValues(alpha: 0.05),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: scheme.surface,
      shadowColor: Colors.transparent,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                'Timetable to Google Calendar',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: scheme.primary,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: t.app.settingsTooltip,
                onPressed: () {},
                icon: Icon(Icons.settings_outlined, color: scheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
