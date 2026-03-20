import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_performance_slot.freezed.dart';

/// A single performer slot extracted from the timetable.
@freezed
abstract class TimetablePerformanceSlot with _$TimetablePerformanceSlot {
  /// Creates a timetable performance slot.
  const factory TimetablePerformanceSlot({
    required int slotNumber,
    required String artistName,
    required DateTime startAt,
    required DateTime endAt,
    required String sourceText,
  }) = _TimetablePerformanceSlot;

  /// Creates a timetable performance slot.
  const TimetablePerformanceSlot._();
}
