import 'package:app/domain/timetable/models/timetable_scan_result.dart';

/// Parser for the markdown timetable used by the first-launch flow.
class SupportedTimetableMarkdownParser {
  /// Creates a markdown timetable parser.
  const SupportedTimetableMarkdownParser();

  static final RegExp _datePattern = RegExp(
    r'(?<year>\d{4})[./](?<month>\d{2})[./](?<day>\d{2})',
  );
  static final RegExp _timeRangePattern = RegExp(
    r'(?<start>\d{1,2}[:：.]\d{2})\s*[~〜～-]\s*'
    r'(?<end>\d{1,2}[:：.]\d{2})',
  );

  /// Parses supported markdown into timetable metadata and artist schedules.
  TimetableScanResult parse(String markdown) {
    final warnings = <String>[];
    final title = _extractTitle(markdown);
    final tables = _extractTables(markdown);

    if (tables.length < 3) {
      return TimetableScanResult(
        metadata: TimetableMetadata(
          eventTitle: title,
          venueName: 'KANDA SQUARE HALL',
          eventDate: DateTime(2026, 3, 21),
          timeZoneId: 'Asia/Tokyo',
        ),
        schedules: const <TimetableArtistSchedule>[],
        warnings: const <String>['対応フォーマットのMarkdownテーブルを検出できませんでした。'],
        rawText: markdown,
      );
    }

    final header = _parseKeyValueRows(tables[0]);
    final eventDate = _extractEventDate(header['日程']) ?? DateTime(2026, 3, 21);
    if (_extractEventDate(header['日程']) == null) {
      warnings.add('日程を取得できなかったため 2026-03-21 を仮置きしました。');
    }

    final afterShowWindow = _parseAfterShowWindow(
      tableRows: tables[2],
      eventDate: eventDate,
      warnings: warnings,
    );
    final schedules = _parseSchedules(
      tableRows: tables[1],
      eventDate: eventDate,
      afterShowWindow: afterShowWindow,
      warnings: warnings,
    );

    return TimetableScanResult(
      metadata: TimetableMetadata(
        eventTitle: title,
        venueName: header['会場'] ?? 'KANDA SQUARE HALL',
        eventDate: eventDate,
        timeZoneId: 'Asia/Tokyo',
        openAt: _parseClockLabel(header['OPEN'], eventDate),
        startAt: _parseClockLabel(header['START'], eventDate),
        afterShowMerchandiseStartAt: afterShowWindow?.$1,
        afterShowMerchandiseEndAt: afterShowWindow?.$2,
      ),
      schedules: schedules,
      warnings: warnings,
      rawText: markdown,
    );
  }

  String _extractTitle(String markdown) {
    for (final line in markdown.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('# ')) {
        return trimmed.replaceFirst('# ', '').trim();
      }
    }
    return 'アイドル甲子園タイムテーブル';
  }

  List<List<List<String>>> _extractTables(String markdown) {
    final tables = <List<List<String>>>[];
    var currentRows = <List<String>>[];

    for (final line in markdown.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        final cells = _splitRow(trimmed);
        if (_isSeparatorRow(cells)) {
          continue;
        }
        currentRows.add(cells);
        continue;
      }

      if (currentRows.isNotEmpty) {
        tables.add(currentRows);
        currentRows = <List<String>>[];
      }
    }

    if (currentRows.isNotEmpty) {
      tables.add(currentRows);
    }

    return tables;
  }

  List<String> _splitRow(String row) {
    final content = row.substring(1, row.length - 1);
    return content.split('|').map((cell) => cell.trim()).toList();
  }

  bool _isSeparatorRow(List<String> cells) {
    final pattern = RegExp(r'^:?-{3,}:?$');
    return cells.every(pattern.hasMatch);
  }

  Map<String, String> _parseKeyValueRows(List<List<String>> rows) {
    final entries = <String, String>{};
    for (final row in rows.skip(1)) {
      if (row.length < 2) {
        continue;
      }
      entries[row[0]] = row[1];
    }
    return entries;
  }

  DateTime? _extractEventDate(String? value) {
    final match = _datePattern.firstMatch(value ?? '');
    if (match == null) {
      return null;
    }

    return DateTime(
      int.parse(match.namedGroup('year')!),
      int.parse(match.namedGroup('month')!),
      int.parse(match.namedGroup('day')!),
    );
  }

  DateTime? _parseClockLabel(String? value, DateTime eventDate) {
    if (value == null) {
      return null;
    }

    final normalized = value.replaceAll('：', ':').replaceAll('.', ':').trim();
    final parts = normalized.split(':');
    if (parts.length != 2) {
      return null;
    }

    return DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  (DateTime, DateTime)? _parseAfterShowWindow({
    required List<List<String>> tableRows,
    required DateTime eventDate,
    required List<String> warnings,
  }) {
    for (final row in tableRows.skip(1)) {
      if (row.length < 2) {
        continue;
      }
      final range = _parseTimeRange(row[1], eventDate);
      if (range != null) {
        return range;
      }
    }

    warnings.add('終演後物販の時間を検出できませんでした。');
    return null;
  }

  List<TimetableArtistSchedule> _parseSchedules({
    required List<List<String>> tableRows,
    required DateTime eventDate,
    required (DateTime, DateTime)? afterShowWindow,
    required List<String> warnings,
  }) {
    final schedules = <TimetableArtistSchedule>[];

    for (final row in tableRows.skip(1)) {
      if (row.length < 5) {
        continue;
      }

      final slotNumber = int.tryParse(row[0]);
      final liveRange = _parseTimeRange(row[1], eventDate);
      if (slotNumber == null || liveRange == null) {
        warnings.add('ライブ行を解釈できませんでした: ${row.join(' | ')}');
        continue;
      }

      final artistName = row[2];
      final merchandiseText = row[4];
      final merchandiseSlot = switch (merchandiseText) {
        '終演後' => _buildAfterShowMerchandise(
          slotNumber: slotNumber,
          artistName: artistName,
          afterShowWindow: afterShowWindow,
          warnings: warnings,
        ),
        _ => _buildRegularMerchandise(
          slotNumber: slotNumber,
          artistName: artistName,
          boothLabel: row[3],
          merchandiseText: merchandiseText,
          eventDate: eventDate,
          warnings: warnings,
        ),
      };

      schedules.add(
        TimetableArtistSchedule(
          performance: TimetablePerformanceSlot(
            slotNumber: slotNumber,
            artistName: artistName,
            startAt: liveRange.$1,
            endAt: liveRange.$2,
            sourceText: row.join(' | '),
          ),
          merchandise: merchandiseSlot,
        ),
      );
    }

    return schedules;
  }

  TimetableMerchandiseSlot? _buildRegularMerchandise({
    required int slotNumber,
    required String artistName,
    required String boothLabel,
    required String merchandiseText,
    required DateTime eventDate,
    required List<String> warnings,
  }) {
    final range = _parseTimeRange(merchandiseText, eventDate);
    if (range == null) {
      warnings.add('物販時間を解釈できませんでした: $artistName / $merchandiseText');
      return null;
    }

    return TimetableMerchandiseSlot(
      slotNumber: slotNumber,
      artistName: artistName,
      boothLabel: boothLabel,
      startAt: range.$1,
      endAt: range.$2,
      sourceText: merchandiseText,
    );
  }

  TimetableMerchandiseSlot? _buildAfterShowMerchandise({
    required int slotNumber,
    required String artistName,
    required (DateTime, DateTime)? afterShowWindow,
    required List<String> warnings,
  }) {
    if (afterShowWindow == null) {
      warnings.add('終演後物販の共通時間がないため $artistName を生成できませんでした。');
      return null;
    }

    return TimetableMerchandiseSlot(
      slotNumber: slotNumber,
      artistName: artistName,
      startAt: afterShowWindow.$1,
      endAt: afterShowWindow.$2,
      sourceText: '終演後',
      isAfterShow: true,
    );
  }

  (DateTime, DateTime)? _parseTimeRange(String value, DateTime eventDate) {
    final match = _timeRangePattern.firstMatch(value);
    if (match == null) {
      return null;
    }

    return (
      _parseClock(match.namedGroup('start')!, eventDate),
      _parseClock(match.namedGroup('end')!, eventDate),
    );
  }

  DateTime _parseClock(String value, DateTime eventDate) {
    final normalized = value.replaceAll('：', ':').replaceAll('.', ':');
    final parts = normalized.split(':');
    return DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
