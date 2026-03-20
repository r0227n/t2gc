import 'package:app/presentation/controllers/timetable_scan_controller.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_action_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_debug_scenarios_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_hero_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_ocr_debug_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_performance_list_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_preview_card.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_warnings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home screen for the first-launch timetable import experience.
class TimetableScanScreen extends ConsumerWidget {
  /// Creates the timetable scan screen.
  const TimetableScanScreen({super.key});

  static const _supportedFormatLabel = 'アイドル甲子園 / KANDA SQUARE HALL 形式';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final scanState = ref.watch(timetableScanControllerProvider);
    final notifier = ref.read(timetableScanControllerProvider.notifier);
    final result = scanState.scanResult;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? <Color>[
            colorScheme.surface,
            colorScheme.surfaceContainerHigh,
            colorScheme.surfaceContainer,
          ]
        : <Color>[
            colorScheme.surface,
            colorScheme.surfaceContainerLow.withValues(
              alpha: 0.6,
            ),
            colorScheme.primaryContainer.withValues(alpha: 0.15),
          ];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1040;
              final content = <Widget>[
                TimetableScanHeroCard(
                  statusMessage: scanState.statusMessage,
                  supportedFormatLabel: _supportedFormatLabel,
                ),
                const SizedBox(height: 20),
                TimetableScanActionCard(
                  isBusy: scanState.isBusy,
                  onInspectOcr: notifier.inspectFromGallery,
                ),
                const SizedBox(height: 20),
                TimetableScanDebugScenariosCard(
                  isBusy: scanState.isBusy,
                  onLoadAttachedSample: notifier.loadAttachedSample,
                  onLoadPartialMerchandiseSample:
                      notifier.loadPartialMerchandiseSample,
                  onLoadUnsupportedFormatSample:
                      notifier.loadUnsupportedFormatSample,
                  onSimulateOcrFailure: notifier.simulateOcrFailure,
                  onSimulateSelectionCanceled:
                      notifier.simulateSelectionCanceled,
                ),
                const SizedBox(height: 20),
              ];

              final preview = TimetableScanPreviewCard(
                imageBytes: scanState.imageBytes,
                imageName: scanState.imageName,
                previewDescription: scanState.previewDescription,
                showAttachedSamplePreview: scanState.showAttachedSamplePreview,
              );

              if (isWide) {
                content.add(
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: preview),
                    ],
                  ),
                );
              } else {
                content.add(preview);
              }

              content.addAll([
                const SizedBox(height: 20),
                TimetableScanWarningsCard(
                  warnings: result?.warnings ?? const <String>[],
                ),
                const SizedBox(height: 20),
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
              ]);

              if (scanState.scanResult?.rawText case final rawText?) {
                content.addAll(<Widget>[
                  const SizedBox(height: 20),
                  TimetableScanOcrDebugCard(rawText: rawText),
                ]);
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: content,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
