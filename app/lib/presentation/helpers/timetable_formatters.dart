import 'package:app/domain/models/timetable_calendar_entry.dart';
import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_metadata.dart';
import 'package:app/domain/models/timetable_performance_slot.dart';
import 'package:intl/intl.dart';

/// Presentation formatting helpers for timetable models.
extension TimetableMetadataPresentation on TimetableMetadata {
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
  String get boothLabelText => isAfterShow ? '終演後物販' : '物販 $boothLabel';

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
    TimetableCalendarEntryType.live => 'ライブ',
    TimetableCalendarEntryType.merchandise => '物販',
  };

  /// Human-readable time label.
  String get timeLabel {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(startAt)}〜${formatter.format(endAt)}';
  }
}
