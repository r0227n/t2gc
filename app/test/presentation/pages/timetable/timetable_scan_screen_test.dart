import 'package:app/presentation/pages/timetable/timetable_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the empty timetable state before OCR', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TimetableScanScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('画像を選んで OCR 取込'), findsOneWidget);
    expect(find.text('Google Calendar プレビュー'), findsNothing);
    expect(find.text('抽出サマリー'), findsNothing);
    expect(find.text('ライブ / 物販タイムテーブル'), findsOneWidget);
    expect(find.text('タイムテーブルを検出するとここに表示します。'), findsOneWidget);
    expect(find.textContaining('COLOR of COLOR'), findsNothing);
    expect(find.text('09:50〜11:10'), findsNothing);
  });
}
