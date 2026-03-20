import 'dart:typed_data';

import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Stitch "Try a sample" / source preview panel.
class TimetableScanPreviewCard extends StatelessWidget {
  /// Creates the preview card.
  const TimetableScanPreviewCard({
    required this.imageBytes,
    required this.imageName,
    required this.previewDescription,
    required this.showAttachedSamplePreview,
    required this.onLoadSample,
    super.key,
  });

  /// Decoded image bytes for preview.
  final Uint8List? imageBytes;

  /// Display name of the selected image.
  final String imageName;

  /// Fallback description used when no image bytes exist.
  final String previewDescription;

  /// Whether the attached sample illustration should be displayed.
  final bool showAttachedSamplePreview;

  /// Loads the bundled timetable sample (Stitch: Load Sample).
  final Future<void> Function() onLoadSample;

  @override
  Widget build(BuildContext context) {
    final spacing = context.timetableScanSpacing;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = BorderRadius.circular(TimetableScanStitchTokens.radiusLg);
    final hasImage = imageBytes != null;

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: radius,
      child: Padding(
        padding: EdgeInsets.all(spacing.m + spacing.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Try a Sample',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            SizedBox(height: spacing.m),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                TimetableScanStitchTokens.radiusInset,
              ),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: scheme.surfaceContainerLowest,
                      child: imageBytes != null
                          ? InteractiveViewer(
                              child: Image.memory(
                                imageBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : showAttachedSamplePreview
                          ? const _AttachedSamplePreview()
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.all(spacing.m),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: scheme.outline,
                                    ),
                                    SizedBox(height: spacing.s),
                                    Text(
                                      previewDescription.isEmpty
                                          ? 'Load an image to preview it here.'
                                          : previewDescription,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    if (!hasImage && showAttachedSamplePreview)
                      Container(
                        color: scheme.primary.withValues(alpha: 0.08),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_rounded,
                              color: scheme.primary,
                              size: 28,
                            ),
                            SizedBox(height: spacing.xs),
                            Text(
                              'CLICK TO USE',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.m),
            Text(
              imageName.isEmpty
                  ? 'Test our engine with this pre-formatted schedule.'
                  : imageName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: spacing.m),
            FilledButton.tonal(
              onPressed: onLoadSample,
              style: FilledButton.styleFrom(
                backgroundColor: scheme.secondaryContainer,
                foregroundColor: scheme.onSecondaryContainer,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Load sample',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            SizedBox(height: spacing.l),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    title: 'Sync Ready',
                    value: '12',
                    caption: 'Platforms Linked',
                    valueColor: scheme.primary,
                  ),
                ),
                SizedBox(width: spacing.m),
                Expanded(
                  child: _StatTile(
                    title: 'Verified',
                    value: '100%',
                    caption: 'Data Privacy',
                    valueColor: scheme.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.title,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String title;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(TimetableScanStitchTokens.radiusLg),
        boxShadow: TimetableScanStitchTokens.ambientCardShadow(
          scheme.onSurface,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              caption,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachedSamplePreview extends StatelessWidget {
  const _AttachedSamplePreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.timetableScanSpacing;
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            scheme.primaryContainer.withValues(alpha: 0.35),
            scheme.tertiaryContainer.withValues(alpha: 0.4),
            scheme.secondaryContainer.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: spacing.s + spacing.xs,
                horizontal: spacing.m,
              ),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.94),
                borderRadius: context.timetableScanSectionRadius,
              ),
              child: Column(
                children: [
                  Text(
                    'アイドル甲子園',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    'in KANDA SQUARE HALL -DAY2-',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.s),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.s,
                      horizontal: spacing.s,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '2026.03.21 [sat] OPEN 09:00 / START 09:15',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onTertiaryContainer,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.m),
            for (final row in _previewRows)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.s),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.s,
                    horizontal: spacing.s + spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(spacing.m - spacing.xs),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        padding: EdgeInsets.symmetric(vertical: spacing.xs),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(spacing.s),
                        ),
                        child: Text(
                          row.slot,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.s + spacing.xs),
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.live,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.s + spacing.xs),
                      Expanded(
                        flex: 4,
                        child: Text(
                          row.artist,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.s + spacing.xs),
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.merch,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Text(
              '添付サンプルによる検証用プレビュー',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

final _previewRows =
    <({String slot, String live, String artist, String merch})>[
      (
        slot: '1',
        live: '09:15〜09:35',
        artist: 'COLOR of COLOR',
        merch: '09:50〜11:10',
      ),
      (
        slot: '2',
        live: '09:35〜09:55',
        artist: "Payrin's",
        merch: '10:10〜11:30',
      ),
      (
        slot: '13',
        live: '13:20〜13:40',
        artist: 'こみっきゅおん！',
        merch: '14:05〜15:25',
      ),
      (
        slot: '18',
        live: '15:05〜15:30',
        artist: 'THE ORCHESTRA TOKYO',
        merch: '15:50〜17:10',
      ),
      (
        slot: '28',
        live: '19:25〜19:50',
        artist: 'Merry BAD TUNE.',
        merch: '終演後',
      ),
    ];
