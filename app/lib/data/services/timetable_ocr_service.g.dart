// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_ocr_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the OCR service used by the timetable flow.

@ProviderFor(timetableOcrService)
final timetableOcrServiceProvider = TimetableOcrServiceProvider._();

/// Provides the OCR service used by the timetable flow.

final class TimetableOcrServiceProvider
    extends
        $FunctionalProvider<
          TimetableOcrService,
          TimetableOcrService,
          TimetableOcrService
        >
    with $Provider<TimetableOcrService> {
  /// Provides the OCR service used by the timetable flow.
  TimetableOcrServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableOcrServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableOcrServiceHash();

  @$internal
  @override
  $ProviderElement<TimetableOcrService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableOcrService create(Ref ref) {
    return timetableOcrService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableOcrService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableOcrService>(value),
    );
  }
}

String _$timetableOcrServiceHash() =>
    r'393e29886a301282fdfbca4581ab62fd4908459a';
