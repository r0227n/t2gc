import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_merchandise_slot.freezed.dart';

/// A single merchandise slot associated with an artist.
@freezed
abstract class TimetableMerchandiseSlot with _$TimetableMerchandiseSlot {
  /// Creates a merchandise slot.
  const factory TimetableMerchandiseSlot({
    required int slotNumber,
    required String artistName,
    required DateTime startAt,
    required DateTime endAt,
    required String sourceText,
    String? boothLabel,
    @Default(false) bool isAfterShow,
  }) = _TimetableMerchandiseSlot;

  /// Creates a merchandise slot.
  const TimetableMerchandiseSlot._();
}
