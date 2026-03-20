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

    expect(find.text('画像を選んで OCR 取込'), findsOneWidget);
    expect(find.text('検証シナリオ'), findsOneWidget);
    expect(find.text('ライブ / 物販タイムテーブル'), findsOneWidget);
    expect(find.text('タイムテーブルを検出するとここに表示します。'), findsOneWidget);
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
    await tester.tap(find.text('画像を選んで OCR 取込'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
    expect(find.text('09:15〜09:35'), findsWidgets);
    expect(find.text('09:50〜11:10'), findsWidgets);
    expect(find.text('OCR デバッグテキスト'), findsOneWidget);
  });

  testWidgets('filters displayed groups based on checkbox selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TimetableScanScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('scenario-attached-sample')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('artist-schedule-28')), findsOneWidget);

    Checkbox checkboxValue(int index) => tester.widget<Checkbox>(
      find.byKey(ValueKey('artist-filter-checkbox-$index')),
    );

    expect(checkboxValue(0).value, isTrue);
    expect(checkboxValue(1).value, isTrue);

    await tester.ensureVisible(
      find.byKey(const ValueKey('artist-filter-checkbox-0')),
    );
    await tester.tap(find.byKey(const ValueKey('artist-filter-checkbox-0')));
    await tester.pumpAndSettle();

    expect(checkboxValue(0).value, isFalse);
    expect(checkboxValue(1).value, isTrue);
    expect(find.byKey(const ValueKey('artist-schedule-1')), findsNothing);
    expect(find.text('表示中 30 / 31 組'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('clear-all-slots-button')),
    );
    await tester.tap(find.byKey(const ValueKey('clear-all-slots-button')));
    await tester.pumpAndSettle();

    expect(find.text('表示対象のグループがありません。チェックをONにしてください。'), findsOneWidget);
    expect(find.text('表示中 0 / 31 組'), findsOneWidget);
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

    await tester.tap(
      find.byKey(const ValueKey('scenario-partial-merchandise')),
    );
    await tester.pumpAndSettle();

    expect(find.text('要確認'), findsOneWidget);
    expect(find.text('2 件の特典会時間を取得できませんでした。'), findsOneWidget);
    expect(find.text('未取得'), findsNWidgets(2));
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

    expect(find.textContaining('OCR に失敗しました:'), findsOneWidget);
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
