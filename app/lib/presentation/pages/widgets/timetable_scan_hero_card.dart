import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Stitch upload dropzone: nested surfaces, dual CTAs, curator explainer.
class TimetableScanHeroCard extends StatelessWidget {
  /// Creates the hero / dropzone card.
  const TimetableScanHeroCard({
    required this.statusMessage,
    required this.supportedFormatLabel,
    required this.isBusy,
    required this.onInspectOcr,
    super.key,
  });

  /// Current OCR/import status.
  final String statusMessage;

  /// Supported timetable format label.
  final String supportedFormatLabel;

  /// Whether OCR processing is running.
  final bool isBusy;

  /// Starts OCR from a gallery image.
  final Future<void> Function() onInspectOcr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.timetableScanSpacing;
    final scheme = theme.colorScheme;
    final outerRadius = BorderRadius.circular(
      TimetableScanStitchTokens.radiusLg,
    );
    final innerRadius = BorderRadius.circular(
      TimetableScanStitchTokens.radiusInset,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: outerRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
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
                  children: [
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
                    SizedBox(height: spacing.m),
                    Text(
                      'Drop your timetable here',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.25,
                        color: scheme.onSurface,
                      ),
                    ),
                    SizedBox(height: spacing.s),
                    Text(
                      'JPG, PNG, or PDF — we extract slots for your '
                      'calendar ($supportedFormatLabel on first import).',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: spacing.l),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: spacing.m,
                      runSpacing: spacing.s,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
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
                              borderRadius: BorderRadius.circular(999),
                              onTap: isBusy ? null : onInspectOcr,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.folder_open_rounded,
                                      color: scheme.onPrimary,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      isBusy ? 'Analyzing…' : 'Browse Files',
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
