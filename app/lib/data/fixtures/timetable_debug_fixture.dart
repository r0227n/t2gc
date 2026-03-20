import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';

/// Deterministic debug scenarios used to validate the first OCR scaffold.
enum TimetableDebugScenario {
  /// Loads the attached timetable sample end to end.
  attachedSample,

  /// Loads a sample where some merchandise rows are unreadable.
  partialMerchandise,

  /// Loads a sample with no supported timetable rows.
  unsupportedFormat,

  /// Simulates a hard OCR failure.
  ocrFailure,

  /// Simulates canceling image selection before OCR runs.
  canceledSelection,
}

/// Test fixture metadata for timetable debug scenarios.
final class TimetableDebugFixture {
  const TimetableDebugFixture._();

  /// Image name displayed in the preview card for the attached sample.
  static const attachedSampleImageName = 'attached_idol_koshien_day2.png';

  /// Returns the visible button label for each validation scenario.
  static String buttonLabel(TimetableDebugScenario scenario) {
    return switch (scenario) {
      TimetableDebugScenario.attachedSample => '添付サンプルを読み込む',
      TimetableDebugScenario.partialMerchandise => '特典会欠損を再現',
      TimetableDebugScenario.unsupportedFormat => '解析0件を再現',
      TimetableDebugScenario.ocrFailure => 'OCR失敗を再現',
      TimetableDebugScenario.canceledSelection => '画像未選択を再現',
    };
  }

  /// Returns a short status label for the preview area.
  static String previewDescription(TimetableDebugScenario scenario) {
    return switch (scenario) {
      TimetableDebugScenario.attachedSample => '添付タイムテーブルをもとにした検証用プレビュー',
      TimetableDebugScenario.partialMerchandise => '特典会時間の欠損を含む検証シナリオ',
      TimetableDebugScenario.unsupportedFormat => '対応フォーマット外の画像を想定した検証シナリオ',
      TimetableDebugScenario.ocrFailure => 'OCRエンジン失敗を想定した検証シナリオ',
      TimetableDebugScenario.canceledSelection => '画像選択キャンセルを想定した検証シナリオ',
    };
  }

  /// Whether the stylized attached-image preview should be rendered.
  static bool usesAttachedPreview(TimetableDebugScenario scenario) {
    return scenario == TimetableDebugScenario.attachedSample;
  }

  /// Returns the raw OCR fixture used by the parser for a scenario.
  static NdlocrResult ocrResult(TimetableDebugScenario scenario) {
    return switch (scenario) {
      TimetableDebugScenario.attachedSample => const NdlocrResult(
        text: _attachedSampleRawText,
        imageSize: NdlocrImageSize(width: 1368, height: 1782),
        lines: <NdlocrLine>[],
      ),
      TimetableDebugScenario.partialMerchandise => const NdlocrResult(
        text: _partialMerchandiseRawText,
        imageSize: NdlocrImageSize(width: 1368, height: 1782),
        lines: <NdlocrLine>[],
      ),
      TimetableDebugScenario.unsupportedFormat => const NdlocrResult(
        text: _unsupportedFormatRawText,
        imageSize: NdlocrImageSize(width: 1368, height: 1782),
        lines: <NdlocrLine>[],
      ),
      TimetableDebugScenario.ocrFailure ||
      TimetableDebugScenario.canceledSelection => const NdlocrResult(
        text: '',
        imageSize: NdlocrImageSize(width: 1, height: 1),
        lines: <NdlocrLine>[],
      ),
    };
  }
}

const _attachedSampleRawText = '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
No. ライブ時間 出演者 物販枠 物販時間
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
2 09:35~09:55 Payrin's B 10:10~11:30
3 09:55~10:15 KOURiN C 10:30~11:50
4 10:15~10:35 Malcolm Mask McLaren D 10:50~12:10
5 10:35~10:55 紫陽花は降らない A 11:15~12:35
6 10:55~11:15 ニコルポップ B 11:35~12:55
7 11:15~11:35 アストレイル C 11:55~13:15
8 11:35~11:55 鳴ル神 D 12:15~13:35
9 11:55~12:15 XINXIN A 12:40~14:00
10 12:15~12:35 9DayzGlitchClubTokyo B 13:00~14:20
11 12:35~12:55 lonlium C 13:20~14:40
12 12:55~13:15 Chalca D 13:40~15:00
13 13:20~13:40 こみっきゅおん！ A 14:05~15:25
14 13:40~14:00 メイビーME B 14:25~15:45
15 14:00~14:20 RePLAY C 14:45~16:05
16 14:20~14:40 Tohkei D 15:05~16:25
17 14:40~15:05 Mirror,Mirror A 15:30~16:50
18 15:05~15:30 THE ORCHESTRA TOKYO B 15:50~17:10
19 15:30~15:55 selfish C 16:15~17:35
20 15:55~16:20 透色ドロップ D 16:40~18:00
21 16:25~16:50 かすみ草とステラ A 17:10~18:30
22 16:50~17:15 #よーよーよー B 17:35~18:55
23 17:15~17:40 Devil ANTHEM. C 18:00~19:20
24 17:40~18:05 HIBANA D 18:25~19:45
25 18:05~18:30 ハルニシオン A 18:50~20:10
26 18:30~18:55 SITUASION B 19:15~20:35
27 18:55~19:20 #Mooove! C 19:40~21:00
28 19:25~19:50 Merry BAD TUNE. - 終演後
29 19:50~20:15 INUWASI - 終演後
30 20:15~20:40 ジエメイ - 終演後
31 20:40~21:10 われらがプワプワプーワプワ - 終演後
終演後物販
全体 21:10~22:30
''';

const _partialMerchandiseRawText = '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
No. ライブ時間 出演者 物販枠 物販時間
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
2 09:35~09:55 Payrin's B
3 09:55~10:15 KOURiN
''';

const _unsupportedFormatRawText = '''
アイドル甲子園
2026.03.21 [sat] OPEN 09:00 / START 09:15
ステージ写真
演者コメント
集合画像
''';
