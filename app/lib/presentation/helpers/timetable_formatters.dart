import 'package:app/core/gen/slang.g.dart' as app;
import 'package:app/domain/models/timetable_calendar_entry.dart';
import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_metadata.dart';
import 'package:app/domain/models/timetable_performance_slot.dart';
import 'package:intl/intl.dart';

/// Presentation formatting helpers for timetable models.
extension TimetableMetadataPresentation on TimetableMetadata {
  /// Formatted event date label for the Japanese UI.
  String get eventDateLabel {
    final weekdays = <int, String>{
      DateTime.monday: app.t.timetableScan.formatters.monday,
      DateTime.tuesday: app.t.timetableScan.formatters.tuesday,
      DateTime.wednesday: app.t.timetableScan.formatters.wednesday,
      DateTime.thursday: app.t.timetableScan.formatters.thursday,
      DateTime.friday: app.t.timetableScan.formatters.friday,
      DateTime.saturday: app.t.timetableScan.formatters.saturday,
      DateTime.sunday: app.t.timetableScan.formatters.sunday,
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

/// Presentation formatting helpers for performance slots.
extension TimetablePerformanceSlotPresentation on TimetablePerformanceSlot {
  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}

/// Presentation formatting helpers for merchandise slots.
extension TimetableMerchandiseSlotPresentation on TimetableMerchandiseSlot {
  /// Human-readable booth label.
  String get boothLabelText => isAfterShow
      ? app.t.timetableScan.formatters.afterShowMerchandise
      : app.t.timetableScan.formatters.merchandiseBooth(
          boothLabel: boothLabel ?? '',
        );

  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}

/// Presentation formatting helpers for calendar entries.
extension TimetableCalendarEntryPresentation on TimetableCalendarEntry {
  /// UI label for the event type.
  String get typeLabel => switch (type) {
    TimetableCalendarEntryType.live => app.t.timetableScan.formatters.liveType,
    TimetableCalendarEntryType.merchandise =>
      app.t.timetableScan.formatters.merchandiseType,
  };

  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}
