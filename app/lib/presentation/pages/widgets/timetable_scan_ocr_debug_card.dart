import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Raw OCR text (Stitch: monospace inset panel).
class TimetableScanOcrDebugCard extends StatelessWidget {
  /// Creates the OCR debug card.
  const TimetableScanOcrDebugCard({
    required this.rawText,
    super.key,
  });

  /// Raw text returned by OCR before parsing.
  final String rawText;

  @override
  Widget build(BuildContext context) {
    final spacing = context.timetableScanSpacing;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = context.timetableScanLargeRadius;

    return Material(
      color: scheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.terminal_rounded, color: scheme.primary),
          title: Text(
            'OCR debug text',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Text(
            'Raw text before parsing',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            spacing.m,
            0,
            spacing.m,
            spacing.m,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: context.timetableScanSectionRadius,
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.m),
                child: SelectableText(
                  rawText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
