import 'dart:typed_data';

import 'package:app/data/services/timetable_ocr_service.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/domain/services/supported_timetable_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_timetable_image_use_case.g.dart';

/// Provides the timetable image scanning use case.
@Riverpod(keepAlive: true)
ScanTimetableImageUseCase scanTimetableImageUseCase(Ref ref) {
  return ScanTimetableImageUseCase(
    ocrService: ref.watch(timetableOcrServiceProvider),
    parser: ref.watch(supportedTimetableParserProvider),
  );
}

/// Runs OCR and parsing for a selected timetable image.
class ScanTimetableImageUseCase {
  /// Creates a timetable scanning use case.
  const ScanTimetableImageUseCase({
    required TimetableOcrService ocrService,
    required SupportedTimetableParser parser,
  }) : _ocrService = ocrService,
       _parser = parser;

  final TimetableOcrService _ocrService;
  final SupportedTimetableParser _parser;

  /// Scans the provided image and returns the parsed timetable.
  Future<TimetableScanResult> call({
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    final ocrResult = await _ocrService.recognizeImageBytes(
      imageBytes: imageBytes,
      imageName: imageName,
    );
    return _parser.parse(ocrResult);
  }
}
