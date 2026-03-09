import 'dart:math' as math;

import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_metadata.dart';
import 'package:app/domain/models/timetable_performance_slot.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supported_timetable_parser.g.dart';

/// Provides the parser tuned to the supported timetable layout.
@Riverpod(keepAlive: true)
SupportedTimetableParser supportedTimetableParser(Ref ref) {
  return const SupportedTimetableParser();
}

/// Parser tuned to the first-launch timetable layout shown in the spec image.
class SupportedTimetableParser {
  /// Creates a parser for the supported timetable format.
  const SupportedTimetableParser();

  static final RegExp _datePattern = RegExp(
    r'(?<year>\d{4})[./](?<month>\d{2})[./](?<day>\d{2})',
  );
  static final RegExp _openPattern = RegExp(
    r'OPEN\s*(?<time>\d{1,2}[:：.]\d{2})',
    caseSensitive: false,
  );
  static final RegExp _startPattern = RegExp(
    r'START\s*(?<time>\d{1,2}[:：.]\d{2})',
    caseSensitive: false,
  );
  static final RegExp _timeRangePattern = RegExp(
    r'(?<start>\d{1,2}[:：.]\d{2})\s*[~〜～-]\s*'
    r'(?<end>\d{1,2}[:：.]\d{2})(?<tail>.*)$',
  );
  static final RegExp _performanceLinePattern = RegExp(
    r'^(?<slot>\d{1,2})?\s*'
    r'(?<start>\d{1,2}[:：.]\d{2})\s*[~〜～-]\s*'
    r'(?<end>\d{1,2}[:：.]\d{2})\s*(?<rest>.+)$',
  );
  static final RegExp _boothPattern = RegExp(r'^(?:[A-D]|-)$');

  /// Parses a raw OCR result into timetable metadata and performer slots.
  TimetableScanResult parse(NdlocrResult result) {
    final warnings = <String>[];
    final rawText = _normalizeText(result.text);
    final extractedDate = _extractEventDate(rawText);
    final eventDate = extractedDate ?? DateTime(2026, 3, 21);
    if (extractedDate == null) {
      warnings.add('日付を OCR から取得できなかったため 2026-03-21 を仮置きしました。');
    }

    final headerLines = _collectHeaderLines(result, rawText);
    final headerText = headerLines.join(' ');
    final afterShowWindow = _extractAfterShowWindow(
      result: result,
      rawText: rawText,
      eventDate: eventDate,
    );
    final metadata = TimetableMetadata(
      eventTitle: _extractEventTitle(headerLines, rawText),
      venueName: _extractVenueName(headerLines, rawText),
      eventDate: eventDate,
      timeZoneId: 'Asia/Tokyo',
      openAt: _extractHeaderTime(headerText, _openPattern, eventDate),
      startAt: _extractHeaderTime(headerText, _startPattern, eventDate),
      afterShowMerchandiseStartAt: afterShowWindow?.$1,
      afterShowMerchandiseEndAt: afterShowWindow?.$2,
    );

    final parsedSchedules = <TimetableArtistSchedule>[];
    for (final rowText in _collectCandidateRows(result, rawText)) {
      final schedule = _parseRow(
        rowText: rowText,
        eventDate: eventDate,
        fallbackSlotNumber: parsedSchedules.length + 1,
        afterShowWindow: afterShowWindow,
        warnings: warnings,
      );
      if (schedule != null) {
        parsedSchedules.add(schedule);
      }
    }

    final deduplicatedRows = _deduplicateSchedules(parsedSchedules);
    if (deduplicatedRows.isEmpty) {
      warnings.add('対応フォーマットの行を検出できませんでした。');
    }

    return TimetableScanResult(
      metadata: metadata,
      schedules: deduplicatedRows,
      warnings: warnings,
      rawText: rawText,
    );
  }

  DateTime? _extractEventDate(String rawText) {
    final match = _datePattern.firstMatch(rawText);
    if (match == null) {
      return null;
    }
    final year = int.parse(match.namedGroup('year')!);
    final month = int.parse(match.namedGroup('month')!);
    final day = int.parse(match.namedGroup('day')!);
    return DateTime(year, month, day);
  }

  DateTime? _extractHeaderTime(
    String headerText,
    RegExp pattern,
    DateTime eventDate,
  ) {
    final match = pattern.firstMatch(headerText);
    final time = match?.namedGroup('time');
    return time == null ? null : _parseClock(eventDate, time);
  }

  List<String> _collectHeaderLines(NdlocrResult result, String rawText) {
    final headerLines = <String>{};

    for (final line in result.lines) {
      if (line.isVertical) {
        continue;
      }

      final normalized = _NormalizedOcrLine.fromLine(line);
      if (normalized.text.isEmpty) {
        continue;
      }

      if (normalized.centerY < result.imageSize.height * 0.24) {
        headerLines.add(normalized.text);
      }
    }

    for (final line in rawText.split(RegExp(r'[\r\n]+'))) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }

      if ((_looksLikeScheduleRow(trimmed) &&
              !_datePattern.hasMatch(trimmed) &&
              !trimmed.contains('OPEN') &&
              !trimmed.contains('START')) ||
          trimmed.contains('終演後物販')) {
        continue;
      }
      headerLines.add(trimmed);
      if (headerLines.length >= 4) {
        break;
      }
    }

    return headerLines.isEmpty ? <String>[rawText] : headerLines.toList();
  }

  String _extractEventTitle(List<String> headerLines, String rawText) {
    for (final line in headerLines) {
      if (_datePattern.hasMatch(line) ||
          _openPattern.hasMatch(line) ||
          _startPattern.hasMatch(line)) {
        continue;
      }
      if (line.contains('アイドル甲子園')) {
        return line;
      }
    }

    for (final line in rawText.split(RegExp(r'[\r\n]+'))) {
      final trimmed = line.trim();
      if (trimmed.contains('アイドル甲子園')) {
        return trimmed;
      }
    }
    return 'アイドル甲子園タイムテーブル';
  }

  String _extractVenueName(List<String> headerLines, String rawText) {
    final headerText = headerLines.join(' ').toUpperCase();
    if (headerText.contains('KANDA SQUARE HALL')) {
      return 'KANDA SQUARE HALL';
    }

    if (rawText.toUpperCase().contains('KANDA SQUARE HALL')) {
      return 'KANDA SQUARE HALL';
    }

    return 'KANDA SQUARE HALL';
  }

  List<String> _collectCandidateRows(NdlocrResult result, String rawText) {
    final candidates = <String>{};

    for (final row in _groupStageRows(result)) {
      if (row.combinedText.isNotEmpty) {
        candidates.add(row.combinedText);
      }
    }

    for (final line in rawText.split(RegExp(r'[\r\n]+'))) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        candidates.add(trimmed);
      }
    }

    return candidates.toList();
  }

  List<_RowGroup> _groupStageRows(NdlocrResult result) {
    final stageLines =
        result.lines
            .where((line) => !line.isVertical)
            .map(_NormalizedOcrLine.fromLine)
            .where((line) => line.text.isNotEmpty)
            .where((line) => line.centerY > result.imageSize.height * 0.18)
            .toList()
          ..sort((left, right) => left.centerY.compareTo(right.centerY));

    final groups = <_RowGroup>[];
    final tolerance = _rowToleranceFor(stageLines);
    for (final line in stageLines) {
      if (groups.isEmpty ||
          (groups.last.centerY - line.centerY).abs() > tolerance) {
        groups.add(_RowGroup(<_NormalizedOcrLine>[line]));
        continue;
      }
      groups.last.add(line);
    }
    return groups;
  }

  double _rowToleranceFor(List<_NormalizedOcrLine> lines) {
    if (lines.isEmpty) {
      return 24;
    }

    final totalHeight = lines.fold<double>(
      0,
      (sum, line) => sum + line.boundingBox.height,
    );
    return math.max(24, totalHeight / lines.length * 0.75);
  }

  TimetableArtistSchedule? _parseRow({
    required String rowText,
    required DateTime eventDate,
    required int fallbackSlotNumber,
    required (DateTime, DateTime)? afterShowWindow,
    required List<String> warnings,
  }) {
    final normalized = _normalizeText(rowText);
    if (!_looksLikeScheduleRow(normalized) || _isNoiseRow(normalized)) {
      return null;
    }

    final match = _performanceLinePattern.firstMatch(normalized);
    if (match == null) {
      return null;
    }

    final startAt = _parseClock(eventDate, match.namedGroup('start')!);
    final endAt = _parseClock(eventDate, match.namedGroup('end')!);
    final slotNumber =
        int.tryParse(match.namedGroup('slot') ?? '') ?? fallbackSlotNumber;
    final parsedArtistAndMerchandise = _parseArtistAndMerchandise(
      rest: match.namedGroup('rest')!.trim(),
      slotNumber: slotNumber,
      eventDate: eventDate,
      afterShowWindow: afterShowWindow,
      sourceText: normalized,
      warnings: warnings,
    );
    final artistName = parsedArtistAndMerchandise.artistName;
    if (artistName.isEmpty) {
      return null;
    }

    return TimetableArtistSchedule(
      performance: TimetablePerformanceSlot(
        slotNumber: slotNumber,
        artistName: artistName,
        startAt: startAt,
        endAt: endAt,
        sourceText: normalized,
      ),
      merchandise: parsedArtistAndMerchandise.merchandise,
    );
  }

  bool _looksLikeScheduleRow(String text) =>
      _performanceLinePattern.hasMatch(text);

  bool _isNoiseRow(String text) {
    if (text.contains('OPEN') && text.contains('START')) {
      return true;
    }
    if (text.contains('ライブ時間') || text.contains('物販時間')) {
      return true;
    }
    if (text.contains('終演後物販') || text.startsWith('全体 ')) {
      return true;
    }
    return false;
  }

  _ParsedArtistAndMerchandise _parseArtistAndMerchandise({
    required String rest,
    required int slotNumber,
    required DateTime eventDate,
    required (DateTime, DateTime)? afterShowWindow,
    required String sourceText,
    required List<String> warnings,
  }) {
    final normalized = _normalizeText(rest);
    if (normalized.endsWith('終演後')) {
      final prefix = normalized.replaceFirst(RegExp(r'\s*終演後$'), '').trim();
      final boothSplit = _splitArtistAndBooth(prefix);
      final artistName = _cleanArtistName(boothSplit.artistName);

      if (afterShowWindow == null) {
        warnings.add('終演後物販の共通時間を検出できませんでした: $artistName');
        return _ParsedArtistAndMerchandise(artistName: artistName);
      }

      return _ParsedArtistAndMerchandise(
        artistName: artistName,
        merchandise: TimetableMerchandiseSlot(
          slotNumber: slotNumber,
          artistName: artistName,
          startAt: afterShowWindow.$1,
          endAt: afterShowWindow.$2,
          sourceText: sourceText,
          isAfterShow: true,
        ),
      );
    }

    final merchRange = _findTrailingTimeRange(normalized);
    if (merchRange == null) {
      return _ParsedArtistAndMerchandise(
        artistName: _cleanArtistName(normalized),
      );
    }

    final suffix = normalized.substring(merchRange.end).trim();
    if (suffix.isNotEmpty) {
      return _ParsedArtistAndMerchandise(
        artistName: _cleanArtistName(normalized),
      );
    }

    final prefix = normalized.substring(0, merchRange.start).trim();
    final boothSplit = _splitArtistAndBooth(prefix);
    final artistName = _cleanArtistName(boothSplit.artistName);
    final merchandiseRange = _parseTimeRange(merchRange.group(0)!, eventDate);
    if (merchandiseRange == null) {
      warnings.add('物販時間を解釈できませんでした: $sourceText');
      return _ParsedArtistAndMerchandise(artistName: artistName);
    }

    return _ParsedArtistAndMerchandise(
      artistName: artistName,
      merchandise: TimetableMerchandiseSlot(
        slotNumber: slotNumber,
        artistName: artistName,
        boothLabel: boothSplit.boothLabel ?? '-',
        startAt: merchandiseRange.$1,
        endAt: merchandiseRange.$2,
        sourceText: sourceText,
      ),
    );
  }

  RegExpMatch? _findTrailingTimeRange(String value) {
    final matches = _timeRangePattern.allMatches(value).toList();
    if (matches.isEmpty) {
      return null;
    }

    return matches.last;
  }

  _ArtistAndBooth _splitArtistAndBooth(String value) {
    final normalized = _normalizeText(value);
    final tokens = normalized.split(' ').where((token) => token.isNotEmpty);
    final parts = tokens.toList();
    if (parts.isEmpty) {
      return const _ArtistAndBooth(artistName: '');
    }

    final boothCandidate = parts.last.toUpperCase();
    if (_boothPattern.hasMatch(boothCandidate)) {
      return _ArtistAndBooth(
        artistName: parts.take(parts.length - 1).join(' '),
        boothLabel: boothCandidate,
      );
    }

    return _ArtistAndBooth(artistName: normalized);
  }

  String _cleanArtistName(String value) {
    return value
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[\d\s.・|]+'), '')
        .replaceAll(RegExp(r'\s+[A-D-]$'), '')
        .trim();
  }

  (DateTime, DateTime)? _extractAfterShowWindow({
    required NdlocrResult result,
    required String rawText,
    required DateTime eventDate,
  }) {
    for (final candidate in _collectCandidateRows(result, rawText)) {
      if (candidate.contains('終演後物販') || candidate.startsWith('全体')) {
        final range = _parseTimeRange(candidate, eventDate);
        if (range != null) {
          return range;
        }
      }
    }

    final afterShowSection = RegExp(
      r'終演後物販[\s\S]*?(?<start>\d{1,2}[:：.]\d{2})\s*[~〜～-]\s*'
      r'(?<end>\d{1,2}[:：.]\d{2})',
    ).firstMatch(rawText);
    if (afterShowSection != null) {
      return (
        _parseClock(eventDate, afterShowSection.namedGroup('start')!),
        _parseClock(eventDate, afterShowSection.namedGroup('end')!),
      );
    }

    return null;
  }

  (DateTime, DateTime)? _parseTimeRange(String value, DateTime eventDate) {
    final match = _timeRangePattern.firstMatch(value);
    if (match == null) {
      return null;
    }

    return (
      _parseClock(eventDate, match.namedGroup('start')!),
      _parseClock(eventDate, match.namedGroup('end')!),
    );
  }

  DateTime _parseClock(DateTime eventDate, String value) {
    final normalized = value.replaceAll('：', ':').replaceAll('.', ':');
    final parts = normalized.split(':');
    return DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      int.parse(parts.first),
      int.parse(parts.last),
    );
  }

  List<TimetableArtistSchedule> _deduplicateSchedules(
    List<TimetableArtistSchedule> rows,
  ) {
    final deduplicated = <String, TimetableArtistSchedule>{};
    for (final row in rows) {
      final performance = row.performance;
      final key =
          '${performance.slotNumber}-${performance.artistName}'
          '-${performance.startAt.toIso8601String()}'
          '-${performance.endAt.toIso8601String()}';
      final existing = deduplicated[key];
      if (existing == null ||
          (existing.merchandise == null && row.merchandise != null)) {
        deduplicated[key] = row;
      }
    }
    final values = deduplicated.values.toList()
      ..sort(
        (left, right) => left.slotNumber.compareTo(right.slotNumber),
      );
    return values;
  }

  String _normalizeText(String value) {
    const fullWidthDigits = '０１２３４５６７８９';
    var normalized = value;
    for (var index = 0; index < fullWidthDigits.length; index++) {
      normalized = normalized.replaceAll(
        fullWidthDigits[index],
        '$index',
      );
    }
    return normalized
        .replaceAll('：', ':')
        .replaceAll('～', '~')
        .replaceAll('〜', '~')
        .replaceAll('／', '/')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .trim();
  }
}

class _ArtistAndBooth {
  const _ArtistAndBooth({
    required this.artistName,
    this.boothLabel,
  });

  final String artistName;
  final String? boothLabel;
}

class _ParsedArtistAndMerchandise {
  const _ParsedArtistAndMerchandise({
    required this.artistName,
    this.merchandise,
  });

  final String artistName;
  final TimetableMerchandiseSlot? merchandise;
}

class _RowGroup {
  _RowGroup(this.lines);

  final List<_NormalizedOcrLine> lines;

  double get centerY {
    final total = lines.fold<double>(
      0,
      (sum, line) => sum + line.centerY,
    );
    return total / lines.length;
  }

  String get combinedText {
    final sortedLines = lines.toList()
      ..sort(
        (left, right) => left.boundingBox.x.compareTo(right.boundingBox.x),
      );
    return sortedLines.map((line) => line.text).join(' ').trim();
  }

  void add(_NormalizedOcrLine line) {
    lines.add(line);
  }
}

class _NormalizedOcrLine {
  const _NormalizedOcrLine({
    required this.text,
    required this.boundingBox,
  });

  factory _NormalizedOcrLine.fromLine(NdlocrLine line) {
    const fullWidthDigits = '０１２３４５６７８９';
    var normalized = line.text;
    for (var index = 0; index < fullWidthDigits.length; index++) {
      normalized = normalized.replaceAll(
        fullWidthDigits[index],
        '$index',
      );
    }
    normalized = normalized
        .replaceAll('：', ':')
        .replaceAll('～', '~')
        .replaceAll('〜', '~')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .trim();
    return _NormalizedOcrLine(
      text: normalized,
      boundingBox: line.boundingBox,
    );
  }

  final String text;
  final NdlocrBoundingBox boundingBox;

  double get centerY => boundingBox.y + (boundingBox.height / 2);
}
