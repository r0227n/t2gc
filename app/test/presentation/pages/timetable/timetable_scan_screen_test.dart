import 'dart:async';
import 'dart:typed_data';

import 'package:app/data/models/selected_timetable_image.dart';
import 'package:app/data/services/timetable_image_picker_service.dart';
import 'package:app/data/services/timetable_ocr_service.dart';
import 'package:app/presentation/pages/timetable_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';

void main() {
  testWidgets('renders the empty timetable state before OCR', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Browse Files'), findsOneWidget);
    expect(find.text('Verify extracted events'), findsNothing);
    expect(
      find.text(
        'Detected events will appear here once a timetable is scanned.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('COLOR of COLOR'), findsNothing);
    expect(find.text('09:50〜11:10'), findsNothing);
  });

  testWidgets('renders parsed timetable data from provider state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timetableImagePickerServiceProvider.overrideWith(
            (ref) => TimetableImagePickerService(
              pickImage: () async => SelectedTimetableImage(
                bytes: _validImageBytes(),
                name: 'fixture.png',
              ),
            ),
          ),
          timetableOcrServiceProvider.overrideWith(
            (ref) => TimetableOcrService(
              recognizeImage:
                  ({
                    required imageBytes,
                    required imageName,
                  }) async => _ocrResultFixture(),
            ),
          ),
        ],
        child: const MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.tap(find.text('Browse Files'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('timetable-scan-hero-selected-image')),
      findsOneWidget,
    );
    expect(find.text('fixture.png'), findsOneWidget);
    expect(find.text('09:15〜09:35'), findsWidgets);
    expect(find.text('09:50〜11:10'), findsWidgets);
    expect(find.text('OCR debug text'), findsOneWidget);
  });

  testWidgets('shows selected image before OCR completes', (tester) async {
    final completer = Completer<NdlocrResult>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timetableImagePickerServiceProvider.overrideWith(
            (ref) => TimetableImagePickerService(
              pickImage: () async => SelectedTimetableImage(
                bytes: _validImageBytes(),
                name: 'pending.png',
              ),
            ),
          ),
          timetableOcrServiceProvider.overrideWith(
            (ref) => TimetableOcrService(
              recognizeImage:
                  ({
                    required imageBytes,
                    required imageName,
                  }) => completer.future,
            ),
          ),
        ],
        child: const MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse Files'));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('timetable-scan-hero-selected-image')),
      findsOneWidget,
    );
    expect(find.text('pending.png'), findsOneWidget);
    expect(find.text('Analyzing…'), findsOneWidget);
    expect(find.text('Verify extracted events'), findsNothing);

    completer.complete(_ocrResultFixture());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
  });

  testWidgets('clear button cancels OCR and hides selected image details', (
    tester,
  ) async {
    final completer = Completer<NdlocrResult>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timetableImagePickerServiceProvider.overrideWith(
            (ref) => TimetableImagePickerService(
              pickImage: () async => SelectedTimetableImage(
                bytes: _validImageBytes(),
                name: 'cancel-me.png',
              ),
            ),
          ),
          timetableOcrServiceProvider.overrideWith(
            (ref) => TimetableOcrService(
              recognizeImage:
                  ({
                    required imageBytes,
                    required imageName,
                  }) => completer.future,
            ),
          ),
        ],
        child: const MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse Files'));
    await tester.pump();

    expect(find.text('cancel-me.png'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('timetable-scan-hero-clear-image-button')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('timetable-scan-hero-clear-image-button')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('timetable-scan-hero-selected-image')),
      findsNothing,
    );
    expect(find.text('cancel-me.png'), findsNothing);
    expect(
      find.byKey(const ValueKey('timetable-scan-hero-clear-image-button')),
      findsNothing,
    );
    expect(find.text('Browse Files'), findsOneWidget);
    expect(find.text('Verify extracted events'), findsNothing);

    completer.complete(_ocrResultFixture());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsNothing);
    expect(
      find.text('Choose an image to start OCR extraction.'),
      findsOneWidget,
    );
  });

  testWidgets('row checkboxes control selection counts', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timetableImagePickerServiceProvider.overrideWith(
            (ref) => TimetableImagePickerService(
              pickImage: () async => SelectedTimetableImage(
                bytes: _validImageBytes(),
                name: 'fixture.png',
              ),
            ),
          ),
          timetableOcrServiceProvider.overrideWith(
            (ref) => TimetableOcrService(
              recognizeImage:
                  ({
                    required imageBytes,
                    required imageName,
                  }) async => _attachedSampleOcrResultFixture(),
            ),
          ),
        ],
        child: const MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse Files'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('artist-schedule-28')), findsOneWidget);

    Checkbox rowCheckbox(int slot) => tester.widget<Checkbox>(
      find.byKey(ValueKey('event-row-checkbox-$slot')),
    );

    expect(rowCheckbox(1).value, isTrue);
    expect(rowCheckbox(2).value, isTrue);

    await tester.ensureVisible(
      find.byKey(const ValueKey('event-row-checkbox-1')),
    );
    await tester.tap(find.byKey(const ValueKey('event-row-checkbox-1')));
    await tester.pumpAndSettle();

    expect(rowCheckbox(1).value, isFalse);
    expect(rowCheckbox(2).value, isTrue);
    expect(find.textContaining('30 Event'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('select-all-slots-checkbox')),
    );
    await tester.tap(find.byKey(const ValueKey('select-all-slots-checkbox')));
    await tester.pumpAndSettle();

    expect(rowCheckbox(1).value, isTrue);
    expect(find.textContaining('31 Event'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('select-all-slots-checkbox')));
    await tester.pumpAndSettle();

    expect(rowCheckbox(1).value, isFalse);
    expect(find.text('0 Events Selected'), findsOneWidget);
  });

  testWidgets('shows warnings for partial merchandise sample', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timetableImagePickerServiceProvider.overrideWith(
            (ref) => TimetableImagePickerService(
              pickImage: () async => SelectedTimetableImage(
                bytes: _validImageBytes(),
                name: 'partial.png',
              ),
            ),
          ),
          timetableOcrServiceProvider.overrideWith(
            (ref) => TimetableOcrService(
              recognizeImage:
                  ({
                    required imageBytes,
                    required imageName,
                  }) async => _partialMerchandiseOcrResultFixture(),
            ),
          ),
        ],
        child: const MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse Files'));
    await tester.pumpAndSettle();

    expect(find.text('Needs review'), findsOneWidget);
    expect(find.text('2 件の特典会時間を取得できませんでした。'), findsOneWidget);
    expect(find.text('N/A'), findsNWidgets(2));
  });

  testWidgets('shows error status for simulated OCR failure', (tester) async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {};
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timetableImagePickerServiceProvider.overrideWith(
            (ref) => TimetableImagePickerService(
              pickImage: () async => SelectedTimetableImage(
                bytes: _validImageBytes(),
                name: 'failure.png',
              ),
            ),
          ),
          timetableOcrServiceProvider.overrideWith(
            (ref) => TimetableOcrService(
              recognizeImage:
                  ({
                    required imageBytes,
                    required imageName,
                  }) async => throw StateError(
                    'Failed to initialize the OCR engine.',
                  ),
            ),
          ),
        ],
        child: const MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse Files'));
    await tester.pumpAndSettle();

    expect(find.textContaining('OCR failed:'), findsOneWidget);
  });
}

NdlocrResult _ocrResultFixture() {
  return const NdlocrResult(
    text: '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
''',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[],
  );
}

NdlocrResult _attachedSampleOcrResultFixture() {
  return const NdlocrResult(
    text: '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
No. ライブ時間 出演者 物販枠 物販時間
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
2 09:35~09:55 Payrin's B 10:10~11:30
3 09:55~10:15 KOURiN C 10:30~11:50
4 10:15~10:35 Malcolm Mask McLaren D 10:50~12:10
5 10:35~10:55 紫陽花は降らない A 11:15~12:35
6 10:55~11:15 ニコルポップ B 11:35~12:55
7 11:15~11:35 アストレイル C 11:55~13:15
8 11:35~11:55 鳴ル神 D 12:15~13:35
9 11:55~12:15 XINXIN A 12:40~14:00
10 12:15~12:35 9DayzGlitchClubTokyo B 13:00~14:20
11 12:35~12:55 lonlium C 13:20~14:40
12 12:55~13:15 Chalca D 13:40~15:00
13 13:20~13:40 こみっきゅおん！ A 14:05~15:25
14 13:40~14:00 メイビーME B 14:25~15:45
15 14:00~14:20 RePLAY C 14:45~16:05
16 14:20~14:40 Tohkei D 15:05~16:25
17 14:40~15:05 Mirror,Mirror A 15:30~16:50
18 15:05~15:30 THE ORCHESTRA TOKYO B 15:50~17:10
19 15:30~15:55 selfish C 16:15~17:35
20 15:55~16:20 透色ドロップ D 16:40~18:00
21 16:25~16:50 かすみ草とステラ A 17:10~18:30
22 16:50~17:15 #よーよーよー B 17:35~18:55
23 17:15~17:40 Devil ANTHEM. C 18:00~19:20
24 17:40~18:05 HIBANA D 18:25~19:45
25 18:05~18:30 ハルニシオン A 18:50~20:10
26 18:30~18:55 SITUASION B 19:15~20:35
27 18:55~19:20 #Mooove! C 19:40~21:00
28 19:25~19:50 Merry BAD TUNE. - 終演後
29 19:50~20:15 INUWASI - 終演後
30 20:15~20:40 ジエメイ - 終演後
31 20:40~21:10 われらがプワプワプーワプワ - 終演後
終演後物販
全体 21:10~22:30
''',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[],
  );
}

NdlocrResult _partialMerchandiseOcrResultFixture() {
  return const NdlocrResult(
    text: '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
No. ライブ時間 出演者 物販枠 物販時間
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
2 09:35~09:55 Payrin's B
3 09:55~10:15 KOURiN
''',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[],
  );
}

Uint8List _validImageBytes() {
  return Uint8List.fromList(const <int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0xF8,
    0xCF,
    0xC0,
    0x00,
    0x00,
    0x03,
    0x01,
    0x01,
    0x00,
    0x18,
    0xDD,
    0x8D,
    0xB1,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]);
}
