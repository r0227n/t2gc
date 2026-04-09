import 'package:flutter/foundation.dart';

/// A writable Google Calendar option shown in the UI.
@immutable
class GoogleCalendarSummary {
  /// Creates a Google Calendar summary.
  const GoogleCalendarSummary({
    required this.id,
    required this.summary,
    this.isPrimary = false,
  });

  /// Calendar identifier used by the Google Calendar API.
  final String id;

  /// Display name for the calendar.
  final String summary;

  /// Whether this is the user's primary calendar.
  final bool isPrimary;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is GoogleCalendarSummary && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
