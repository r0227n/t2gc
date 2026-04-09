///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'slang.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
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
             locale: AppLocale.ja,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsAppJa app = TranslationsAppJa._(_root);
  late final TranslationsSettingsJa settings = TranslationsSettingsJa._(_root);
  late final TranslationsTimetableScanJa timetableScan =
      TranslationsTimetableScanJa._(_root);
}

// Path: app
class TranslationsAppJa {
  TranslationsAppJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '設定'
  String get settingsTooltip => '設定';
}

// Path: settings
class TranslationsSettingsJa {
  TranslationsSettingsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '設定'
  String get title => '設定';

  /// ja: '言語'
  String get language => '言語';

  /// ja: 'テーマ'
  String get theme => 'テーマ';

  /// ja: 'バージョン'
  String get version => 'バージョン';

  /// ja: 'ライセンス'
  String get licenses => 'ライセンス';

  late final TranslationsSettingsSectionsJa sections =
      TranslationsSettingsSectionsJa._(_root);
}

// Path: timetableScan
class TranslationsTimetableScanJa {
  TranslationsTimetableScanJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsTimetableScanWarningsJa warnings =
      TranslationsTimetableScanWarningsJa._(_root);
  late final TranslationsTimetableScanPerformanceListJa performanceList =
      TranslationsTimetableScanPerformanceListJa._(_root);
  late final TranslationsTimetableScanHeroJa hero =
      TranslationsTimetableScanHeroJa._(_root);
  late final TranslationsTimetableScanOcrDebugJa ocrDebug =
      TranslationsTimetableScanOcrDebugJa._(_root);
  late final TranslationsTimetableScanStatusJa status =
      TranslationsTimetableScanStatusJa._(_root);
  late final TranslationsTimetableScanFormattersJa formatters =
      TranslationsTimetableScanFormattersJa._(_root);
}

// Path: settings.sections
class TranslationsSettingsSectionsJa {
  TranslationsSettingsSectionsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'アプリ設定'
  String get appSettings => 'アプリ設定';

  /// ja: 'その他'
  String get other => 'その他';
}

// Path: timetableScan.warnings
class TranslationsTimetableScanWarningsJa {
  TranslationsTimetableScanWarningsJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '要確認'
  String get needsReview => '要確認';
}

// Path: timetableScan.performanceList
class TranslationsTimetableScanPerformanceListJa {
  TranslationsTimetableScanPerformanceListJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'タイムテーブルを読み込むと検出されたイベントがここに表示されます。'
  String get emptyState => 'タイムテーブルを読み込むと検出されたイベントがここに表示されます。';

  /// ja: 'イベント詳細'
  String get heading => 'イベント詳細';

  /// ja: 'すべて選択'
  String get selectAll => 'すべて選択';

  /// ja: 'SLOT {slotNumber}'
  String slotLabel({required Object slotNumber}) => 'SLOT ${slotNumber}';

  /// ja: 'ライブ時間'
  String get liveTime => 'ライブ時間';

  /// ja: '特典会 / イベント時間'
  String get merchEventTime => '特典会 / イベント時間';

  /// ja: 'N/A'
  String get notAvailable => 'N/A';

  /// ja: '詳細を編集'
  String get editDetails => '詳細を編集';

  /// ja: '編集機能は近日公開予定です。'
  String get editingComingSoon => '編集機能は近日公開予定です。';

  /// ja: '1 件のイベントを選択中'
  String get selectedOne => '1 件のイベントを選択中';

  /// ja: '{count} 件のイベントを選択中'
  String selectedMany({required Object count}) => '${count} 件のイベントを選択中';

  /// ja: '"{eventTitle}" のカレンダーに追加'
  String addingToCalendar({required Object eventTitle}) =>
      '"${eventTitle}" のカレンダーに追加';

  /// ja: '選択したイベントを Google カレンダーに追加'
  String get addSelectedToGoogleCalendar => '選択したイベントを Google カレンダーに追加';

  /// ja: 'Google カレンダー連携は次のリリースで対応予定です。'
  String get calendarIntegrationComingSoon => 'Google カレンダー連携は次のリリースで対応予定です。';

  /// ja: 'Google Calendar のクライアント ID が設定されていません。'
  String get calendarClientNotConfigured =>
      'Google Calendar のクライアント ID が設定されていません。';

  /// ja: 'Google カレンダーへの追加に失敗しました: {error}'
  String calendarSyncFailed({required Object error}) =>
      'Google カレンダーへの追加に失敗しました: ${error}';

  /// ja: 'Google カレンダー一覧の取得に失敗しました: {error}'
  String calendarListFailed({required Object error}) =>
      'Google カレンダー一覧の取得に失敗しました: ${error}';

  /// ja: '追加先カレンダー'
  String get calendarDestinationLabel => '追加先カレンダー';

  /// ja: '変更'
  String get changeCalendar => '変更';

  /// ja: 'カレンダーを読み込み中…'
  String get loadingCalendars => 'カレンダーを読み込み中…';

  /// ja: 'メインカレンダー'
  String get defaultCalendar => 'メインカレンダー';

  /// ja: '追加先カレンダーを選択'
  String get calendarSelectionTitle => '追加先カレンダーを選択';

  /// ja: '追加可能な Google カレンダーが見つかりませんでした。'
  String get noWritableCalendars => '追加可能な Google カレンダーが見つかりませんでした。';
}

// Path: timetableScan.hero
class TranslationsTimetableScanHeroJa {
  TranslationsTimetableScanHeroJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '選択した画像のプレビュー'
  String get selectedImagePreview => '選択した画像のプレビュー';

  /// ja: '選択した画像を削除'
  String get clearSelectedImageTooltip => '選択した画像を削除';

  /// ja: 'タイムテーブル画像をここにドロップ'
  String get dropTimetableImageHere => 'タイムテーブル画像をここにドロップ';

  /// ja: '解析中…'
  String get analyzing => '解析中…';

  /// ja: 'ファイルを選択'
  String get browseFiles => 'ファイルを選択';

  /// ja: '1 件のイベントを検出しました。'
  String get selectedOne => '1 件のイベントを検出しました。';

  /// ja: '{count} 件のイベントを検出しました。'
  String selectedMany({required Object count}) => '${count} 件のイベントを検出しました。';
}

// Path: timetableScan.ocrDebug
class TranslationsTimetableScanOcrDebugJa {
  TranslationsTimetableScanOcrDebugJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: 'OCR デバッグテキスト'
  String get title => 'OCR デバッグテキスト';

  /// ja: '解析前の生テキスト'
  String get subtitle => '解析前の生テキスト';
}

// Path: timetableScan.status
class TranslationsTimetableScanStatusJa {
  TranslationsTimetableScanStatusJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '画像を選択すると OCR 抽出を開始します。'
  String get chooseImage => '画像を選択すると OCR 抽出を開始します。';

  /// ja: 'タイムテーブルを OCR 解析中です…'
  String get runningOcr => 'タイムテーブルを OCR 解析中です…';

  /// ja: '検証シナリオを読み込み中です…'
  String get loadingScenario => '検証シナリオを読み込み中です…';

  /// ja: '画像の選択がキャンセルされました。'
  String get selectionCanceled => '画像の選択がキャンセルされました。';

  /// ja: '対応するタイムテーブル行を検出できませんでした。'
  String get noSupportedRows => '対応するタイムテーブル行を検出できませんでした。';

  /// ja: 'OCR からライブ {liveCount} 件と特典会 {merchCount} 件を抽出しました。'
  String extractedCounts({
    required Object liveCount,
    required Object merchCount,
  }) => 'OCR からライブ ${liveCount} 件と特典会 ${merchCount} 件を抽出しました。';

  /// ja: '1 件の確認が必要です。'
  String get oneItemNeedsReview => '1 件の確認が必要です。';

  /// ja: '{count} 件の確認が必要です。'
  String manyItemsNeedReview({required Object count}) => '${count} 件の確認が必要です。';

  /// ja: 'OCR に失敗しました: {error}'
  String ocrFailed({required Object error}) => 'OCR に失敗しました: ${error}';

  /// ja: 'OCR エンジンの初期化に失敗しました。'
  String get ocrEngineInitializationFailed => 'OCR エンジンの初期化に失敗しました。';

  /// ja: '画像 "{imageName}" の OCR 解析に失敗しました。'
  String ocrInspectionFailedForImage({required Object imageName}) =>
      '画像 "${imageName}" の OCR 解析に失敗しました。';
}

// Path: timetableScan.formatters
class TranslationsTimetableScanFormattersJa {
  TranslationsTimetableScanFormattersJa._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// ja: '月'
  String get monday => '月';

  /// ja: '火'
  String get tuesday => '火';

  /// ja: '水'
  String get wednesday => '水';

  /// ja: '木'
  String get thursday => '木';

  /// ja: '金'
  String get friday => '金';

  /// ja: '土'
  String get saturday => '土';

  /// ja: '日'
  String get sunday => '日';

  /// ja: '終演後物販'
  String get afterShowMerchandise => '終演後物販';

  /// ja: '物販 {boothLabel}'
  String merchandiseBooth({required Object boothLabel}) => '物販 ${boothLabel}';

  /// ja: 'ライブ'
  String get liveType => 'ライブ';

  /// ja: '物販'
  String get merchandiseType => '物販';
}
