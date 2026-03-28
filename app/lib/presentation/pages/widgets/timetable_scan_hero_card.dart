import 'dart:typed_data';

import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Stitch upload dropzone: nested surfaces, dual CTAs, curator explainer.
class TimetableScanHeroCard extends StatelessWidget {
  /// Creates the hero / dropzone card.
  const TimetableScanHeroCard({
    required this.statusMessage,
    required this.isBusy,
    required this.onInspectOcr,
    required this.imageBytes,
    required this.imageName,
    required this.eventCount,
    required this.onClearImage,
    super.key,
  });

  /// Current OCR/import status.
  final String statusMessage;

  /// Whether OCR processing is running.
  final bool isBusy;

  /// Starts OCR from a gallery image.
  final Future<void> Function() onInspectOcr;

  /// Raw image bytes for the selected timetable.
  final Uint8List? imageBytes;

  /// File name for the selected timetable image.
  final String imageName;

  /// Number of parsed events when OCR has completed.
  final int? eventCount;

  /// Clears the selected image and any OCR result.
  final VoidCallback onClearImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.timetableScanSpacing;
    final scheme = theme.colorScheme;
    final outerRadius = context.timetableScanLargeRadius;
    final innerRadius = context.timetableScanSectionRadius;
    final hasImage = imageBytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: outerRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.xs),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: innerRadius,
                color: scheme.surfaceContainerLowest,
                boxShadow: TimetableScanStitchTokens.ambientCardShadow(
                  scheme.onSurface,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: spacing.xl + spacing.m,
                  horizontal: spacing.l,
                ),
                child: Column(
                  spacing: spacing.l,
                  children: [
                    if (hasImage) ...[
                      ClipRRect(
                        borderRadius: innerRadius,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 360),
                          child: ColoredBox(
                            color: scheme.surfaceContainerHigh,
                            child: Padding(
                              padding: EdgeInsets.all(spacing.s),
                              child: Image.memory(
                                imageBytes!,
                                key: const ValueKey(
                                  'timetable-scan-hero-selected-image',
                                ),
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.image_rounded,
                          color: scheme.primary,
                        ),
                        title: Text(
                          imageName.isEmpty
                              ? t.timetableScan.hero.selectedImagePreview
                              : imageName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          eventCount == 1
                              ? t.timetableScan.hero.selectedOne
                              : t.timetableScan.hero.selectedMany(
                                  count: eventCount ?? 0,
                                ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: IconButton(
                          key: const ValueKey(
                            'timetable-scan-hero-clear-image-button',
                          ),
                          tooltip:
                              t.timetableScan.hero.clearSelectedImageTooltip,
                          onPressed: onClearImage,
                          icon: Icon(
                            Icons.close_rounded,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ] else ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primaryContainer.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            Icons.cloud_upload_rounded,
                            size: 40,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        t.timetableScan.hero.dropTimetableImageHere,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.25,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: spacing.m,
                      runSpacing: spacing.s,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: context.timetableScanPillRadius,
                            gradient:
                                TimetableScanStitchTokens.primaryCtaGradient(
                                  scheme,
                                ),
                            boxShadow:
                                TimetableScanStitchTokens.ambientCardShadow(
                                  scheme.onSurface,
                                ),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              borderRadius: context.timetableScanPillRadius,
                              onTap: isBusy ? null : onInspectOcr,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing.l,
                                  vertical: spacing.m,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: spacing.s,
                                  children: [
                                    Icon(
                                      Icons.folder_open_rounded,
                                      color: scheme.onPrimary,
                                    ),
                                    Text(
                                      isBusy
                                          ? t.timetableScan.hero.analyzing
                                          : t.timetableScan.hero.browseFiles,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: scheme.onPrimary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isBusy) ...[
          SizedBox(height: spacing.s),
          ClipRRect(
            borderRadius: context.timetableScanSectionRadius,
            child: const LinearProgressIndicator(minHeight: 4),
          ),
        ],
        SizedBox(height: spacing.l),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: context.timetableScanSectionRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.m),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                SizedBox(width: spacing.s),
                Expanded(
                  child: Text(
                    statusMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
