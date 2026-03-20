import 'dart:async';

import 'package:app/core/gen/slang.g.dart' as app;
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

    /// Indices into [scanResult!.schedules] for selected rows.
    ///
    /// Each checkbox is independent.
    @Default(<int>{}) Set<int> selectedSlotIndices,
  }) = _TimetableScanState;

  /// Creates the timetable screen state.
  const TimetableScanState._();

  /// Initial guidance shown before OCR starts.
  static const initialStatusMessage = '';
}

/// Controls OCR execution and selection state for the timetable screen.
@riverpod
class TimetableScanController extends _$TimetableScanController {
  var _isDisposed = false;
  var _activeInspectionId = 0;

  @override
  TimetableScanState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
    });

    return TimetableScanState(
      statusMessage: app.t.timetableScan.status.chooseImage,
    );
  }

  /// Prompts the user to select an image and runs OCR against it.
  Future<void> inspectFromGallery() async {
    final image = await ref
        .read(timetableImagePickerServiceProvider)
        .pickImageFromGallery();

    if (image == null) {
      _applySelectionCanceledState();
      return;
    }

    final inspectionId = ++_activeInspectionId;

    state = state.copyWith(
      imageBytes: image.bytes,
      imageName: image.name,
      isBusy: true,
      scanResult: null,
      selectedSlotIndices: const <int>{},
      statusMessage: app.t.timetableScan.status.runningOcr,
    );

    try {
      final result = await ref
          .read(scanTimetableImageUseCaseProvider)
          .call(imageBytes: image.bytes, imageName: image.name);

      if (_isDisposed || inspectionId != _activeInspectionId) {
        return;
      }

      final indices = {
        for (var i = 0; i < result.schedules.length; i++) i,
      };
      state = state.copyWith(
        scanResult: result,
        selectedSlotIndices: indices,
        statusMessage: _statusMessageFor(result),
      );
    } on Object catch (error, stackTrace) {
      _logOcrFailure(
        imageName: image.name,
        error: error,
        stackTrace: stackTrace,
      );

      if (_isDisposed || inspectionId != _activeInspectionId) {
        return;
      }

      state = state.copyWith(
        statusMessage: app.t.timetableScan.status.ocrFailed(
          error: error,
        ),
      );
    } finally {
      if (!_isDisposed && inspectionId == _activeInspectionId) {
        state = state.copyWith(isBusy: false);
      }
    }
  }

  /// Cancels the current OCR flow and clears the selected image and result.
  void clearSelection() {
    _activeInspectionId++;
    state = const TimetableScanState();
  }

  /// Updates whether the schedule at [index] is selected.
  ///
  /// Each row checkbox is independent.
  void setSlotSelected({
    required int index,
    required bool isSelected,
  }) {
    final next = <int>{...state.selectedSlotIndices};
    if (isSelected) {
      next.add(index);
    } else {
      next.remove(index);
    }
    state = state.copyWith(selectedSlotIndices: next);
  }

  /// Selects all parsed schedule rows.
  void selectAllSlots() {
    final result = state.scanResult;
    if (result == null) {
      return;
    }
    state = state.copyWith(
      selectedSlotIndices: {
        for (var i = 0; i < result.schedules.length; i++) i,
      },
    );
  }

  /// Clears all slot selection.
  void clearAllSlots() {
    state = state.copyWith(selectedSlotIndices: const <int>{});
  }

  void _applySelectionCanceledState() {
    state = state.copyWith(
      statusMessage: app.t.timetableScan.status.selectionCanceled,
      isBusy: false,
      imageBytes: null,
      imageName: '',
      scanResult: null,
      selectedSlotIndices: const <int>{},
    );
  }

  String _statusMessageFor(TimetableScanResult result) {
    if (!result.hasPerformances) {
      return app.t.timetableScan.status.noSupportedRows;
    }

    final warningCount = result.warnings.length;
    final reviewMessage = warningCount == 1
        ? app.t.timetableScan.status.oneItemNeedsReview
        : app.t.timetableScan.status.manyItemsNeedReview(
            count: warningCount,
          );
    final warningSuffix = warningCount == 0 ? '' : ' $reviewMessage';
    final extractedCounts = app.t.timetableScan.status.extractedCounts(
      liveCount: result.performances.length,
      merchCount: result.merchandiseSlots.length,
    );
    return '$extractedCounts$warningSuffix';
  }

  void _logOcrFailure({
    required String imageName,
    required Object error,
    required StackTrace stackTrace,
  }) {
    final message = app.t.timetableScan.status.ocrInspectionFailedForImage(
      imageName: imageName,
    );

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
