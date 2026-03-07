import 'package:app/domain/timetable/models/timetable_scan_result.dart';

/// Builds preview entries that mirror Google Calendar registrations.
class GoogleCalendarDraftBuilder {
  /// Creates a Google Calendar draft builder.
  const GoogleCalendarDraftBuilder();

  /// Builds preview entries for the selected artist schedules.
  List<TimetableCalendarEntry> buildEntries({
    required TimetableMetadata metadata,
    required Iterable<TimetableArtistSchedule> schedules,
  }) {
    final entries = <TimetableCalendarEntry>[];

    for (final schedule in schedules) {
      entries.add(
        TimetableCalendarEntry(
          slotNumber: schedule.slotNumber,
          artistName: schedule.artistName,
          type: TimetableCalendarEntryType.live,
          title: '${schedule.artistName} ライブ',
          description: _buildLiveDescription(
            metadata: metadata,
            schedule: schedule,
          ),
          location: metadata.venueName,
          startAt: schedule.performance.startAt,
          endAt: schedule.performance.endAt,
        ),
      );

      if (schedule.merchandise case final merchandise?) {
        entries.add(
          TimetableCalendarEntry(
            slotNumber: schedule.slotNumber,
            artistName: schedule.artistName,
            type: TimetableCalendarEntryType.merchandise,
            title: '${schedule.artistName} 物販',
            description: _buildMerchandiseDescription(
              metadata: metadata,
              schedule: schedule,
              merchandise: merchandise,
            ),
            location: metadata.venueName,
            startAt: merchandise.startAt,
            endAt: merchandise.endAt,
          ),
        );
      }
    }

    return entries;
  }

  String _buildLiveDescription({
    required TimetableMetadata metadata,
    required TimetableArtistSchedule schedule,
  }) {
    final lines = <String>[
      'イベント: ${metadata.eventTitle}',
      '区分: ライブ',
      '出演時間: ${schedule.performance.timeLabel}',
      if (schedule.merchandise case final merchandise?)
        '物販: ${merchandise.boothLabelText} ${merchandise.timeLabel}',
      if (metadata.openTimeLabel case final openTime?) 'OPEN: $openTime',
      if (metadata.startTimeLabel case final startTime?) 'START: $startTime',
    ];
    return lines.join('\n');
  }

  String _buildMerchandiseDescription({
    required TimetableMetadata metadata,
    required TimetableArtistSchedule schedule,
    required TimetableMerchandiseSlot merchandise,
  }) {
    final lines = <String>[
      'イベント: ${metadata.eventTitle}',
      '区分: 物販',
      'ライブ: ${schedule.performance.timeLabel}',
      '${merchandise.boothLabelText}: ${merchandise.timeLabel}',
      if (metadata.afterShowMerchandiseTimeLabel case final afterShowTime?)
        '終演後物販全体: $afterShowTime',
    ];
    return lines.join('\n');
  }
}
