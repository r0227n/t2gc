import 'package:app/presentation/pages/settings_screen.dart';
import 'package:app/presentation/pages/timetable_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

/// The main application route.
///
/// Displays the [TimetableScanScreen] as the single screen of the application.
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Creates a [HomeRoute].
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TimetableScanScreen();
  }
}

/// The settings route.
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  /// Creates a [SettingsRoute].
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}
