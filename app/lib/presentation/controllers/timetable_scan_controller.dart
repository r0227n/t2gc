import 'dart:async';

import 'package:app/data/fixtures/timetable_debug_fixture.dart';
import 'package:app/data/services/timetable_image_picker_service.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/domain/services/supported_timetable_parser.dart';
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
    @Default('') String previewDescription,
    @Default(false) bool showAttachedSamplePreview,
    @Default(TimetableScanState.initialStatusMessage) String statusMessage,
    @Default(false) bool isBusy,
    TimetableScanResult? scanResult,
    /// Indices into [scanResult!.schedules] for selected rows (each checkbox independent).
    @Default(<int>{}) Set<int> selectedSlotIndices,
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
  var _bootstrappedQueryScenario = false;

  @override
  TimetableScanState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
    });

    if (!_bootstrappedQueryScenario) {
      _bootstrappedQueryScenario = true;
      final scenario = _scenarioFromQuery(Uri.base.queryParameters['scenario']);
      if (scenario != null) {
        unawaited(
          Future<void>.microtask(() async {
            switch (scenario) {
              case TimetableDebugScenario.attachedSample:
                await loadAttachedSample();
              case TimetableDebugScenario.partialMerchandise:
                await loadPartialMerchandiseSample();
              case TimetableDebugScenario.unsupportedFormat:
                await loadUnsupportedFormatSample();
              case TimetableDebugScenario.ocrFailure:
                await simulateOcrFailure();
              case TimetableDebugScenario.canceledSelection:
                simulateSelectionCanceled();
            }
          }),
        );
      }
    }

    return const TimetableScanState();
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

    state = state.copyWith(
      isBusy: true,
      previewDescription: '',
      showAttachedSamplePreview: false,
      statusMessage: 'OCR を実行してタイムテーブルを解析しています...',
    );

    try {
      final result = await ref
          .read(scanTimetableImageUseCaseProvider)
          .call(imageBytes: image.bytes, imageName: image.name);

      if (_isDisposed) {
        return;
      }

      final indices = {
        for (var i = 0; i < result.schedules.length; i++) i,
      };
      state = state.copyWith(
        imageBytes: image.bytes,
        imageName: image.name,
        previewDescription: '',
        showAttachedSamplePreview: false,
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

  /// Loads the deterministic attached timetable sample.
  Future<void> loadAttachedSample() async {
    await _loadDebugScenario(TimetableDebugScenario.attachedSample);
  }

  /// Loads a scenario where some merchandise slots are missing.
  Future<void> loadPartialMerchandiseSample() async {
    await _loadDebugScenario(TimetableDebugScenario.partialMerchandise);
  }

  /// Loads a scenario where the format is unsupported and zero rows parse.
  Future<void> loadUnsupportedFormatSample() async {
    await _loadDebugScenario(TimetableDebugScenario.unsupportedFormat);
  }

  /// Simulates a canceled image selection flow.
  void simulateSelectionCanceled() {
    _applySelectionCanceledState();
  }

  /// Simulates an OCR engine failure.
  Future<void> simulateOcrFailure() async {
    state = state.copyWith(
      isBusy: true,
      imageBytes: null,
      imageName: TimetableDebugFixture.attachedSampleImageName,
      previewDescription: TimetableDebugFixture.previewDescription(
        TimetableDebugScenario.ocrFailure,
      ),
      showAttachedSamplePreview: false,
      scanResult: null,
      selectedSlotIndices: const <int>{},
      statusMessage: 'OCR を実行してタイムテーブルを解析しています...',
    );

    try {
      throw StateError('OCR エンジンの初期化に失敗しました。');
    } on Object catch (error, stackTrace) {
      _logOcrFailure(
        imageName: TimetableDebugFixture.attachedSampleImageName,
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

  /// Updates whether the schedule at [index] is selected (each row independent).
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

  Future<void> _loadDebugScenario(TimetableDebugScenario scenario) async {
    state = state.copyWith(
      isBusy: true,
      imageBytes: null,
      imageName: TimetableDebugFixture.attachedSampleImageName,
      previewDescription: TimetableDebugFixture.previewDescription(scenario),
      showAttachedSamplePreview: TimetableDebugFixture.usesAttachedPreview(
        scenario,
      ),
      statusMessage: '検証用シナリオを読み込んでいます...',
    );

    try {
      final result = ref
          .read(supportedTimetableParserProvider)
          .parse(TimetableDebugFixture.ocrResult(scenario));

      if (_isDisposed) {
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
        imageName: TimetableDebugFixture.attachedSampleImageName,
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

  void _applySelectionCanceledState() {
    state = state.copyWith(
      statusMessage: '画像選択がキャンセルされました。',
      isBusy: false,
      imageBytes: null,
      imageName: '',
      previewDescription: TimetableDebugFixture.previewDescription(
        TimetableDebugScenario.canceledSelection,
      ),
      showAttachedSamplePreview: false,
      scanResult: null,
      selectedSlotIndices: const <int>{},
    );
  }

  String _statusMessageFor(TimetableScanResult result) {
    if (!result.hasPerformances) {
      return '対応フォーマットの行を検出できませんでした。';
    }

    final warningSuffix = result.warnings.isEmpty
        ? ''
        : ' 要確認 ${result.warnings.length} 件。';
    return 'OCR から ${result.performances.length} 組のライブと '
        '${result.merchandiseSlots.length} 件の物販を抽出しました。'
        '$warningSuffix';
  }

  TimetableDebugScenario? _scenarioFromQuery(String? value) {
    return switch (value) {
      'attached' => TimetableDebugScenario.attachedSample,
      'partial' => TimetableDebugScenario.partialMerchandise,
      'unsupported' => TimetableDebugScenario.unsupportedFormat,
      'failure' => TimetableDebugScenario.ocrFailure,
      'cancelled' || 'canceled' => TimetableDebugScenario.canceledSelection,
      _ => null,
    };
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
