import 'dart:convert';

import 'package:app/domain/models/google_calendar_summary.dart';
import 'package:core/core.dart' as core;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to the selected Google Calendar preference.
final googleCalendarSelectionRepositoryProvider =
    Provider<GoogleCalendarSelectionRepository>((ref) {
      final prefs = ref.read(core.sharedPreferencesProvider);
      return GoogleCalendarSelectionRepository(prefs: prefs);
    });

/// Stores the Google Calendar selected by the user.
class GoogleCalendarSelectionRepository {
  /// Creates a Google Calendar selection repository.
  GoogleCalendarSelectionRepository({required SharedPreferences prefs})
    : _prefs = prefs;

  static const _selectedCalendarKey = 'selected_google_calendar';

  final SharedPreferences _prefs;

  /// Returns the stored calendar selection if one exists.
  GoogleCalendarSummary? getSelectedCalendar() {
    final raw = _prefs.getString(_selectedCalendarKey);
    if (raw == null) {
      return null;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return GoogleCalendarSummary(
        id: json['id'] as String,
        summary: json['summary'] as String,
        isPrimary: json['isPrimary'] as bool? ?? false,
      );
    } on Object {
      return null;
    }
  }

  /// Persists the selected calendar.
  Future<void> setSelectedCalendar(GoogleCalendarSummary calendar) async {
    await _prefs.setString(
      _selectedCalendarKey,
      jsonEncode({
        'id': calendar.id,
        'summary': calendar.summary,
        'isPrimary': calendar.isPrimary,
      }),
    );
  }

  /// Clears the stored calendar selection.
  Future<void> clearSelectedCalendar() async {
    await _prefs.remove(_selectedCalendarKey);
  }
}
