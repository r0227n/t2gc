// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls OCR execution and selection state for the timetable screen.

@ProviderFor(TimetableScanController)
final timetableScanControllerProvider = TimetableScanControllerProvider._();

/// Controls OCR execution and selection state for the timetable screen.
final class TimetableScanControllerProvider
    extends $NotifierProvider<TimetableScanController, TimetableScanState> {
  /// Controls OCR execution and selection state for the timetable screen.
  TimetableScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableScanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableScanControllerHash();

  @$internal
  @override
  TimetableScanController create() => TimetableScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableScanState>(value),
    );
  }
}

String _$timetableScanControllerHash() =>
    r'ac3fb27395f25f6ca04d0f67f3b27cebe24ab99a';

/// Controls OCR execution and selection state for the timetable screen.

abstract class _$TimetableScanController extends $Notifier<TimetableScanState> {
  TimetableScanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimetableScanState, TimetableScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimetableScanState, TimetableScanState>,
              TimetableScanState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
