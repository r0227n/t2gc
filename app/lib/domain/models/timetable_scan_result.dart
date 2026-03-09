import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_metadata.dart';
import 'package:app/domain/models/timetable_performance_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_scan_result.freezed.dart';

/// Parsed output for the first-launch supported timetable format.
@freezed
abstract class TimetableScanResult with _$TimetableScanResult {
  /// Creates a parsed timetable result.
  const factory TimetableScanResult({
    required TimetableMetadata metadata,
    required List<TimetableArtistSchedule> schedules,
    @Default(<String>[]) List<String> warnings,
    @Default('') String rawText,
  }) = _TimetableScanResult;

  /// Creates a parsed timetable result.
  const TimetableScanResult._();

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
