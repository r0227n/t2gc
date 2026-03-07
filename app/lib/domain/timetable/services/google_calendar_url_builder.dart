import 'package:app/domain/timetable/models/timetable_scan_result.dart';
import 'package:intl/intl.dart';

/// Builds Google Calendar create-event URLs from parsed timetable slots.
class GoogleCalendarUrlBuilder {
  /// Creates a Google Calendar URL builder.
  const GoogleCalendarUrlBuilder();

  /// Builds a Google Calendar create-event URL for [slot].
  Uri buildUrl({
    required TimetableMetadata metadata,
    required TimetablePerformanceSlot slot,
  }) {
    final formatter = DateFormat("yyyyMMdd'T'HHmmss");
    final details = <String>[
      'OCR で抽出した出演枠です。',
      'イベント: ${metadata.eventTitle}',
      '出演時間: ${slot.timeLabel}',
      if (metadata.openTimeLabel case final openTime?) '開場: $openTime',
      if (metadata.startTimeLabel case final startTime?) '開演: $startTime',
      '元データ: ${slot.sourceText}',
    ].join('\n');

    return Uri.https(
      'calendar.google.com',
      '/calendar/render',
      <String, String>{
        'action': 'TEMPLATE',
        'text': slot.artistName,
        'details': details,
        'location': metadata.venueName,
        'dates':
            '${formatter.format(slot.startAt)}/${formatter.format(slot.endAt)}',
        'ctz': metadata.timeZoneId,
      },
    );
  }
}
