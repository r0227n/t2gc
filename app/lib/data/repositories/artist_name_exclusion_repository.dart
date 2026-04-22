import 'dart:convert';

import 'package:core/core.dart' as core;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to artist-name exclusion words used by OCR parsing.
final artistNameExclusionRepositoryProvider =
    Provider<ArtistNameExclusionRepository>((ref) {
      final prefs = ref.read(core.sharedPreferencesProvider);
      return ArtistNameExclusionRepository(prefs: prefs);
    });

/// Stores words that should be removed from artist names detected by OCR.
class ArtistNameExclusionRepository {
  /// Creates an artist-name exclusion repository.
  ArtistNameExclusionRepository({required SharedPreferences prefs})
    : _prefs = prefs;

  static const _excludedWordsKey = 'ocr_artist_name_excluded_words';

  final SharedPreferences _prefs;

  /// Returns the stored exclusion words.
  List<String> getExcludedWords() {
    final raw = _prefs.getString(_excludedWordsKey);
    if (raw == null) {
      return const <String>[];
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final words =
          (json['words'] as List<Object?>? ?? const <Object?>[])
              .whereType<String>()
              .map(_normalizeWord)
              .where((word) => word.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
      return List.unmodifiable(words);
    } on Object {
      return const <String>[];
    }
  }

  /// Persists the exclusion words as JSON.
  Future<void> setExcludedWords(List<String> words) async {
    final normalized =
        words
            .map(_normalizeWord)
            .where((word) => word.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    await _prefs.setString(
      _excludedWordsKey,
      jsonEncode(<String, Object>{
        'words': normalized,
      }),
    );
  }

  String _normalizeWord(String value) {
    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
