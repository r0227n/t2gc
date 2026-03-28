import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRadiusTheme', () {
    test('default values match AppRadius constants', () {
      const theme = AppRadiusTheme();

      expect(theme.xs, AppRadius.xs);
      expect(theme.s, AppRadius.s);
      expect(theme.m, AppRadius.m);
      expect(theme.l, AppRadius.l);
      expect(theme.xl, AppRadius.xl);
      expect(theme.pill, AppRadius.pill);
    });

    group('copyWith', () {
      test('returns new instance with overridden values', () {
        const theme = AppRadiusTheme();
        final copied = theme.copyWith(l: 20, pill: 600) as AppRadiusTheme;

        expect(copied.xs, AppRadius.xs);
        expect(copied.s, AppRadius.s);
        expect(copied.l, 20);
        expect(copied.pill, 600);
      });

      test('returns equivalent instance with no arguments', () {
        const theme = AppRadiusTheme();
        final copied = theme.copyWith() as AppRadiusTheme;

        expect(copied.xs, theme.xs);
        expect(copied.s, theme.s);
        expect(copied.m, theme.m);
        expect(copied.l, theme.l);
        expect(copied.xl, theme.xl);
        expect(copied.pill, theme.pill);
      });
    });

    group('lerp', () {
      test('at t=0 returns original values', () {
        const a = AppRadiusTheme();
        const b = AppRadiusTheme(
          xs: 8,
          s: 16,
          m: 24,
          l: 32,
          xl: 40,
          pill: 500,
        );

        final result = a.lerp(b, 0) as AppRadiusTheme;

        expect(result.xs, a.xs);
        expect(result.s, a.s);
        expect(result.m, a.m);
        expect(result.l, a.l);
        expect(result.xl, a.xl);
        expect(result.pill, a.pill);
      });

      test('at t=1 returns other values', () {
        const a = AppRadiusTheme();
        const b = AppRadiusTheme(
          xs: 8,
          s: 16,
          m: 24,
          l: 32,
          xl: 40,
          pill: 500,
        );

        final result = a.lerp(b, 1) as AppRadiusTheme;

        expect(result.xs, b.xs);
        expect(result.s, b.s);
        expect(result.m, b.m);
        expect(result.l, b.l);
        expect(result.xl, b.xl);
        expect(result.pill, b.pill);
      });

      test('at t=0.5 returns midpoint values', () {
        const a = AppRadiusTheme(xs: 0, s: 0, m: 0, l: 0, xl: 0, pill: 0);
        const b = AppRadiusTheme(
          xs: 10,
          s: 20,
          m: 30,
          l: 40,
          xl: 50,
          pill: 60,
        );

        final result = a.lerp(b, 0.5) as AppRadiusTheme;

        expect(result.xs, 5);
        expect(result.s, 10);
        expect(result.m, 15);
        expect(result.l, 20);
        expect(result.xl, 25);
        expect(result.pill, 30);
      });

      test('with null returns this', () {
        const theme = AppRadiusTheme();

        final result = theme.lerp(null, 0.5) as AppRadiusTheme;

        expect(result.xs, theme.xs);
        expect(result.s, theme.s);
        expect(result.m, theme.m);
        expect(result.l, theme.l);
        expect(result.xl, theme.xl);
        expect(result.pill, theme.pill);
      });
    });
  });
}
