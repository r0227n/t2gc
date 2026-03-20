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
    expect(find.text('Validation scenarios'), findsOneWidget);
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
    expect(find.text('09:15〜09:35'), findsWidgets);
    expect(find.text('09:50〜11:10'), findsWidgets);
    expect(find.text('OCR debug text'), findsOneWidget);
  });

  testWidgets('row checkboxes control selection counts', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('scenario-attached-sample')),
    );
    await tester.tap(find.byKey(const ValueKey('scenario-attached-sample')));
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
      const ProviderScope(
        child: MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('scenario-partial-merchandise')),
    );
    await tester.tap(
      find.byKey(const ValueKey('scenario-partial-merchandise')),
    );
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
      const ProviderScope(
        child: MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('scenario-ocr-failure')),
    );
    await tester.tap(find.byKey(const ValueKey('scenario-ocr-failure')));
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
