import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_metadata.freezed.dart';

/// Metadata extracted from the supported timetable header.
@freezed
abstract class TimetableMetadata with _$TimetableMetadata {
  /// Creates timetable metadata.
  const factory TimetableMetadata({
    required String eventTitle,
    required String venueName,
    required DateTime eventDate,
    required String timeZoneId,
    DateTime? openAt,
    DateTime? startAt,
    DateTime? afterShowMerchandiseStartAt,
    DateTime? afterShowMerchandiseEndAt,
  }) = _TimetableMetadata;

  /// Creates timetable metadata.
  const TimetableMetadata._();
}
