/// Google Calendar API configuration loaded from compile-time defines.
class GoogleCalendarApiConfig {
  /// Creates a Google Calendar API configuration.
  const GoogleCalendarApiConfig({
    required this.clientId,
  });

  /// Creates a Google Calendar API configuration from `dart-define` values.
  const GoogleCalendarApiConfig.fromEnvironment()
    : clientId = const String.fromEnvironment(_clientIdDefineName);

  static const _clientIdDefineName = 'GOOGLE_CLIENT_ID';

  /// Google OAuth client ID for the web application.
  final String clientId;

  /// Whether the minimum configuration required for Calendar API access exists.
  bool get isConfigured => clientId.isNotEmpty;
}
