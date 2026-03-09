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
      expect(state.statusMessage, '画像選択がキャンセルされました。');
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
      expect(state.selectedSlots, const {1});
      expect(state.statusMessage, 'OCR から 1 組のライブと 1 件の物販を抽出しました。');
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
          .selectedSlots;

      notifier.setSlotSelected(slotNumber: 1, isSelected: false);

      final after = container
          .read(timetableScanControllerProvider)
          .selectedSlots;
      expect(before, const {1});
      expect(after, isEmpty);
      expect(identical(before, after), isFalse);
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
