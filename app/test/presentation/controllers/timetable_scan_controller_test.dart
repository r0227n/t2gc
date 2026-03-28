import 'package:app/data/models/selected_timetable_image.dart';
import 'package:app/data/services/timetable_image_picker_service.dart';
import 'package:app/data/services/timetable_ocr_service.dart';
import 'package:app/presentation/controllers/timetable_scan_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';

void main() {
  group('TimetableScanController', () {
    test('updates status when image selection is canceled', () async {
      final container = _createContainer(
        imagePickerService: TimetableImagePickerService(
          pickImage: () async => null,
        ),
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        timetableScanControllerProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container
          .read(timetableScanControllerProvider.notifier)
          .inspectFromGallery();

      final state = container.read(timetableScanControllerProvider);
      expect(state.statusMessage, '画像の選択がキャンセルされました。');
      expect(state.isBusy, isFalse);
      expect(state.scanResult, isNull);
    });

    test('stores parsed timetable data after OCR succeeds', () async {
      final container = _createContainer(
        imagePickerService: TimetableImagePickerService(
          pickImage: () async => SelectedTimetableImage(
            bytes: Uint8List.fromList([1, 2, 3]),
            name: 'fixture.png',
          ),
        ),
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => _ocrResultFixture(),
        ),
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        timetableScanControllerProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container
          .read(timetableScanControllerProvider.notifier)
          .inspectFromGallery();

      final state = container.read(timetableScanControllerProvider);
      expect(state.imageName, 'fixture.png');
      expect(state.isBusy, isFalse);
      expect(state.scanResult?.performances, hasLength(1));
      expect(state.scanResult?.merchandiseSlots, hasLength(1));
      expect(state.selectedSlotIndices, const {0});
      expect(
        state.statusMessage,
        'OCR からライブ 1 件と特典会 1 件を抽出しました。',
      );
    });

    test('clears busy state and surfaces errors when OCR fails', () async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {};
      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      final container = _createContainer(
        imagePickerService: TimetableImagePickerService(
          pickImage: () async => SelectedTimetableImage(
            bytes: Uint8List.fromList([1, 2, 3]),
            name: 'fixture.png',
          ),
        ),
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => throw StateError('boom'),
        ),
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        timetableScanControllerProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container
          .read(timetableScanControllerProvider.notifier)
          .inspectFromGallery();

      final state = container.read(timetableScanControllerProvider);
      expect(state.isBusy, isFalse);
      expect(state.scanResult, isNull);
      expect(state.statusMessage, contains('OCR に失敗しました:'));
      expect(state.statusMessage, contains('boom'));
    });

    test('updates slot selection immutably', () async {
      final container = _createContainer(
        imagePickerService: TimetableImagePickerService(
          pickImage: () async => SelectedTimetableImage(
            bytes: Uint8List.fromList([1, 2, 3]),
            name: 'fixture.png',
          ),
        ),
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => _ocrResultFixture(),
        ),
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        timetableScanControllerProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final notifier = container.read(timetableScanControllerProvider.notifier);
      await notifier.inspectFromGallery();
      final before = container
          .read(timetableScanControllerProvider)
          .selectedSlotIndices;

      notifier.setSlotSelected(index: 0, isSelected: false);

      final after = container
          .read(timetableScanControllerProvider)
          .selectedSlotIndices;
      expect(before, const {0});
      expect(after, isEmpty);
      expect(identical(before, after), isFalse);
    });

    test('can select all and clear all parsed slots', () async {
      final container = _createContainer(
        imagePickerService: TimetableImagePickerService(
          pickImage: () async => SelectedTimetableImage(
            bytes: Uint8List.fromList([1, 2, 3]),
            name: 'fixture.png',
          ),
        ),
        ocrService: TimetableOcrService(
          recognizeImage:
              ({
                required imageBytes,
                required imageName,
              }) async => _attachedSampleOcrResultFixture(),
        ),
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        timetableScanControllerProvider,
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final notifier = container.read(timetableScanControllerProvider.notifier);
      await notifier.inspectFromGallery();
      notifier.clearAllSlots();
      expect(
        container.read(timetableScanControllerProvider).selectedSlotIndices,
        isEmpty,
      );

      notifier.selectAllSlots();
      expect(
        container
            .read(timetableScanControllerProvider)
            .selectedSlotIndices
            .length,
        31,
      );
    });
  });
}

ProviderContainer _createContainer({
  required TimetableImagePickerService imagePickerService,
  TimetableOcrService? ocrService,
}) {
  return ProviderContainer(
    overrides: [
      timetableImagePickerServiceProvider.overrideWith(
        (ref) => imagePickerService,
      ),
      if (ocrService != null)
        timetableOcrServiceProvider.overrideWith((ref) => ocrService),
    ],
  );
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
