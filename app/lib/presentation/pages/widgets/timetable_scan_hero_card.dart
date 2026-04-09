import 'dart:typed_data';

import 'package:app/core/gen/slang.g.dart';
import 'package:app/data/models/selected_timetable_image.dart';
import 'package:design_system/design_system.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

/// Stitch upload dropzone: nested surfaces, dual CTAs, curator explainer.
class TimetableScanHeroCard extends StatefulWidget {
  /// Creates the hero / dropzone card.
  const TimetableScanHeroCard({
    required this.statusMessage,
    required this.isBusy,
    required this.onInspectOcr,
    required this.onInspectDroppedImage,
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

  /// Starts OCR from a dropped image payload.
  final Future<void> Function(SelectedTimetableImage image)
  onInspectDroppedImage;

  /// Raw image bytes for the selected timetable.
  final Uint8List? imageBytes;

  /// File name for the selected timetable image.
  final String imageName;

  /// Number of parsed events when OCR has completed.
  final int? eventCount;

  /// Clears the selected image and any OCR result.
  final VoidCallback onClearImage;

  @override
  State<TimetableScanHeroCard> createState() => _TimetableScanHeroCardState();
}

class _TimetableScanHeroCardState extends State<TimetableScanHeroCard> {
  var _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.timetableScanSpacing;
    final scheme = theme.colorScheme;
    final outerRadius = context.timetableScanLargeRadius;
    final innerRadius = context.timetableScanSectionRadius;
    final hasImage = widget.imageBytes != null;
    final isDropEnabled = !widget.isBusy;
    final dropOverlayColor = scheme.primary.withValues(alpha: 0.08);
    final dropBorderColor = _isDragging ? scheme.primary : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropTarget(
          enable: isDropEnabled,
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
          onDragDone: _handleDragDone,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: outerRadius,
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.xs),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: innerRadius,
                  color: _isDragging
                      ? Color.alphaBlend(
                          dropOverlayColor,
                          scheme.surfaceContainerLowest,
                        )
                      : scheme.surfaceContainerLowest,
                  border: Border.all(
                    color: dropBorderColor,
                    width: _isDragging ? 2 : 0,
                  ),
                  boxShadow: TimetableScanTheme.ambientCardShadow(
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
                                  widget.imageBytes!,
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
                            widget.imageName.isEmpty
                                ? t.timetableScan.hero.selectedImagePreview
                                : widget.imageName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            widget.eventCount == 1
                                ? t.timetableScan.hero.selectedOne
                                : t.timetableScan.hero.selectedMany(
                                    count: widget.eventCount ?? 0,
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
                            onPressed: widget.onClearImage,
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
                              gradient: TimetableScanTheme.primaryCtaGradient(
                                scheme,
                              ),
                              boxShadow: TimetableScanTheme.ambientCardShadow(
                                scheme.onSurface,
                              ),
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                borderRadius: context.timetableScanPillRadius,
                                onTap: widget.isBusy
                                    ? null
                                    : widget.onInspectOcr,
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
                                        widget.isBusy
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
        ),
        if (widget.isBusy) ...[
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
                    widget.statusMessage,
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

  Future<void> _handleDragDone(DropDoneDetails details) async {
    setState(() {
      _isDragging = false;
    });

    if (widget.isBusy) {
      return;
    }

    final imageFile = details.files.where(_isSupportedImageFile).firstOrNull;
    if (imageFile == null) {
      return;
    }

    await widget.onInspectDroppedImage(
      SelectedTimetableImage(
        bytes: await imageFile.readAsBytes(),
        name: imageFile.name,
      ),
    );
  }

  bool _isSupportedImageFile(DropItem file) {
    final mimeType = file.mimeType;
    if (mimeType != null && mimeType.startsWith('image/')) {
      return true;
    }

    final lowerName = file.name.toLowerCase();
    return lowerName.endsWith('.png') ||
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg') ||
        lowerName.endsWith('.webp') ||
        lowerName.endsWith('.gif') ||
        lowerName.endsWith('.bmp') ||
        lowerName.endsWith('.heic') ||
        lowerName.endsWith('.heif');
  }
}
