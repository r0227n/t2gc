import 'dart:typed_data';

import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Stitch verify screen: sticky "Original Image" column with OCR status.
class TimetableScanOriginalImagePanel extends StatelessWidget {
  /// Creates the original image panel.
  const TimetableScanOriginalImagePanel({
    required this.imageBytes,
    required this.eventCount,
    super.key,
  });

  /// Raw image bytes when available.
  final Uint8List? imageBytes;

  /// Number of parsed events (for the status line).
  final int eventCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final spacing = context.timetableScanSpacing;
    final radius = BorderRadius.circular(TimetableScanStitchTokens.radiusLg);

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: radius,
      child: Padding(
        padding: EdgeInsets.all(spacing.m + spacing.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'ORIGINAL IMAGE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.zoom_in_rounded,
                  size: 18,
                  color: scheme.primary,
                ),
              ],
            ),
            SizedBox(height: spacing.m),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                TimetableScanStitchTokens.radiusInset,
              ),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ColoredBox(
                  color: scheme.surfaceContainerHigh,
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(spacing.m),
                            child: Text(
                              'No image loaded',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: spacing.m),
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(
                  TimetableScanStitchTokens.radiusInset,
                ),
                boxShadow: TimetableScanStitchTokens.ambientCardShadow(
                  scheme.onSurface,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.m),
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'OCR Status: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Completed. $eventCount event'
                            '${eventCount == 1 ? '' : 's'} detected.',
                      ),
                    ],
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
