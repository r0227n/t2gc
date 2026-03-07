import 'dart:async';
import 'dart:typed_data';

import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/domain/services/supported_timetable_parser.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';

/// Home screen for the first-launch timetable import experience.
class TimetableScanScreen extends StatefulWidget {
  /// Creates the timetable scan screen.
  const TimetableScanScreen({super.key});

  @override
  State<TimetableScanScreen> createState() => _TimetableScanScreenState();
}

class _TimetableScanScreenState extends State<TimetableScanScreen> {
  static const _supportedFormatLabel = 'アイドル甲子園 / KANDA SQUARE HALL 形式';

  final ImagePicker _picker = ImagePicker();
  final SupportedTimetableParser _ocrParser = const SupportedTimetableParser();

  NdlocrLite? _ocr;
  Uint8List? _imageBytes;
  String _imageName = '';
  String _statusMessage = '画像を選んで OCR 取込を開始してください。';
  bool _isBusy = false;
  NdlocrResult? _ocrResult;
  TimetableScanResult? _scanResult;
  Set<int> _selectedSlots = <int>{};

  @override
  void dispose() {
    unawaited(_ocr?.dispose());
    super.dispose();
  }

  Future<void> _pickImageAndInspectOcr() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = '画像選択がキャンセルされました。';
      });
      return;
    }

    final bytes = await file.readAsBytes();
    setState(() {
      _isBusy = true;
      _statusMessage = 'OCR を実行してタイムテーブルを解析しています...';
    });

    try {
      _ocr ??= await NdlocrLite.create();
      final ocrResult = await _ocr!.recognizeImageBytes(
        bytes,
        imageName: file.name,
        options: const NdlocrOptions(includeJson: true),
      );
      final parsedOcr = _ocrParser.parse(ocrResult);

      if (!mounted) {
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _imageName = file.name;
        _ocrResult = ocrResult;
        _scanResult = parsedOcr;
        _selectedSlots = parsedOcr.performances
            .map((slot) => slot.slotNumber)
            .toSet();
        _statusMessage =
            'OCR から ${parsedOcr.performances.length} 組のライブと '
            '${parsedOcr.merchandiseSlots.length} 件の物販を抽出しました。';
      });
    } on Object catch (error, stackTrace) {
      _logOcrFailure(
        imageName: file.name,
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'OCR に失敗しました: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _logOcrFailure({
    required String imageName,
    required Object error,
    required StackTrace stackTrace,
  }) {
    final message = 'OCR inspection failed for image "$imageName"';

    if (core.AppLogger.isInitialized) {
      core.AppLogger.instance.error(message, error, stackTrace);
      return;
    }

    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app.timetable_scan',
        context: ErrorDescription(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final result = _scanResult;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              colorScheme.surface,
              const Color(0xFFF8EFE5),
              const Color(0xFFE7F4EE),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1040;
              final content = <Widget>[
                _HeroCard(
                  statusMessage: _statusMessage,
                  supportedFormatLabel: _supportedFormatLabel,
                ),
                const SizedBox(height: 20),
                _ActionCard(
                  isBusy: _isBusy,
                  onInspectOcr: _pickImageAndInspectOcr,
                ),
                const SizedBox(height: 20),
              ];

              final preview = _PreviewCard(
                imageBytes: _imageBytes,
                imageName: _imageName,
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
                _PerformanceListCard(
                  scanResult: result,
                  selectedSlots: _selectedSlots,
                  onToggleSlot: (slotNumber, {required isSelected}) {
                    setState(() {
                      if (isSelected) {
                        _selectedSlots.add(slotNumber);
                      } else {
                        _selectedSlots.remove(slotNumber);
                      }
                    });
                  },
                ),
              ]);

              if (_ocrResult case final ocrResult?) {
                content.addAll(<Widget>[
                  const SizedBox(height: 20),
                  _OcrDebugCard(rawText: ocrResult.text),
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.statusMessage,
    required this.supportedFormatLabel,
  });

  final String statusMessage;
  final String supportedFormatLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFFF4647D),
            Color(0xFFE85BA6),
            Color(0xFF56C7C0),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(supportedFormatLabel),
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide.none,
            ),
            const SizedBox(height: 16),
            const Text(
              'タイムテーブルを\nGoogle Calendar 下書きへ。',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              <String>[
                '初回版は添付画像フォーマット専用です。',
                '画像から OCR を実行して抽出結果を表示し、',
                '出演者ごとにライブと物販の予定を確認できます。',
              ].join(' '),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        statusMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.isBusy,
    required this.onInspectOcr,
  });

  final bool isBusy;
  final Future<void> Function() onInspectOcr;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.imageBytes,
    required this.imageName,
  });

  final Uint8List? imageBytes;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  child: imageBytes == null
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              '画像 OCR の確認時にここへプレビューを表示します。',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : InteractiveViewer(
                          child: Image.memory(
                            imageBytes!,
                            fit: BoxFit.contain,
                            width: double.infinity,
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

class _PerformanceListCard extends StatelessWidget {
  const _PerformanceListCard({
    required this.scanResult,
    required this.selectedSlots,
    required this.onToggleSlot,
  });

  final TimetableScanResult? scanResult;
  final Set<int> selectedSlots;
  final void Function(int slotNumber, {required bool isSelected}) onToggleSlot;

  @override
  Widget build(BuildContext context) {
    final schedules =
        scanResult?.schedules ?? const <TimetableArtistSchedule>[];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ライブ / 物販タイムテーブル',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (schedules.isEmpty) const Text('タイムテーブルを検出するとここに表示します。'),
            for (final schedule in schedules)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DecoratedBox(
                  key: ValueKey('artist-schedule-${schedule.slotNumber}'),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: selectedSlots.contains(schedule.slotNumber),
                          onChanged: (value) => onToggleSlot(
                            schedule.slotNumber,
                            isSelected: value ?? false,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${schedule.slotNumber}. '
                                '${schedule.artistName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _ScheduleDetailRow(
                                icon: Icons.music_note_outlined,
                                label: 'ライブ',
                                value: schedule.performance.timeLabel,
                              ),
                              if (schedule.merchandise case final merchandise?)
                                _ScheduleDetailRow(
                                  icon: Icons.shopping_bag_outlined,
                                  label: merchandise.boothLabelText,
                                  value: merchandise.timeLabel,
                                ),
                              const SizedBox(height: 10),
                              Text(
                                'Google Calendar: '
                                '${schedule.merchandise == null ? 1 : 2} 件作成予定',
                                style: const TextStyle(
                                  color: Color(0xFF54606E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _ScheduleDetailRow extends StatelessWidget {
  const _ScheduleDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _OcrDebugCard extends StatelessWidget {
  const _OcrDebugCard({
    required this.rawText,
  });

  final String rawText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ExpansionTile(
        title: const Text('OCR デバッグテキスト'),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(rawText),
        ],
      ),
    );
  }
}
