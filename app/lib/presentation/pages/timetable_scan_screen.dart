import 'package:app/presentation/controllers/timetable_scan_controller.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_hero_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_ocr_debug_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_original_image_panel.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_performance_list_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_shell.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_warnings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen for the first-launch timetable import experience.
class TimetableScanScreen extends ConsumerWidget {
  /// Creates the timetable scan screen.
  const TimetableScanScreen({super.key});

  static const _supportedFormatLabel =
      'Idol Koushien / KANDA SQUARE HALL format';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.timetableScanSpacing;
    final scanState = ref.watch(timetableScanControllerProvider);
    final notifier = ref.read(timetableScanControllerProvider.notifier);
    final result = scanState.scanResult;

    final stitchTheme = TimetableScanStitchTokens.themeOverlay(context);

    final parsedResult = result;

    final resultsSection = <Widget>[
      TimetableScanWarningsCard(
        warnings: result?.warnings ?? const <String>[],
      ),
      if (parsedResult != null && parsedResult.hasPerformances)
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth >= 900;
            final imagePanel = TimetableScanOriginalImagePanel(
              imageBytes: scanState.imageBytes,
              eventCount: parsedResult.schedules.length,
            );
            final listCard = TimetableScanPerformanceListCard(
              scanResult: parsedResult,
              selectedSlotIndices: scanState.selectedSlotIndices,
              onToggleSlot: (index, {required isSelected}) {
                notifier.setSlotSelected(
                  index: index,
                  isSelected: isSelected,
                );
              },
              onSelectAllSlots: notifier.selectAllSlots,
              onClearAllSlots: notifier.clearAllSlots,
            );
            if (isMobile) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing.l,
                children: [
                  Expanded(flex: 4, child: imagePanel),
                  Expanded(flex: 8, child: listCard),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: spacing.l,
              children: [
                Material(
                  color: stitchTheme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(
                    TimetableScanStitchTokens.radiusLg,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Theme(
                    data: stitchTheme.copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      leading: Icon(
                        Icons.image_outlined,
                        color: stitchTheme.colorScheme.primary,
                      ),
                      title: Text(
                        'View Original Image',
                        style: stitchTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: stitchTheme.colorScheme.onSurface,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            spacing.m,
                            0,
                            spacing.m,
                            spacing.m,
                          ),
                          child: imagePanel,
                        ),
                      ],
                    ),
                  ),
                ),
                listCard,
              ],
            );
          },
        )
      else
        TimetableScanPerformanceListCard(
          scanResult: result,
          selectedSlotIndices: scanState.selectedSlotIndices,
          onToggleSlot: (index, {required isSelected}) {
            notifier.setSlotSelected(
              index: index,
              isSelected: isSelected,
            );
          },
          onSelectAllSlots: notifier.selectAllSlots,
          onClearAllSlots: notifier.clearAllSlots,
        ),
    ];

    if (scanState.scanResult?.rawText case final rawText?) {
      resultsSection.addAll(<Widget>[
        SizedBox(height: spacing.l),
        TimetableScanOcrDebugCard(rawText: rawText),
      ]);
    }

    return Theme(
      data: stitchTheme,
      child: Scaffold(
        backgroundColor: stitchTheme.colorScheme.surface,
        body: TimetableScanShell(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth >= 960;
                final horizontal = isMobile
                    ? spacing.xl + spacing.m
                    : spacing.m;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    spacing.m,
                    horizontal,
                    spacing.xl + spacing.m,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1040),
                      child: isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: spacing.l,
                              children: [
                                TimetableScanHeroCard(
                                  statusMessage: scanState.statusMessage,
                                  supportedFormatLabel: _supportedFormatLabel,
                                  isBusy: scanState.isBusy,
                                  onInspectOcr: notifier.inspectFromGallery,
                                ),
                                ...resultsSection,
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: resultsSection,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
