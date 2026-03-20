import 'package:app/data/models/selected_timetable_image.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Action area for starting OCR from the gallery.
class TimetableScanActionCard extends StatefulWidget {
  /// Creates the action card.
  const TimetableScanActionCard({
    required this.isBusy,
    required this.onInspectOcr,
    required this.onInspectDroppedImage,
    super.key,
  });

  /// Whether OCR processing is currently running.
  final bool isBusy;

  /// Starts OCR inspection from a selected gallery image.
  final Future<void> Function() onInspectOcr;

  /// Starts OCR inspection from a dropped image.
  final Future<void> Function(SelectedTimetableImage image)
  onInspectDroppedImage;

  @override
  State<TimetableScanActionCard> createState() =>
      _TimetableScanActionCardState();
}

class _TimetableScanActionCardState extends State<TimetableScanActionCard> {
  var _isDragging = false;

  bool get _supportsDragAndDrop {
    if (kIsWeb) {
      return true;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.android => false,
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux => true,
      TargetPlatform.fuchsia => false,
    };
  }

  Future<void> _handleDrop(DropDoneDetails details) async {
    if (widget.isBusy) {
      return;
    }

    final droppedImage = await _firstDroppedImage(details.files);
    if (!mounted) {
      return;
    }

    setState(() {
      _isDragging = false;
    });

    if (droppedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('画像ファイルをドロップしてください。')),
      );
      return;
    }

    await widget.onInspectDroppedImage(droppedImage);
  }

  Future<SelectedTimetableImage?> _firstDroppedImage(
    List<DropItem> items,
  ) async {
    for (final item in items) {
      if (_isImageFile(item)) {
        return SelectedTimetableImage(
          bytes: await item.readAsBytes(),
          name: item.name,
        );
      }
    }

    return null;
  }

  bool _isImageFile(DropItem item) {
    final mimeType = item.mimeType;
    if (mimeType != null && mimeType.startsWith('image/')) {
      return true;
    }

    final lowerName = item.name.toLowerCase();
    return lowerName.endsWith('.png') ||
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg') ||
        lowerName.endsWith('.webp') ||
        lowerName.endsWith('.gif') ||
        lowerName.endsWith('.bmp') ||
        lowerName.endsWith('.heic');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  onPressed: widget.isBusy ? null : widget.onInspectOcr,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(widget.isBusy ? 'OCR 解析中...' : '画像を選んで OCR 取込'),
                ),
                const SizedBox(width: 8),
                const Text('対応画像を選ぶと OCR 結果を表示に反映します。'),
              ],
            ),
            if (_supportsDragAndDrop) ...[
              const SizedBox(height: 16),
              DropTarget(
                onDragEntered: (_) {
                  setState(() {
                    _isDragging = true;
                  });
                },
                onDragExited: (_) {
                  setState(() {
                    _isDragging = false;
                  });
                },
                onDragDone: _handleDrop,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isDragging
                        ? colorScheme.primaryContainer.withValues(alpha: 0.7)
                        : colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.45,
                          ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isDragging
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: _isDragging ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isDragging
                            ? Icons.file_download_done_outlined
                            : Icons.upload_file_outlined,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ここに画像をドラッグ&ドロップ',
                              key: const ValueKey('drag-drop-label'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isBusy
                                  ? 'OCR 実行中は新しい画像を追加できません。'
                                  : 'PNG / JPG などの画像をそのまま追加できます。',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
