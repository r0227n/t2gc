import 'package:app/presentation/pages/timetable/timetable_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows live and merchandise schedule on first launch', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TimetableScanScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('COLOR of COLOR'), findsWidgets);
    expect(find.text('09:15〜09:35'), findsWidgets);
    expect(find.text('09:50〜11:10'), findsWidgets);
    expect(find.text('62 件'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Merry BAD TUNE.'),
      600,
    );
    expect(find.textContaining('Merry BAD TUNE.'), findsWidgets);
    expect(find.text('21:10〜22:30'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(const ValueKey('artist-schedule-1')),
    );
    final firstRowCheckbox = find.descendant(
      of: find.byKey(const ValueKey('artist-schedule-1')),
      matching: find.byType(Checkbox),
    );

    await tester.tap(firstRowCheckbox);
    await tester.pumpAndSettle();

    expect(find.text('30 組'), findsOneWidget);
    expect(find.text('60 件'), findsOneWidget);
  });
}
