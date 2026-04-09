import 'package:app/core/config/google_calendar_api_config.dart';
import 'package:app/domain/models/google_calendar_summary.dart';
import 'package:app/domain/models/timetable_calendar_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

/// Provides the Google Calendar service used by the timetable flow.
final googleCalendarServiceProvider = Provider<GoogleCalendarService>((ref) {
  return GoogleCalendarService();
});

/// Raised when Google Calendar API credentials are missing.
class GoogleCalendarNotConfiguredException implements Exception {
  /// Creates a configuration exception.
  const GoogleCalendarNotConfiguredException();
}

/// Creates Google Calendar events from parsed timetable entries.
class GoogleCalendarService {
  /// Creates a Google Calendar service.
  GoogleCalendarService({
    GoogleCalendarApiConfig config =
        const GoogleCalendarApiConfig.fromEnvironment(),
    GoogleSignIn? googleSignIn,
    http.Client Function()? createHttpClient,
    DateTime Function()? clock,
    Future<void> Function({
      required List<TimetableCalendarEntry> entries,
      required String timeZoneId,
      String? calendarId,
    })?
    addEntriesOverride,
    Future<List<GoogleCalendarSummary>> Function()? listCalendarsOverride,
  }) : _config = config,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _createHttpClient = createHttpClient ?? http.Client.new,
       _clock = clock ?? DateTime.now,
       _addEntriesOverride = addEntriesOverride,
       _listCalendarsOverride = listCalendarsOverride;

  static const _defaultCalendarId = 'primary';

  static const _calendarScopes = <String>[
    calendar.CalendarApi.calendarCalendarlistReadonlyScope,
    calendar.CalendarApi.calendarEventsScope,
  ];

  final GoogleCalendarApiConfig _config;
  final GoogleSignIn _googleSignIn;
  final http.Client Function() _createHttpClient;
  final DateTime Function() _clock;
  final Future<void> Function({
    required List<TimetableCalendarEntry> entries,
    required String timeZoneId,
    String? calendarId,
  })?
  _addEntriesOverride;
  final Future<List<GoogleCalendarSummary>> Function()? _listCalendarsOverride;

  Future<void>? _initialization;

  /// Whether the minimum Google OAuth configuration is present.
  bool get isConfigured => _config.isConfigured;

  /// Whether this platform supports programmatic authentication.
  bool get supportsAuthenticate => _googleSignIn.supportsAuthenticate();

  /// Emits Google sign-in and sign-out events from the shared auth client.
  Stream<GoogleSignInAuthenticationEvent> get authenticationEvents =>
      _googleSignIn.authenticationEvents;

  /// Restores a previously authenticated Google user if possible.
  Future<GoogleSignInAccount?> restoreAuthenticatedUser() async {
    if (!_config.isConfigured) {
      return null;
    }

    await _ensureInitialized();
    final lightweightAuthentication = _googleSignIn
        .attemptLightweightAuthentication();
    if (lightweightAuthentication == null) {
      return null;
    }
    return lightweightAuthentication;
  }

  /// Starts an interactive Google OAuth sign-in flow.
  Future<GoogleSignInAccount> signIn() async {
    if (!_config.isConfigured) {
      throw const GoogleCalendarNotConfiguredException();
    }

    await _ensureInitialized();
    return _googleSignIn.authenticate(scopeHint: _calendarScopes);
  }

  /// Disconnects the active Google account.
  Future<void> signOut() async {
    if (!_config.isConfigured) {
      return;
    }

    await _ensureInitialized();
    await _googleSignIn.disconnect();
  }

  /// Inserts [entries] into the selected Google calendar.
  Future<void> addEntries({
    required List<TimetableCalendarEntry> entries,
    required String timeZoneId,
    String? calendarId,
  }) async {
    final addEntriesOverride = _addEntriesOverride;
    if (addEntriesOverride != null) {
      await addEntriesOverride(
        entries: entries,
        timeZoneId: timeZoneId,
        calendarId: calendarId,
      );
      return;
    }

    if (entries.isEmpty) {
      return;
    }
    if (!_config.isConfigured) {
      throw const GoogleCalendarNotConfiguredException();
    }

    await _ensureInitialized();
    await _insertEntries(
      entries: entries,
      timeZoneId: timeZoneId,
      calendarId: calendarId ?? _defaultCalendarId,
      allowReauthorization: true,
    );
  }

  /// Returns calendars the signed-in user can write events to.
  Future<List<GoogleCalendarSummary>> listWritableCalendars() async {
    final listCalendarsOverride = _listCalendarsOverride;
    if (listCalendarsOverride != null) {
      return listCalendarsOverride();
    }
    if (!_config.isConfigured) {
      throw const GoogleCalendarNotConfiguredException();
    }

    await _ensureInitialized();
    return _fetchWritableCalendars(allowReauthorization: true);
  }

  Future<void> _ensureInitialized() {
    return _initialization ??= _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    await _googleSignIn.initialize(clientId: _config.clientId);
    final lightweightAuthentication = _googleSignIn
        .attemptLightweightAuthentication();
    if (lightweightAuthentication != null) {
      await lightweightAuthentication;
    }
  }

  Future<void> _insertEntries({
    required List<TimetableCalendarEntry> entries,
    required String timeZoneId,
    required String calendarId,
    required bool allowReauthorization,
  }) async {
    final authorization = await _authorizeCalendarScopes();
    final authClient = _createAuthenticatedClient(authorization);

    try {
      final api = calendar.CalendarApi(authClient);
      for (final entry in entries) {
        await api.events.insert(
          _toCalendarEvent(entry, timeZoneId),
          calendarId,
        );
      }
    } on calendar.DetailedApiRequestError catch (error) {
      if (allowReauthorization && error.status == 401) {
        await _googleSignIn.authorizationClient.clearAuthorizationToken(
          accessToken: authorization.accessToken,
        );
        await _insertEntries(
          entries: entries,
          timeZoneId: timeZoneId,
          calendarId: calendarId,
          allowReauthorization: false,
        );
        return;
      }
      rethrow;
    } finally {
      authClient.close();
    }
  }

  Future<List<GoogleCalendarSummary>> _fetchWritableCalendars({
    required bool allowReauthorization,
  }) async {
    final authorization = await _authorizeCalendarScopes();
    final authClient = _createAuthenticatedClient(authorization);

    try {
      final api = calendar.CalendarApi(authClient);
      final response = await api.calendarList.list(
        minAccessRole: 'writer',
      );
      final items = response.items ?? const <calendar.CalendarListEntry>[];
      final calendars =
          [
            for (final item in items)
              if (item.id case final id? when id.isNotEmpty)
                GoogleCalendarSummary(
                  id: id,
                  summary: item.summaryOverride ?? item.summary ?? id,
                  isPrimary: item.primary ?? false,
                ),
          ]..sort((left, right) {
            if (left.isPrimary != right.isPrimary) {
              return left.isPrimary ? -1 : 1;
            }
            return left.summary.toLowerCase().compareTo(
              right.summary.toLowerCase(),
            );
          });
      return calendars;
    } on calendar.DetailedApiRequestError catch (error) {
      if (allowReauthorization && error.status == 401) {
        await _googleSignIn.authorizationClient.clearAuthorizationToken(
          accessToken: authorization.accessToken,
        );
        return _fetchWritableCalendars(allowReauthorization: false);
      }
      rethrow;
    } finally {
      authClient.close();
    }
  }

  Future<GoogleSignInClientAuthorization> _authorizeCalendarScopes() async {
    final authorizationClient = _googleSignIn.authorizationClient;
    return await authorizationClient.authorizationForScopes(_calendarScopes) ??
        authorizationClient.authorizeScopes(_calendarScopes);
  }

  auth.AuthClient _createAuthenticatedClient(
    GoogleSignInClientAuthorization authorization,
  ) {
    final credentials = auth.AccessCredentials(
      auth.AccessToken(
        'Bearer',
        authorization.accessToken,
        _clock().toUtc().add(const Duration(hours: 1)),
      ),
      null,
      _calendarScopes,
    );

    return auth.authenticatedClient(
      _createHttpClient(),
      credentials,
      closeUnderlyingClient: true,
    );
  }

  calendar.Event _toCalendarEvent(
    TimetableCalendarEntry entry,
    String timeZoneId,
  ) {
    return calendar.Event(
      summary: entry.title,
      description: entry.description,
      location: entry.location,
      start: calendar.EventDateTime(
        dateTime: _normalizeDateTime(entry.startAt, timeZoneId),
        timeZone: timeZoneId,
      ),
      end: calendar.EventDateTime(
        dateTime: _normalizeDateTime(entry.endAt, timeZoneId),
        timeZone: timeZoneId,
      ),
    );
  }

  DateTime _normalizeDateTime(DateTime value, String timeZoneId) {
    final offset = switch (timeZoneId) {
      'Asia/Tokyo' => const Duration(hours: 9),
      'UTC' => Duration.zero,
      _ => null,
    };
    if (offset == null) {
      return value;
    }

    return DateTime.utc(
      value.year,
      value.month,
      value.day,
      value.hour,
      value.minute,
      value.second,
      value.millisecond,
      value.microsecond,
    ).subtract(offset);
  }
}
