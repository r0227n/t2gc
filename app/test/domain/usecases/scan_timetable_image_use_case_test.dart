import 'dart:typed_data';

import 'package:app/data/services/timetable_ocr_service.dart';
import 'package:app/domain/services/supported_timetable_parser.dart';
import 'package:app/domain/usecases/scan_timetable_image_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';

void main() {
  group('ScanTimetableImageUseCase', () {
    test('parses OCR result in the background pathway', () async {
      final useCase = ScanTimetableImageUseCase(
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => _ocrResultFixture(),
        ),
      );

      final result = await useCase(
        imageBytes: Uint8List.fromList(<int>[1, 2, 3]),
        imageName: 'fixture.png',
      );

      expect(result.performances, hasLength(1));
      expect(result.merchandiseSlots, hasLength(1));
      expect(result.metadata.eventTitle, contains('アイドル甲子園'));
    });

    test('supports overriding the parse executor for tests', () async {
      var parseCalls = 0;
      final useCase = ScanTimetableImageUseCase(
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => _ocrResultFixture(),
        ),
        parseResult: (result, _) async {
          parseCalls++;
          return const SupportedTimetableParser().parse(result);
        },
      );

      final result = await useCase(
        imageBytes: Uint8List.fromList(<int>[1, 2, 3]),
        imageName: 'fixture.png',
      );

      expect(parseCalls, 1);
      expect(result.performances.single.artistName, 'Alice');
    });

    test('passes exclusion words into the parser pathway', () async {
      final useCase = ScanTimetableImageUseCase(
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => _ocrResultFixture(),
        ),
        getExcludedArtistWords: () => const <String>['lice'],
        parseResult: (result, excludedArtistWords) async {
          return SupportedTimetableParser(
            excludedArtistWords: excludedArtistWords,
          ).parse(result);
        },
      );

      final result = await useCase(
        imageBytes: Uint8List.fromList(<int>[1, 2, 3]),
        imageName: 'fixture.png',
      );

      expect(result.performances.single.artistName, 'A');
    });
  });
}

NdlocrResult _ocrResultFixture() {
  return const NdlocrResult(
    text:
        'アイドル甲子園 in KANDA SQUARE HALL\n'
        '2026.03.21 OPEN 10:30 START 11:00\n'
        '1 11:00~11:20 Alice A 11:30~12:30\n',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[
      NdlocrLine(
        order: 0,
        text: 'アイドル甲子園 in KANDA SQUARE HALL',
        boundingBox: NdlocrBoundingBox(x: 80, y: 80, width: 900, height: 80),
        type: 'line',
        confidence: 0.99,
        isVertical: false,
      ),
      NdlocrLine(
        order: 1,
        text: '2026.03.21 OPEN 10:30 START 11:00',
        boundingBox: NdlocrBoundingBox(x: 80, y: 180, width: 900, height: 60),
        type: 'line',
        confidence: 0.99,
        isVertical: false,
      ),
      NdlocrLine(
        order: 2,
        text: '1 11:00~11:20 Alice A 11:30~12:30',
        boundingBox: NdlocrBoundingBox(x: 120, y: 500, width: 900, height: 60),
        type: 'line',
        confidence: 0.99,
        isVertical: false,
      ),
    ],
  );
}
