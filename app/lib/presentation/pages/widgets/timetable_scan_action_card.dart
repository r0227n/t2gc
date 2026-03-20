import 'package:flutter/material.dart';

/// Action area for starting OCR from the gallery.
class TimetableScanActionCard extends StatelessWidget {
  /// Creates the action card.
  const TimetableScanActionCard({
    required this.isBusy,
    required this.onInspectOcr,
    super.key,
  });

  /// Whether OCR processing is currently running.
  final bool isBusy;

  /// Starts OCR inspection from a selected gallery image.
  final Future<void> Function() onInspectOcr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.tonalIcon(
              onPressed: isBusy ? null : onInspectOcr,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(isBusy ? 'OCR 解析中...' : '画像を選んで OCR 取込'),
            ),
            const SizedBox(width: 8),
            const Text('対応画像を選ぶと OCR 結果を表示に反映します。'),
          ],
        ),
      ),
    );
  }
}
