import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_performance_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_artist_schedule.freezed.dart';

/// A timetable row containing live and merchandise details for an artist.
@freezed
abstract class TimetableArtistSchedule with _$TimetableArtistSchedule {
  /// Creates an artist schedule row.
  const factory TimetableArtistSchedule({
    required TimetablePerformanceSlot performance,
    TimetableMerchandiseSlot? merchandise,
  }) = _TimetableArtistSchedule;

  /// Creates an artist schedule row.
  const TimetableArtistSchedule._();

  /// Timetable row number.
  int get slotNumber => performance.slotNumber;

  /// Artist name.
  String get artistName => performance.artistName;
}
