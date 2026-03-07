import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Metadata extracted from the supported timetable header.
@immutable
class TimetableMetadata {
  /// Creates timetable metadata.
  const TimetableMetadata({
    required this.eventTitle,
    required this.venueName,
    required this.eventDate,
    required this.timeZoneId,
    this.openAt,
    this.startAt,
    this.afterShowMerchandiseStartAt,
    this.afterShowMerchandiseEndAt,
  });

  /// Event title shown in the timetable header.
  final String eventTitle;

  /// Venue name extracted from the header.
  final String venueName;

  /// Event date associated with all performance slots.
  final DateTime eventDate;

  /// Time zone used when building Google Calendar URLs.
  final String timeZoneId;

  /// Venue open time when it is available.
  final DateTime? openAt;

  /// Event start time when it is available.
  final DateTime? startAt;

  /// Shared after-show merchandise start time.
  final DateTime? afterShowMerchandiseStartAt;

  /// Shared after-show merchandise end time.
  final DateTime? afterShowMerchandiseEndAt;

  /// Formatted event date label for the Japanese UI.
  String get eventDateLabel {
    const weekdays = <int, String>{
      DateTime.monday: '月',
      DateTime.tuesday: '火',
      DateTime.wednesday: '水',
      DateTime.thursday: '木',
      DateTime.friday: '金',
      DateTime.saturday: '土',
      DateTime.sunday: '日',
    };

    final dateLabel = DateFormat('yyyy.MM.dd').format(eventDate);
    final weekdayLabel = weekdays[eventDate.weekday] ?? '';
    return '$dateLabel ($weekdayLabel)';
  }

  /// Formatted open time label for the Japanese UI.
  String? get openTimeLabel =>
      openAt == null ? null : DateFormat('HH:mm').format(openAt!);

  /// Formatted start time label for the Japanese UI.
  String? get startTimeLabel =>
      startAt == null ? null : DateFormat('HH:mm').format(startAt!);

  /// Formatted after-show merchandise time label for the Japanese UI.
  String? get afterShowMerchandiseTimeLabel {
    final start = afterShowMerchandiseStartAt;
    final end = afterShowMerchandiseEndAt;
    if (start == null || end == null) {
      return null;
    }

    final formatter = DateFormat('HH:mm');
    return '${formatter.format(start)}〜${formatter.format(end)}';
  }
}

/// A single performer slot extracted from the timetable.
@immutable
class TimetablePerformanceSlot {
  /// Creates a timetable performance slot.
  const TimetablePerformanceSlot({
    required this.slotNumber,
    required this.artistName,
    required this.startAt,
    required this.endAt,
    required this.sourceText,
  });

  /// Visible row number in the left timetable column.
  final int slotNumber;

  /// Performer name.
  final String artistName;

  /// Performance start time.
  final DateTime startAt;

  /// Performance end time.
  final DateTime endAt;

  /// Source OCR text that produced this slot.
  final String sourceText;

  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}

/// A single merchandise slot associated with an artist.
@immutable
class TimetableMerchandiseSlot {
  /// Creates a merchandise slot.
  const TimetableMerchandiseSlot({
    required this.slotNumber,
    required this.artistName,
    required this.startAt,
    required this.endAt,
    required this.sourceText,
    this.boothLabel,
    this.isAfterShow = false,
  });

  /// Visible row number in the timetable.
  final int slotNumber;

  /// Performer name.
  final String artistName;

  /// Booth label shown in the timetable, such as `A`.
  final String? boothLabel;

  /// Merchandise start time.
  final DateTime startAt;

  /// Merchandise end time.
  final DateTime endAt;

  /// Whether this merchandise slot happens after the show.
  final bool isAfterShow;

  /// Source text that produced this slot.
  final String sourceText;

  /// Human-readable booth label.
  String get boothLabelText => isAfterShow ? '終演後物販' : '物販 $boothLabel';

  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}

/// A timetable row containing live and merchandise details for an artist.
@immutable
class TimetableArtistSchedule {
  /// Creates an artist schedule row.
  const TimetableArtistSchedule({
    required this.performance,
    this.merchandise,
  });

  /// Live performance details.
  final TimetablePerformanceSlot performance;

  /// Merchandise details for the artist, if present.
  final TimetableMerchandiseSlot? merchandise;

  /// Timetable row number.
  int get slotNumber => performance.slotNumber;

  /// Artist name.
  String get artistName => performance.artistName;
}

/// Event kind shown in the Google Calendar preview.
enum TimetableCalendarEntryType {
  /// A live performance event.
  live,

  /// A merchandise event.
  merchandise,
}

/// Preview data for a Google Calendar entry.
@immutable
class TimetableCalendarEntry {
  /// Creates a Google Calendar preview entry.
  const TimetableCalendarEntry({
    required this.slotNumber,
    required this.artistName,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.startAt,
    required this.endAt,
  });

  /// Timetable row number.
  final int slotNumber;

  /// Artist name.
  final String artistName;

  /// Entry type.
  final TimetableCalendarEntryType type;

  /// Preview title.
  final String title;

  /// Preview description.
  final String description;

  /// Event location.
  final String location;

  /// Event start time.
  final DateTime startAt;

  /// Event end time.
  final DateTime endAt;

  /// UI label for the event type.
  String get typeLabel => switch (type) {
    TimetableCalendarEntryType.live => 'ライブ',
    TimetableCalendarEntryType.merchandise => '物販',
  };

  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}

/// Parsed output for the first-launch supported timetable format.
@immutable
class TimetableScanResult {
  /// Creates a parsed timetable result.
  const TimetableScanResult({
    required this.metadata,
    required this.schedules,
    this.warnings = const <String>[],
    this.rawText = '',
  });

  /// Header metadata extracted from the supported timetable source.
  final TimetableMetadata metadata;

  /// Parsed timetable rows.
  final List<TimetableArtistSchedule> schedules;

  /// Non-fatal warnings collected during parsing.
  final List<String> warnings;

  /// Raw source text used for debugging unsupported cases.
  final String rawText;

  /// Whether at least one performer slot was parsed.
  bool get hasPerformances => schedules.isNotEmpty;

  /// Parsed performer slots.
  List<TimetablePerformanceSlot> get performances => [
    for (final schedule in schedules) schedule.performance,
  ];

  /// Parsed merchandise slots.
  List<TimetableMerchandiseSlot> get merchandiseSlots => [
    for (final schedule in schedules)
      ...switch (schedule.merchandise) {
        final merchandise? => [merchandise],
        null => const <TimetableMerchandiseSlot>[],
      },
  ];
}
