import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Preview card showing the OCR source image.
class TimetableScanPreviewCard extends StatelessWidget {
  /// Creates the preview card.
  const TimetableScanPreviewCard({
    required this.imageBytes,
    required this.imageName,
    required this.previewDescription,
    required this.showAttachedSamplePreview,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '対応画像プレビュー',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              imageName.isEmpty
                  ? '対応画像を読み込むと、OCR 解析に使った画像をここへ表示します。'
                  : imageName,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFF6ECF0),
                      Color(0xFFE5F5EF),
                    ],
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: imageBytes != null
                      ? InteractiveViewer(
                          child: Image.memory(
                            imageBytes!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        )
                      : showAttachedSamplePreview
                      ? const _AttachedSamplePreview()
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              previewDescription.isEmpty
                                  ? '画像 OCR の確認時にここへプレビューを表示します。'
                                  : previewDescription,
                              textAlign: TextAlign.center,
                            ),
                          ),
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

class _AttachedSamplePreview extends StatelessWidget {
  const _AttachedSamplePreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF6D8D1),
            Color(0xFFCDE6E6),
            Color(0xFFD9F0E1),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    'アイドル甲子園',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFE9567A),
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'in KANDA SQUARE HALL -DAY2-',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE95DE0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '2026.03.21 [sat] OPEN 09:00 / START 09:15',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            for (final row in _previewRows)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFADB5BD)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE95DE0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          row.slot,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.live,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Text(
                          row.artist,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.merch,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Text(
              '添付画像の内容をもとにした検証用プレビュー',
              style: theme.textTheme.bodySmall,
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
