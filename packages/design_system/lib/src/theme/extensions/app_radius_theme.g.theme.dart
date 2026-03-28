// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_radius_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppRadiusTheme on ThemeExtension<AppRadiusTheme> {
  @override
  ThemeExtension<AppRadiusTheme> copyWith({
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? pill,
  }) {
    final _this = (this as AppRadiusTheme);

    return AppRadiusTheme(
      xs: xs ?? _this.xs,
      s: s ?? _this.s,
      m: m ?? _this.m,
      l: l ?? _this.l,
      xl: xl ?? _this.xl,
      pill: pill ?? _this.pill,
    );
  }

  @override
  ThemeExtension<AppRadiusTheme> lerp(
    ThemeExtension<AppRadiusTheme>? other,
    double t,
  ) {
    if (other is! AppRadiusTheme) {
      return this;
    }

    final _this = (this as AppRadiusTheme);

    return AppRadiusTheme(
      xs: lerpDouble$(_this.xs, other.xs, t)!,
      s: lerpDouble$(_this.s, other.s, t)!,
      m: lerpDouble$(_this.m, other.m, t)!,
      l: lerpDouble$(_this.l, other.l, t)!,
      xl: lerpDouble$(_this.xl, other.xl, t)!,
      pill: lerpDouble$(_this.pill, other.pill, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as AppRadiusTheme);
    final _other = (other as AppRadiusTheme);

    return _other.xs == _this.xs &&
        _other.s == _this.s &&
        _other.m == _this.m &&
        _other.l == _this.l &&
        _other.xl == _this.xl &&
        _other.pill == _this.pill;
  }

  @override
  int get hashCode {
    final _this = (this as AppRadiusTheme);

    return Object.hash(
      runtimeType,
      _this.xs,
      _this.s,
      _this.m,
      _this.l,
      _this.xl,
      _this.pill,
    );
  }
}

extension AppRadiusThemeBuildContext on BuildContext {
  AppRadiusTheme get appRadius => Theme.of(this).extension<AppRadiusTheme>()!;
}
