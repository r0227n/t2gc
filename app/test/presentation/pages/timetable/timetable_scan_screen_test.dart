import 'package:app/presentation/pages/timetable/timetable_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the bundled timetable summary', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TimetableScanScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('理想サンプルを再読込'), findsOneWidget);
    expect(find.text('Google Calendar プレビュー'), findsOneWidget);
    expect(find.text('ライブ / 物販タイムテーブル'), findsOneWidget);
    expect(find.textContaining('COLOR of COLOR'), findsWidgets);
    expect(find.text('09:50〜11:10'), findsOneWidget);
  });
}
