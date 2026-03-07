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
      expect(parsed.metadata.afterShowMerchandiseTimeLabel, '21:10〜22:30');
      expect(first.artistName, 'COLOR of COLOR');
      expect(first.performance.timeLabel, '09:15〜09:35');
      expect(first.merchandise?.boothLabelText, '物販 A');
      expect(first.merchandise?.timeLabel, '09:50〜11:10');
      expect(last.artistName, 'Merry BAD TUNE.');
      expect(last.performance.timeLabel, '19:25〜19:50');
      expect(last.merchandise?.boothLabelText, '終演後物販');
      expect(last.merchandise?.timeLabel, '21:10〜22:30');
    });
  });
}
