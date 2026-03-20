import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_calendar_entry.freezed.dart';

/// Event kind shown in the Google Calendar preview.
enum TimetableCalendarEntryType {
  /// A live performance event.
  live,

  /// A merchandise event.
  merchandise,
}

/// Preview data for a Google Calendar entry.
@freezed
abstract class TimetableCalendarEntry with _$TimetableCalendarEntry {
  /// Creates a Google Calendar preview entry.
  const factory TimetableCalendarEntry({
    required int slotNumber,
    required String artistName,
    required TimetableCalendarEntryType type,
    required String title,
    required String description,
    required String location,
    required DateTime startAt,
    required DateTime endAt,
  }) = _TimetableCalendarEntry;

  /// Creates a Google Calendar preview entry.
  const TimetableCalendarEntry._();
}
