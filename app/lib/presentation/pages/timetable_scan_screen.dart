import 'package:app/presentation/controllers/timetable_scan_controller.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_hero_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_ocr_debug_card.dart';
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
        TimetableScanPerformanceListCard(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: spacing.l,
                        children: [
                          TimetableScanHeroCard(
                            statusMessage: scanState.statusMessage,
                            isBusy: scanState.isBusy,
                            onInspectOcr: notifier.inspectFromGallery,
                            onClearImage: notifier.clearSelection,
                            imageBytes: scanState.imageBytes,
                            imageName: scanState.imageName,
                            eventCount: parsedResult?.schedules.length,
                          ),
                          ...resultsSection,
                        ],
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
