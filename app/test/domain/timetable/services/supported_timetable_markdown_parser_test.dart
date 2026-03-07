import 'dart:io';

import 'package:app/domain/timetable/services/google_calendar_draft_builder.dart';
import 'package:app/domain/timetable/services/supported_timetable_markdown_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupportedTimetableMarkdownParser', () {
    const parser = SupportedTimetableMarkdownParser();

    test('parses the sample timetable markdown from docs', () {
      final markdown = File('../docs/SAMPLE_TIMETABLE.md').readAsStringSync();

      final parsed = parser.parse(markdown);
      final firstSchedule = parsed.schedules.first;
      final lastSchedule = parsed.schedules.last;

      expect(parsed.metadata.eventTitle, 'アイドル甲子園 in KANDA SQUARE HALL -DAY2-');
      expect(parsed.metadata.venueName, 'KANDA SQUARE HALL');
      expect(parsed.metadata.openTimeLabel, '09:00');
      expect(parsed.metadata.startTimeLabel, '09:15');
      expect(parsed.metadata.afterShowMerchandiseTimeLabel, '21:10〜22:30');
      expect(parsed.performances, hasLength(31));
      expect(parsed.merchandiseSlots, hasLength(31));
      expect(firstSchedule.artistName, 'COLOR of COLOR');
      expect(firstSchedule.performance.timeLabel, '09:15〜09:35');
      expect(firstSchedule.merchandise?.boothLabelText, '物販 A');
      expect(firstSchedule.merchandise?.timeLabel, '09:50〜11:10');
      expect(lastSchedule.artistName, 'われらがプワプワプーワプワ');
      expect(lastSchedule.performance.timeLabel, '20:40〜21:10');
      expect(lastSchedule.merchandise?.boothLabelText, '終演後物販');
      expect(lastSchedule.merchandise?.timeLabel, '21:10〜22:30');
      expect(parsed.warnings, isEmpty);
    });

    test('builds Google Calendar preview entries for live and merchandise', () {
      final markdown = File('../docs/SAMPLE_TIMETABLE.md').readAsStringSync();
      final parsed = parser.parse(markdown);
      final selectedSchedules = parsed.schedules
          .where((schedule) => <int>{1, 28}.contains(schedule.slotNumber))
          .toList();

      final entries = const GoogleCalendarDraftBuilder().buildEntries(
        metadata: parsed.metadata,
        schedules: selectedSchedules,
      );

      expect(entries, hasLength(4));
      expect(entries[0].title, 'COLOR of COLOR ライブ');
      expect(entries[0].timeLabel, '09:15〜09:35');
      expect(entries[1].title, 'COLOR of COLOR 物販');
      expect(entries[1].timeLabel, '09:50〜11:10');
      expect(entries[3].title, 'Merry BAD TUNE. 物販');
      expect(entries[3].timeLabel, '21:10〜22:30');
    });
  });
}
