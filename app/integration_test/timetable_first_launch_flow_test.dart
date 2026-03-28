import 'package:app/presentation/pages/timetable_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('validates deterministic normal and abnormal scenarios', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TimetableScanScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('scenario-attached-sample')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
    expect(find.text('09:15〜09:35'), findsWidgets);
    expect(find.text('09:50〜11:10'), findsWidgets);
    expect(find.byKey(const ValueKey('artist-schedule-28')), findsOneWidget);
    expect(find.text('21:10〜22:30'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('event-row-checkbox-1')),
    );
    await tester.tap(find.byKey(const ValueKey('event-row-checkbox-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('artist-schedule-1')), findsOneWidget);
    expect(find.textContaining('30 Event'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('scenario-partial-merchandise')),
    );
    await tester.tap(
      find.byKey(const ValueKey('scenario-partial-merchandise')),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 件の特典会時間を取得できませんでした。'), findsOneWidget);
    expect(find.text('N/A'), findsNWidgets(2));

    await tester.ensureVisible(
      find.byKey(const ValueKey('scenario-unsupported-format')),
    );
    await tester.tap(find.byKey(const ValueKey('scenario-unsupported-format')));
    await tester.pumpAndSettle();

    expect(
      find.text('No supported timetable rows were detected.'),
      findsWidgets,
    );

    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {};
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });

    await tester.ensureVisible(
      find.byKey(const ValueKey('scenario-ocr-failure')),
    );
    await tester.tap(find.byKey(const ValueKey('scenario-ocr-failure')));
    await tester.pumpAndSettle();

    expect(find.textContaining('OCR failed:'), findsOneWidget);
  });
}
