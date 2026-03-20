import 'package:app/data/fixtures/timetable_debug_fixture.dart';
import 'package:flutter/material.dart';

/// Debug-only validation scenarios for deterministic web verification.
class TimetableScanDebugScenariosCard extends StatelessWidget {
  /// Creates the scenario shortcut card.
  const TimetableScanDebugScenariosCard({
    required this.isBusy,
    required this.onLoadAttachedSample,
    required this.onLoadPartialMerchandiseSample,
    required this.onLoadUnsupportedFormatSample,
    required this.onSimulateOcrFailure,
    required this.onSimulateSelectionCanceled,
    super.key,
  });

  /// Whether OCR processing is currently running.
  final bool isBusy;

  /// Loads the attached timetable sample.
  final Future<void> Function() onLoadAttachedSample;

  /// Loads the partial merchandise validation sample.
  final Future<void> Function() onLoadPartialMerchandiseSample;

  /// Loads the unsupported format validation sample.
  final Future<void> Function() onLoadUnsupportedFormatSample;

  /// Simulates an OCR failure.
  final Future<void> Function() onSimulateOcrFailure;

  /// Simulates image selection cancellation.
  final void Function() onSimulateSelectionCanceled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '検証シナリオ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              '正常系と異常系をブラウザ上で再現できる固定シナリオです。',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ScenarioButton(
                  key: const ValueKey('scenario-attached-sample'),
                  label: TimetableDebugFixture.buttonLabel(
                    TimetableDebugScenario.attachedSample,
                  ),
                  icon: Icons.image_search_outlined,
                  isBusy: isBusy,
                  onPressed: onLoadAttachedSample,
                ),
                _ScenarioButton(
                  key: const ValueKey('scenario-partial-merchandise'),
                  label: TimetableDebugFixture.buttonLabel(
                    TimetableDebugScenario.partialMerchandise,
                  ),
                  icon: Icons.warning_amber_outlined,
                  isBusy: isBusy,
                  onPressed: onLoadPartialMerchandiseSample,
                ),
                _ScenarioButton(
                  key: const ValueKey('scenario-unsupported-format'),
                  label: TimetableDebugFixture.buttonLabel(
                    TimetableDebugScenario.unsupportedFormat,
                  ),
                  icon: Icons.find_in_page_outlined,
                  isBusy: isBusy,
                  onPressed: onLoadUnsupportedFormatSample,
                ),
                _ScenarioButton(
                  key: const ValueKey('scenario-ocr-failure'),
                  label: TimetableDebugFixture.buttonLabel(
                    TimetableDebugScenario.ocrFailure,
                  ),
                  icon: Icons.error_outline,
                  isBusy: isBusy,
                  onPressed: onSimulateOcrFailure,
                ),
                OutlinedButton.icon(
                  key: const ValueKey('scenario-selection-canceled'),
                  onPressed: isBusy ? null : onSimulateSelectionCanceled,
                  icon: const Icon(Icons.block_outlined),
                  label: Text(
                    TimetableDebugFixture.buttonLabel(
                      TimetableDebugScenario.canceledSelection,
                    ),
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

class _ScenarioButton extends StatelessWidget {
  const _ScenarioButton({
    required this.label,
    required this.icon,
    required this.isBusy,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isBusy;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
