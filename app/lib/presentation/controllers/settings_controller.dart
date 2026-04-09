import 'dart:async';

import 'package:app/data/repositories/google_calendar_selection_repository.dart';
import 'package:app/data/services/google_calendar_service.dart';
import 'package:app/domain/models/google_calendar_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Exposes the settings state to the presentation layer.
final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(
      SettingsController.new,
    );

/// Immutable view state for the settings screen.
@immutable
class SettingsState {
  /// Creates the settings state.
  const SettingsState({
    this.account,
    this.calendars = const <GoogleCalendarSummary>[],
    this.selectedCalendar,
    this.errorMessage,
    this.isInitializing = true,
    this.isBusy = false,
    this.isLoadingCalendars = false,
  });

  /// The currently signed-in Google account, if any.
  final GoogleSignInAccount? account;

  /// Writable calendars returned from the Calendar API.
  final List<GoogleCalendarSummary> calendars;

  /// The selected destination calendar.
  final GoogleCalendarSummary? selectedCalendar;

  /// Human-readable error text for the settings screen.
  final String? errorMessage;

  /// Whether initial Google auth restoration is in progress.
  final bool isInitializing;

  /// Whether sign-in or sign-out is running.
  final bool isBusy;

  /// Whether calendar list loading is running.
  final bool isLoadingCalendars;

  /// Whether a Google account is currently signed in.
  bool get isSignedIn => account != null;

  /// Whether at least one writable calendar is available.
  bool get hasCalendars => calendars.isNotEmpty;

  /// Returns a copy of this state with selected fields replaced.
  SettingsState copyWith({
    GoogleSignInAccount? account,
    List<GoogleCalendarSummary>? calendars,
    GoogleCalendarSummary? selectedCalendar,
    String? errorMessage,
    bool clearSelectedCalendar = false,
    bool clearErrorMessage = false,
    bool? isInitializing,
    bool? isBusy,
    bool? isLoadingCalendars,
  }) {
    return SettingsState(
      account: account ?? this.account,
      calendars: calendars ?? this.calendars,
      selectedCalendar: clearSelectedCalendar
          ? null
          : selectedCalendar ?? this.selectedCalendar,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isInitializing: isInitializing ?? this.isInitializing,
      isBusy: isBusy ?? this.isBusy,
      isLoadingCalendars: isLoadingCalendars ?? this.isLoadingCalendars,
    );
  }
}

/// Manages Google OAuth state and destination calendar selection.
class SettingsController extends Notifier<SettingsState> {
  late final GoogleCalendarService _calendarService;
  late final GoogleCalendarSelectionRepository _selectionRepository;

  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  var _didKickoffInitialization = false;

  @override
  SettingsState build() {
    _calendarService = ref.watch(googleCalendarServiceProvider);
    _selectionRepository = ref.watch(googleCalendarSelectionRepositoryProvider);

    ref.onDispose(() {
      unawaited(_authSubscription?.cancel());
    });

    if (!_didKickoffInitialization) {
      _didKickoffInitialization = true;
      unawaited(_initialize());
    }

    return SettingsState(
      selectedCalendar: _selectionRepository.getSelectedCalendar(),
    );
  }

  /// Starts an interactive Google OAuth sign-in flow.
  Future<void> signIn() async {
    state = state.copyWith(
      isBusy: true,
      clearErrorMessage: true,
    );

    try {
      final user = await _calendarService.signIn();
      await _refreshFromSignedInUser(user);
    } on Object catch (error) {
      state = state.copyWith(
        isBusy: false,
        isInitializing: false,
        errorMessage: _toErrorMessage(error),
      );
    }
  }

  /// Disconnects the current Google account and clears the selection.
  Future<void> signOut() async {
    state = state.copyWith(
      isBusy: true,
      clearErrorMessage: true,
    );

    try {
      await _calendarService.signOut();
      await _selectionRepository.clearSelectedCalendar();
      state = const SettingsState(
        isInitializing: false,
      );
    } on Object catch (error) {
      state = state.copyWith(
        isBusy: false,
        isInitializing: false,
        errorMessage: _toErrorMessage(error),
      );
    }
  }

  /// Loads writable Google Calendars for the current user.
  Future<void> loadWritableCalendars() async {
    if (state.isLoadingCalendars) {
      return;
    }

    state = state.copyWith(
      isLoadingCalendars: true,
      clearErrorMessage: true,
    );

    try {
      final calendars = await _calendarService.listWritableCalendars();
      final selectedCalendar = _resolveSelectedCalendar(
        calendars: calendars,
        currentSelection: state.selectedCalendar,
      );

      if (selectedCalendar == null) {
        await _selectionRepository.clearSelectedCalendar();
      } else if (selectedCalendar.id != state.selectedCalendar?.id) {
        await _selectionRepository.setSelectedCalendar(selectedCalendar);
      }

      state = state.copyWith(
        calendars: calendars,
        selectedCalendar: selectedCalendar,
        isLoadingCalendars: false,
        isInitializing: false,
      );
    } on Object catch (error) {
      state = state.copyWith(
        isLoadingCalendars: false,
        isInitializing: false,
        errorMessage: _toErrorMessage(error),
      );
    }
  }

  /// Persists the selected Google Calendar.
  Future<void> selectCalendar(GoogleCalendarSummary calendar) async {
    await _selectionRepository.setSelectedCalendar(calendar);
    state = state.copyWith(selectedCalendar: calendar);
  }

  Future<void> _initialize() async {
    _authSubscription ??= _calendarService.authenticationEvents.listen(
      _handleAuthenticationEvent,
      onError: _handleAuthenticationError,
    );

    try {
      final user = await _calendarService.restoreAuthenticatedUser();
      if (user == null) {
        state = state.copyWith(
          isInitializing: false,
          isBusy: false,
          clearErrorMessage: true,
        );
        return;
      }

      await _refreshFromSignedInUser(user);
    } on Object catch (error) {
      state = state.copyWith(
        isInitializing: false,
        isBusy: false,
        errorMessage: _toErrorMessage(error),
      );
    }
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    switch (event) {
      case GoogleSignInAuthenticationEventSignIn():
        await _refreshFromSignedInUser(event.user);
      case GoogleSignInAuthenticationEventSignOut():
        await _selectionRepository.clearSelectedCalendar();
        state = const SettingsState(
          isInitializing: false,
        );
    }
  }

  void _handleAuthenticationError(Object error) {
    state = state.copyWith(
      isInitializing: false,
      isBusy: false,
      isLoadingCalendars: false,
      errorMessage: _toErrorMessage(error),
    );
  }

  Future<void> _refreshFromSignedInUser(GoogleSignInAccount user) async {
    state = state.copyWith(
      account: user,
      isBusy: false,
      isInitializing: false,
    );
    await loadWritableCalendars();
    state = state.copyWith(account: user, isBusy: false);
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

  String _toErrorMessage(Object error) {
    if (error is GoogleCalendarNotConfiguredException) {
      return 'oauth_configuration_missing';
    }
    return error.toString();
  }
}
