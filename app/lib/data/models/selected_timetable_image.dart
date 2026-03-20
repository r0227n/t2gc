import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_timetable_image.freezed.dart';

/// Image payload selected for timetable OCR.
@freezed
abstract class SelectedTimetableImage with _$SelectedTimetableImage {
  /// Creates an image payload selected for timetable OCR.
  const factory SelectedTimetableImage({
    required Uint8List bytes,
    required String name,
  }) = _SelectedTimetableImage;
}
