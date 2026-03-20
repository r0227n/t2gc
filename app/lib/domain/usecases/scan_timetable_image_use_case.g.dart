// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_timetable_image_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the timetable image scanning use case.

@ProviderFor(scanTimetableImageUseCase)
final scanTimetableImageUseCaseProvider = ScanTimetableImageUseCaseProvider._();

/// Provides the timetable image scanning use case.

final class ScanTimetableImageUseCaseProvider
    extends
        $FunctionalProvider<
          ScanTimetableImageUseCase,
          ScanTimetableImageUseCase,
          ScanTimetableImageUseCase
        >
    with $Provider<ScanTimetableImageUseCase> {
  /// Provides the timetable image scanning use case.
  ScanTimetableImageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanTimetableImageUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanTimetableImageUseCaseHash();

  @$internal
  @override
  $ProviderElement<ScanTimetableImageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanTimetableImageUseCase create(Ref ref) {
    return scanTimetableImageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanTimetableImageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanTimetableImageUseCase>(value),
    );
  }
}

String _$scanTimetableImageUseCaseHash() =>
    r'93515e3b7fed569b4e6db56ca3a48f57ab3d3d13';
