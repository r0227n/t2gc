import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Parser warnings (Stitch: inline alert surface).
class TimetableScanWarningsCard extends StatelessWidget {
  /// Creates the warnings card.
  const TimetableScanWarningsCard({
    required this.warnings,
    super.key,
  });

  /// Parser and validation warnings to surface to the user.
  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    if (warnings.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final spacing = context.timetableScanSpacing;
    final scheme = theme.colorScheme;
    final radius = context.timetableScanLargeRadius;

    return Material(
      color: scheme.error.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(spacing.m, spacing.m, spacing.m, 0),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: scheme.error,
                ),
                SizedBox(width: spacing.s),
                Expanded(
                  child: Text(
                    t.timetableScan.warnings.needsReview,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(spacing.m),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.errorContainer.withValues(alpha: 0.12),
                borderRadius: context.timetableScanSectionRadius,
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < warnings.length; i++) ...[
                      if (i > 0) SizedBox(height: spacing.m),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${i + 1}.',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.error,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: spacing.s),
                          Expanded(
                            child: Text(
                              warnings[i],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
