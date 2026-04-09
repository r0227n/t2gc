import 'dart:async';

import 'package:app/core/gen/slang.g.dart' as app;
import 'package:app/data/models/selected_timetable_image.dart';
import 'package:app/data/repositories/google_calendar_selection_repository.dart';
import 'package:app/data/services/google_calendar_service.dart';
import 'package:app/data/services/timetable_image_picker_service.dart';
import 'package:app/domain/models/google_calendar_summary.dart';
import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_calendar_entry.dart';
import 'package:app/domain/models/timetable_metadata.dart';
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
    @Default(false) bool isLoadingCalendars,
    @Default(<GoogleCalendarSummary>[]) List<GoogleCalendarSummary> calendars,
    GoogleCalendarSummary? selectedCalendar,

    /// Indices into [scanResult!.schedules] for selected rows.
    ///
    /// Each checkbox is independent.
    @Default(<int>{}) Set<int> selectedSlotIndices,
    String? snackBarMessage,
    @Default(false) bool snackBarIsError,
    @Default(0) int snackBarSerial,
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
    final selectedCalendar = ref
        .read(googleCalendarSelectionRepositoryProvider)
        .getSelectedCalendar();

    return TimetableScanState(
      statusMessage: app.t.timetableScan.status.chooseImage,
      selectedCalendar: selectedCalendar,
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

    await inspectImage(image);
  }

  /// Runs OCR against an already selected image payload.
  Future<void> inspectImage(SelectedTimetableImage image) async {
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
    state = state.copyWith(
      imageBytes: null,
      imageName: '',
      statusMessage: app.t.timetableScan.status.chooseImage,
      isBusy: false,
      scanResult: null,
      selectedSlotIndices: const <int>{},
    );
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

  /// Adds the selected timetable rows to Google Calendar.
  Future<void> addSelectedToGoogleCalendar() async {
    final result = state.scanResult;
    if (result == null) {
      return;
    }

    final entries = _selectedCalendarEntries(result);
    if (entries.isEmpty) {
      return;
    }
    final selectedCount = _selectedScheduleCount(result);

    try {
      if (state.selectedCalendar != null && state.calendars.isEmpty) {
        await loadWritableCalendars();
        if (_isDisposed) {
          return;
        }
      }
      final calendarId = state.selectedCalendar?.id;
      await ref
          .read(googleCalendarServiceProvider)
          .addEntries(
            entries: entries,
            timeZoneId: result.metadata.timeZoneId,
            calendarId: calendarId,
          );
      if (_isDisposed) {
        return;
      }
      _pushSnackBar(
        message: app.t.timetableScan.performanceList.calendarSyncSucceeded(
          count: selectedCount,
        ),
      );
    } on GoogleCalendarNotConfiguredException {
      final message =
          app.t.timetableScan.performanceList.calendarClientNotConfigured;
      state = state.copyWith(statusMessage: message);
      _pushSnackBar(message: message, isError: true);
    } on Object catch (error, stackTrace) {
      _logCalendarSyncFailure(error: error, stackTrace: stackTrace);
      final message = app.t.timetableScan.performanceList.calendarSyncFailed(
        error: error,
      );
      state = state.copyWith(statusMessage: message);
      _pushSnackBar(message: message, isError: true);
    }
  }

  /// Loads writable calendars from Google Calendar API.
  Future<void> loadWritableCalendars() async {
    if (state.isLoadingCalendars) {
      return;
    }

    final selectionRepository = ref.read(
      googleCalendarSelectionRepositoryProvider,
    );
    final currentSelection = state.selectedCalendar;
    state = state.copyWith(isLoadingCalendars: true);
    try {
      final calendars = await ref
          .read(googleCalendarServiceProvider)
          .listWritableCalendars();
      if (_isDisposed) {
        return;
      }
      final selectedCalendar = _resolveSelectedCalendar(
        calendars: calendars,
        currentSelection: currentSelection,
      );
      if (selectedCalendar == null) {
        await selectionRepository.clearSelectedCalendar();
      } else if (currentSelection?.id != selectedCalendar.id) {
        await selectionRepository.setSelectedCalendar(selectedCalendar);
      }

      state = state.copyWith(
        calendars: calendars,
        selectedCalendar: selectedCalendar,
      );
    } on GoogleCalendarNotConfiguredException {
      state = state.copyWith(
        statusMessage:
            app.t.timetableScan.performanceList.calendarClientNotConfigured,
      );
    } on Object catch (error, stackTrace) {
      _logCalendarSyncFailure(error: error, stackTrace: stackTrace);
      state = state.copyWith(
        statusMessage: app.t.timetableScan.performanceList.calendarListFailed(
          error: error,
        ),
      );
    } finally {
      if (!_isDisposed) {
        state = state.copyWith(isLoadingCalendars: false);
      }
    }
  }

  /// Persists the selected Google Calendar.
  Future<void> selectCalendar(GoogleCalendarSummary calendar) async {
    await ref
        .read(googleCalendarSelectionRepositoryProvider)
        .setSelectedCalendar(calendar);
    if (_isDisposed) {
      return;
    }
    state = state.copyWith(selectedCalendar: calendar);
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

  GoogleCalendarSummary? _resolveSelectedCalendar({
    required List<GoogleCalendarSummary> calendars,
    required GoogleCalendarSummary? currentSelection,
  }) {
    if (calendars.isEmpty) {
      return null;
    }

    if (currentSelection case final selection?) {
      for (final calendar in calendars) {
        if (calendar.id == selection.id) {
          return calendar;
        }
      }
    }

    for (final calendar in calendars) {
      if (calendar.isPrimary) {
        return calendar;
      }
    }

    return calendars.first;
  }

  List<TimetableCalendarEntry> _selectedCalendarEntries(
    TimetableScanResult result,
  ) {
    final selectedIndices = state.selectedSlotIndices.toList()..sort();
    return [
      for (final index in selectedIndices)
        if (index >= 0 && index < result.schedules.length)
          ..._calendarEntriesForSchedule(
            metadata: result.metadata,
            schedule: result.schedules[index],
          ),
    ];
  }

  int _selectedScheduleCount(TimetableScanResult result) {
    return state.selectedSlotIndices.where((index) {
      return index >= 0 && index < result.schedules.length;
    }).length;
  }

  List<TimetableCalendarEntry> _calendarEntriesForSchedule({
    required TimetableMetadata metadata,
    required TimetableArtistSchedule schedule,
  }) {
    final liveEntry = TimetableCalendarEntry(
      slotNumber: schedule.slotNumber,
      artistName: schedule.artistName,
      type: TimetableCalendarEntryType.live,
      title:
          '${schedule.artistName} ${app.t.timetableScan.formatters.liveType}',
      description: _buildLiveDescription(
        metadata: metadata,
        schedule: schedule,
      ),
      location: metadata.venueName,
      startAt: schedule.performance.startAt,
      endAt: schedule.performance.endAt,
    );

    final merchandise = schedule.merchandise;
    if (merchandise == null) {
      return [liveEntry];
    }

    return [
      liveEntry,
      TimetableCalendarEntry(
        slotNumber: schedule.slotNumber,
        artistName: schedule.artistName,
        type: TimetableCalendarEntryType.merchandise,
        title:
            '${schedule.artistName} '
            '${app.t.timetableScan.formatters.merchandiseType}',
        description: _buildMerchandiseDescription(
          metadata: metadata,
          schedule: schedule,
        ),
        location: _merchandiseLocation(
          venueName: metadata.venueName,
          boothLabel: merchandise.boothLabel,
          isAfterShow: merchandise.isAfterShow,
        ),
        startAt: merchandise.startAt,
        endAt: merchandise.endAt,
      ),
    ];
  }

  String _buildLiveDescription({
    required TimetableMetadata metadata,
    required TimetableArtistSchedule schedule,
  }) {
    final merchandiseText = switch (schedule.merchandise) {
      final merchandise? => merchandise.sourceText,
      null => app.t.timetableScan.performanceList.notAvailable,
    };
    return [
      metadata.eventTitle,
      schedule.performance.sourceText,
      merchandiseText,
    ].join('\n');
  }

  String _buildMerchandiseDescription({
    required TimetableMetadata metadata,
    required TimetableArtistSchedule schedule,
  }) {
    final merchandise = schedule.merchandise;
    if (merchandise == null) {
      return [
        metadata.eventTitle,
        schedule.performance.sourceText,
      ].join('\n');
    }

    return [
      metadata.eventTitle,
      schedule.performance.sourceText,
      merchandise.sourceText,
    ].join('\n');
  }

  String _merchandiseLocation({
    required String venueName,
    required String? boothLabel,
    required bool isAfterShow,
  }) {
    if (isAfterShow) {
      return '$venueName '
          '${app.t.timetableScan.formatters.afterShowMerchandise}';
    }
    if (boothLabel == null || boothLabel.isEmpty) {
      return venueName;
    }
    return '$venueName '
        '${app.t.timetableScan.formatters.merchandiseBooth(
          boothLabel: boothLabel,
        )}';
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

  void _logCalendarSyncFailure({
    required Object error,
    required StackTrace stackTrace,
  }) {
    const message =
        'Failed to add selected timetable events to Google Calendar.';

    if (core.AppLogger.isInitialized) {
      ref.read(core.appLoggerProvider).error(message, error, stackTrace);
      return;
    }

    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app.google_calendar',
        context: ErrorDescription(message),
      ),
    );
  }

  void _pushSnackBar({
    required String message,
    bool isError = false,
  }) {
    if (_isDisposed) {
      return;
    }
    state = state.copyWith(
      snackBarMessage: message,
      snackBarIsError: isError,
      snackBarSerial: state.snackBarSerial + 1,
    );
  }
}
