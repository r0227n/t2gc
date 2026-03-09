import 'package:app/data/services/timetable_image_picker_service.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/domain/usecases/scan_timetable_image_use_case.dart';
import 'package:core/core.dart' as core;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timetable_scan_controller.freezed.dart';
part 'timetable_scan_controller.g.dart';

/// View state for the timetable OCR screen.
@freezed
abstract class TimetableScanState with _$TimetableScanState {
  /// Creates the timetable screen state.
  const factory TimetableScanState({
    Uint8List? imageBytes,
    @Default('') String imageName,
    @Default(TimetableScanState.initialStatusMessage) String statusMessage,
    @Default(false) bool isBusy,
    TimetableScanResult? scanResult,
    @Default(<int>{}) Set<int> selectedSlots,
  }) = _TimetableScanState;

  /// Creates the timetable screen state.
  const TimetableScanState._();

  /// Initial guidance shown before OCR starts.
  static const initialStatusMessage = '画像を選んで OCR 取込を開始してください。';
}

/// Controls OCR execution and selection state for the timetable screen.
@riverpod
class TimetableScanController extends _$TimetableScanController {
  var _isDisposed = false;

  @override
  TimetableScanState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
    });
    return const TimetableScanState();
  }

  /// Prompts the user to select an image and runs OCR against it.
  Future<void> inspectFromGallery() async {
    final image = await ref
        .read(timetableImagePickerServiceProvider)
        .pickImageFromGallery();

    if (image == null) {
      state = state.copyWith(statusMessage: '画像選択がキャンセルされました。');
      return;
    }

    state = state.copyWith(
      isBusy: true,
      statusMessage: 'OCR を実行してタイムテーブルを解析しています...',
    );

    try {
      final result = await ref
          .read(scanTimetableImageUseCaseProvider)
          .call(imageBytes: image.bytes, imageName: image.name);

      if (_isDisposed) {
        return;
      }

      state = state.copyWith(
        imageBytes: image.bytes,
        imageName: image.name,
        scanResult: result,
        selectedSlots: {
          for (final performance in result.performances) performance.slotNumber,
        },
        statusMessage:
            'OCR から ${result.performances.length} 組のライブと '
            '${result.merchandiseSlots.length} 件の物販を抽出しました。',
      );
    } on Object catch (error, stackTrace) {
      _logOcrFailure(
        imageName: image.name,
        error: error,
        stackTrace: stackTrace,
      );

      if (_isDisposed) {
        return;
      }

      state = state.copyWith(statusMessage: 'OCR に失敗しました: $error');
    } finally {
      if (!_isDisposed) {
        state = state.copyWith(isBusy: false);
      }
    }
  }

  /// Updates whether a timetable slot is selected.
  void setSlotSelected({
    required int slotNumber,
    required bool isSelected,
  }) {
    final nextSelectedSlots = <int>{...state.selectedSlots};
    if (isSelected) {
      nextSelectedSlots.add(slotNumber);
    } else {
      nextSelectedSlots.remove(slotNumber);
    }

    state = state.copyWith(selectedSlots: nextSelectedSlots);
  }

  void _logOcrFailure({
    required String imageName,
    required Object error,
    required StackTrace stackTrace,
  }) {
    final message = 'OCR inspection failed for image "$imageName"';

    if (core.AppLogger.isInitialized) {
      ref.read(core.appLoggerProvider).error(message, error, stackTrace);
      return;
    }

    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app.timetable_scan',
        context: ErrorDescription(message),
      ),
    );
  }
}
