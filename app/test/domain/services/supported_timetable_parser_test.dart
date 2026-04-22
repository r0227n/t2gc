import 'package:app/domain/services/supported_timetable_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';

void main() {
  group('SupportedTimetableParser', () {
    const parser = SupportedTimetableParser();

    test('parses live rows, merchandise rows, and after-show merchandise', () {
      const result = NdlocrResult(
        text: '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
No. ライブ時間 出演者 物販枠 物販時間
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
28 19:25~19:50 Merry BAD TUNE. - 終演後
終演後物販 時間
全体 21:10~22:30
''',
        imageSize: NdlocrImageSize(width: 1368, height: 1782),
        lines: <NdlocrLine>[
          NdlocrLine(
            order: 0,
            text: 'アイドル甲子園 in KANDA SQUARE HALL -DAY2-',
            boundingBox: NdlocrBoundingBox(
              x: 120,
              y: 220,
              width: 980,
              height: 76,
            ),
            type: 'line',
            confidence: 0.99,
            isVertical: false,
          ),
          NdlocrLine(
            order: 1,
            text: '2026.03.21 [sat] OPEN 09:00 / START 09:15',
            boundingBox: NdlocrBoundingBox(
              x: 60,
              y: 356,
              width: 1200,
              height: 72,
            ),
            type: 'line',
            confidence: 0.99,
            isVertical: false,
          ),
          NdlocrLine(
            order: 2,
            text: 'No.',
            boundingBox: NdlocrBoundingBox(
              x: 120,
              y: 430,
              width: 60,
              height: 28,
            ),
            type: 'line',
            confidence: 0.97,
            isVertical: false,
          ),
          NdlocrLine(
            order: 3,
            text: 'ライブ時間',
            boundingBox: NdlocrBoundingBox(
              x: 220,
              y: 430,
              width: 220,
              height: 28,
            ),
            type: 'line',
            confidence: 0.97,
            isVertical: false,
          ),
          NdlocrLine(
            order: 4,
            text: '出演者',
            boundingBox: NdlocrBoundingBox(
              x: 480,
              y: 430,
              width: 200,
              height: 28,
            ),
            type: 'line',
            confidence: 0.97,
            isVertical: false,
          ),
          NdlocrLine(
            order: 5,
            text: '物販枠',
            boundingBox: NdlocrBoundingBox(
              x: 930,
              y: 430,
              width: 100,
              height: 28,
            ),
            type: 'line',
            confidence: 0.97,
            isVertical: false,
          ),
          NdlocrLine(
            order: 6,
            text: '1',
            boundingBox: NdlocrBoundingBox(
              x: 170,
              y: 470,
              width: 28,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 7,
            text: '09:15~09:35',
            boundingBox: NdlocrBoundingBox(
              x: 220,
              y: 470,
              width: 220,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 8,
            text: 'COLOR of COLOR',
            boundingBox: NdlocrBoundingBox(
              x: 450,
              y: 470,
              width: 330,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 9,
            text: 'A',
            boundingBox: NdlocrBoundingBox(
              x: 930,
              y: 470,
              width: 40,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 10,
            text: '09:50~11:10',
            boundingBox: NdlocrBoundingBox(
              x: 1010,
              y: 470,
              width: 220,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 11,
            text: '28',
            boundingBox: NdlocrBoundingBox(
              x: 170,
              y: 1230,
              width: 28,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 12,
            text: '19:25~19:50',
            boundingBox: NdlocrBoundingBox(
              x: 220,
              y: 1230,
              width: 220,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 13,
            text: 'Merry BAD TUNE.',
            boundingBox: NdlocrBoundingBox(
              x: 450,
              y: 1230,
              width: 300,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 14,
            text: '-',
            boundingBox: NdlocrBoundingBox(
              x: 930,
              y: 1230,
              width: 24,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 15,
            text: '終演後',
            boundingBox: NdlocrBoundingBox(
              x: 1000,
              y: 1230,
              width: 120,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
          NdlocrLine(
            order: 16,
            text: '終演後物販',
            boundingBox: NdlocrBoundingBox(
              x: 200,
              y: 1420,
              width: 220,
              height: 32,
            ),
            type: 'line',
            confidence: 0.96,
            isVertical: false,
          ),
          NdlocrLine(
            order: 17,
            text: '全体',
            boundingBox: NdlocrBoundingBox(
              x: 200,
              y: 1470,
              width: 80,
              height: 32,
            ),
            type: 'line',
            confidence: 0.96,
            isVertical: false,
          ),
          NdlocrLine(
            order: 18,
            text: '21:10~22:30',
            boundingBox: NdlocrBoundingBox(
              x: 340,
              y: 1470,
              width: 220,
              height: 32,
            ),
            type: 'line',
            confidence: 0.98,
            isVertical: false,
          ),
        ],
      );

      final parsed = parser.parse(result);
      final first = parsed.schedules.first;
      final last = parsed.schedules.last;

      expect(parsed.performances, hasLength(2));
      expect(parsed.merchandiseSlots, hasLength(2));
      expect(parsed.metadata.eventTitle, 'アイドル甲子園 in KANDA SQUARE HALL -DAY2-');
      expect(parsed.metadata.venueName, 'KANDA SQUARE HALL');
      expect(
        parsed.metadata.afterShowMerchandiseStartAt,
        DateTime(2026, 3, 21, 21, 10),
      );
      expect(
        parsed.metadata.afterShowMerchandiseEndAt,
        DateTime(2026, 3, 21, 22, 30),
      );
      expect(first.artistName, 'COLOR of COLOR');
      expect(first.performance.startAt, DateTime(2026, 3, 21, 9, 15));
      expect(first.performance.endAt, DateTime(2026, 3, 21, 9, 35));
      expect(first.merchandise?.boothLabel, 'A');
      expect(first.merchandise?.startAt, DateTime(2026, 3, 21, 9, 50));
      expect(first.merchandise?.endAt, DateTime(2026, 3, 21, 11, 10));
      expect(last.artistName, 'Merry BAD TUNE.');
      expect(last.performance.startAt, DateTime(2026, 3, 21, 19, 25));
      expect(last.performance.endAt, DateTime(2026, 3, 21, 19, 50));
      expect(last.merchandise?.isAfterShow, isTrue);
      expect(last.merchandise?.startAt, DateTime(2026, 3, 21, 21, 10));
      expect(last.merchandise?.endAt, DateTime(2026, 3, 21, 22, 30));
    });

    test('parses the full attached sample timetable', () {
      final parsed = parser.parse(_attachedSampleOcrResultFixture());

      expect(parsed.performances, hasLength(31));
      expect(parsed.merchandiseSlots, hasLength(31));
      expect(parsed.warnings, isEmpty);
      expect(parsed.schedules.first.artistName, 'COLOR of COLOR');
      expect(parsed.schedules.last.artistName, 'われらがプワプワプーワプワ');
      expect(
        parsed.metadata.afterShowMerchandiseStartAt,
        DateTime(2026, 3, 21, 21, 10),
      );
      expect(
        parsed.metadata.afterShowMerchandiseEndAt,
        DateTime(2026, 3, 21, 22, 30),
      );
    });

    test('removes configured exclusion words from artist names', () {
      const parser = SupportedTimetableParser(
        excludedArtistWords: <String>['物販'],
      );
      const result = NdlocrResult(
        text:
            'アイドル甲子園 in KANDA SQUARE HALL\n'
            '2026.03.21 OPEN 10:30 START 11:00\n'
            '1 11:00~11:20 KOURIN 物販 A 11:30~12:30\n',
        imageSize: NdlocrImageSize(width: 1368, height: 1782),
        lines: <NdlocrLine>[
          NdlocrLine(
            order: 0,
            text: 'アイドル甲子園 in KANDA SQUARE HALL',
            boundingBox: NdlocrBoundingBox(
              x: 80,
              y: 80,
              width: 900,
              height: 80,
            ),
            type: 'line',
            confidence: 0.99,
            isVertical: false,
          ),
          NdlocrLine(
            order: 1,
            text: '2026.03.21 OPEN 10:30 START 11:00',
            boundingBox: NdlocrBoundingBox(
              x: 80,
              y: 180,
              width: 900,
              height: 60,
            ),
            type: 'line',
            confidence: 0.99,
            isVertical: false,
          ),
          NdlocrLine(
            order: 2,
            text: '1 11:00~11:20 KOURIN 物販 A 11:30~12:30',
            boundingBox: NdlocrBoundingBox(
              x: 120,
              y: 500,
              width: 900,
              height: 60,
            ),
            type: 'line',
            confidence: 0.99,
            isVertical: false,
          ),
        ],
      );

      final parsed = parser.parse(result);

      expect(parsed.performances.single.artistName, 'KOURIN');
      expect(parsed.merchandiseSlots.single.artistName, 'KOURIN');
    });

    test('adds warnings when merchandise times are missing', () {
      final parsed = parser.parse(_partialMerchandiseOcrResultFixture());

      expect(parsed.performances, hasLength(3));
      expect(parsed.merchandiseSlots, hasLength(1));
      expect(parsed.warnings, contains('2 件の特典会時間を取得できませんでした。'));
    });

    test('adds warnings when no supported rows are detected', () {
      final parsed = parser.parse(_unsupportedFormatOcrResultFixture());

      expect(parsed.performances, isEmpty);
      expect(parsed.merchandiseSlots, isEmpty);
      expect(parsed.warnings, contains('対応フォーマットの行を検出できませんでした。'));
    });
  });
}

NdlocrResult _attachedSampleOcrResultFixture() {
  return const NdlocrResult(
    text: '''
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
''',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[],
  );
}

NdlocrResult _partialMerchandiseOcrResultFixture() {
  return const NdlocrResult(
    text: '''
アイドル甲子園 in KANDA SQUARE HALL -DAY2-
2026.03.21 [sat] OPEN 09:00 / START 09:15
No. ライブ時間 出演者 物販枠 物販時間
1 09:15~09:35 COLOR of COLOR A 09:50~11:10
2 09:35~09:55 Payrin's B
3 09:55~10:15 KOURiN
''',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[],
  );
}

NdlocrResult _unsupportedFormatOcrResultFixture() {
  return const NdlocrResult(
    text: '''
アイドル甲子園
2026.03.21 [sat] OPEN 09:00 / START 09:15
ステージ写真
演者コメント
集合画像
''',
    imageSize: NdlocrImageSize(width: 1368, height: 1782),
    lines: <NdlocrLine>[],
  );
}
