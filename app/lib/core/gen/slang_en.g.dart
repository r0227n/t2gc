///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'slang.g.dart';

// Path: <root>
class TranslationsEn
    with BaseTranslations<AppLocale, Translations>
    implements Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsEn _root = this; // ignore: unused_field

  @override
  TranslationsEn $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsEn(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsAppEn app = _TranslationsAppEn._(_root);
  @override
  late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(
    _root,
  );
  @override
  late final _TranslationsTimetableScanEn timetableScan =
      _TranslationsTimetableScanEn._(_root);
}

// Path: app
class _TranslationsAppEn implements TranslationsAppJa {
  _TranslationsAppEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Timetable OCR';
  @override
  String get shellTitle => 'Timetable to Google Calendar';
  @override
  String get settingsTooltip => 'Settings';
}

// Path: settings
class _TranslationsSettingsEn implements TranslationsSettingsJa {
  _TranslationsSettingsEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Settings';
  @override
  String get language => 'Language';
  @override
  String get theme => 'Theme';
  @override
  String get version => 'Version';
  @override
  String get licenses => 'Licenses';
  @override
  late final _TranslationsSettingsSectionsEn sections =
      _TranslationsSettingsSectionsEn._(_root);
}

// Path: timetableScan
class _TranslationsTimetableScanEn implements TranslationsTimetableScanJa {
  _TranslationsTimetableScanEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsTimetableScanWarningsEn warnings =
      _TranslationsTimetableScanWarningsEn._(_root);
  @override
  late final _TranslationsTimetableScanPerformanceListEn performanceList =
      _TranslationsTimetableScanPerformanceListEn._(_root);
  @override
  late final _TranslationsTimetableScanHeroEn hero =
      _TranslationsTimetableScanHeroEn._(_root);
  @override
  late final _TranslationsTimetableScanOcrDebugEn ocrDebug =
      _TranslationsTimetableScanOcrDebugEn._(_root);
  @override
  late final _TranslationsTimetableScanStatusEn status =
      _TranslationsTimetableScanStatusEn._(_root);
  @override
  late final _TranslationsTimetableScanFormattersEn formatters =
      _TranslationsTimetableScanFormattersEn._(_root);
}

// Path: settings.sections
class _TranslationsSettingsSectionsEn
    implements TranslationsSettingsSectionsJa {
  _TranslationsSettingsSectionsEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get appSettings => 'App Settings';
  @override
  String get other => 'Other';
}

// Path: timetableScan.warnings
class _TranslationsTimetableScanWarningsEn
    implements TranslationsTimetableScanWarningsJa {
  _TranslationsTimetableScanWarningsEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get needsReview => 'Needs review';
}

// Path: timetableScan.performanceList
class _TranslationsTimetableScanPerformanceListEn
    implements TranslationsTimetableScanPerformanceListJa {
  _TranslationsTimetableScanPerformanceListEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get emptyState =>
      'Detected events will appear here once a timetable is scanned.';
  @override
  String get heading => 'EVENT DETAILS';
  @override
  String get selectAll => 'Select all';
  @override
  String slotLabel({required Object slotNumber}) => 'SLOT ${slotNumber}';
  @override
  String get liveTime => 'Live Time';
  @override
  String get merchEventTime => 'Merch/Event Time';
  @override
  String get notAvailable => 'N/A';
  @override
  String get editDetails => 'Edit Details';
  @override
  String get editingComingSoon => 'Editing is coming soon.';
  @override
  String get selectedOne => '1 Event Selected';
  @override
  String selectedMany({required Object count}) => '${count} Events Selected';
  @override
  String get addingToCalendar => 'Adding to "Summer Festival 2024" calendar';
  @override
  String get addSelectedToGoogleCalendar => 'Add selected to Google Calendar';
  @override
  String get calendarIntegrationComingSoon =>
      'Google Calendar integration ships in a later release.';
}

// Path: timetableScan.hero
class _TranslationsTimetableScanHeroEn
    implements TranslationsTimetableScanHeroJa {
  _TranslationsTimetableScanHeroEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get selectedImagePreview => 'Selected image preview';
  @override
  String get clearSelectedImageTooltip => 'Clear selected image';
  @override
  String get dropTimetableImageHere => 'Drop your timetable image here';
  @override
  String get analyzing => 'Analyzing…';
  @override
  String get browseFiles => 'Browse Files';
  @override
  String get selectedOne => '1 event detected.';
  @override
  String selectedMany({required Object count}) => '${count} events detected.';
}

// Path: timetableScan.ocrDebug
class _TranslationsTimetableScanOcrDebugEn
    implements TranslationsTimetableScanOcrDebugJa {
  _TranslationsTimetableScanOcrDebugEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'OCR debug text';
  @override
  String get subtitle => 'Raw text before parsing';
}

// Path: timetableScan.status
class _TranslationsTimetableScanStatusEn
    implements TranslationsTimetableScanStatusJa {
  _TranslationsTimetableScanStatusEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get chooseImage => 'Choose an image to start OCR extraction.';
  @override
  String get runningOcr => 'Running OCR and parsing the timetable…';
  @override
  String get loadingScenario => 'Loading validation scenario…';
  @override
  String get selectionCanceled => 'Image selection was canceled.';
  @override
  String get noSupportedRows => 'No supported timetable rows were detected.';
  @override
  String extractedCounts({
    required Object liveCount,
    required Object merchCount,
  }) =>
      'Extracted ${liveCount} live set(s) and ${merchCount} merchandise slot(s) from OCR.';
  @override
  String get oneItemNeedsReview => '1 item needs review.';
  @override
  String manyItemsNeedReview({required Object count}) =>
      '${count} items need review.';
  @override
  String ocrFailed({required Object error}) => 'OCR failed: ${error}';
  @override
  String get ocrEngineInitializationFailed =>
      'Failed to initialize the OCR engine.';
  @override
  String ocrInspectionFailedForImage({required Object imageName}) =>
      'OCR inspection failed for image "${imageName}"';
}

// Path: timetableScan.formatters
class _TranslationsTimetableScanFormattersEn
    implements TranslationsTimetableScanFormattersJa {
  _TranslationsTimetableScanFormattersEn._(this._root);

  final TranslationsEn _root; // ignore: unused_field

  // Translations
  @override
  String get monday => 'Mon';
  @override
  String get tuesday => 'Tue';
  @override
  String get wednesday => 'Wed';
  @override
  String get thursday => 'Thu';
  @override
  String get friday => 'Fri';
  @override
  String get saturday => 'Sat';
  @override
  String get sunday => 'Sun';
  @override
  String get afterShowMerchandise => 'After-show merchandise';
  @override
  String merchandiseBooth({required Object boothLabel}) =>
      'Merch ${boothLabel}';
  @override
  String get liveType => 'Live';
  @override
  String get merchandiseType => 'Merchandise';
}
