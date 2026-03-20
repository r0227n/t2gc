import 'dart:async';
import 'dart:typed_data';

import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timetable_ocr_service.g.dart';

/// Provides the OCR service used by the timetable flow.
@Riverpod(keepAlive: true)
TimetableOcrService timetableOcrService(Ref ref) {
  final service = TimetableOcrService();
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
}

/// Executes OCR using the lazily initialized NDL OCR engine.
class TimetableOcrService {
  /// Creates an OCR service.
  TimetableOcrService({
    Future<NdlocrLite> Function()? createEngine,
    Future<NdlocrResult> Function({
      required Uint8List imageBytes,
      required String imageName,
    })?
    recognizeImage,
  }) : _createEngine = createEngine ?? NdlocrLite.create,
       _recognizeImage = recognizeImage;

  final Future<NdlocrLite> Function() _createEngine;
  final Future<NdlocrResult> Function({
    required Uint8List imageBytes,
    required String imageName,
  })?
  _recognizeImage;

  NdlocrLite? _ocr;

  /// Runs OCR for the provided image bytes.
  Future<NdlocrResult> recognizeImageBytes({
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    if (_recognizeImage != null) {
      return _recognizeImage(
        imageBytes: imageBytes,
        imageName: imageName,
      );
    }

    _ocr ??= await _createEngine();
    return _ocr!.recognizeImageBytes(
      imageBytes,
      imageName: imageName,
      options: const NdlocrOptions(includeJson: true),
    );
  }

  /// Releases the OCR engine if it was created.
  Future<void> dispose() async {
    final ocr = _ocr;
    _ocr = null;
    if (ocr != null) {
      await ocr.dispose();
    }
  }
}
