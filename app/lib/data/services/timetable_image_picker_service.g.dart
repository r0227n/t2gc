// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_image_picker_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the image picker service used by the timetable flow.

@ProviderFor(timetableImagePickerService)
final timetableImagePickerServiceProvider =
    TimetableImagePickerServiceProvider._();

/// Provides the image picker service used by the timetable flow.

final class TimetableImagePickerServiceProvider
    extends
        $FunctionalProvider<
          TimetableImagePickerService,
          TimetableImagePickerService,
          TimetableImagePickerService
        >
    with $Provider<TimetableImagePickerService> {
  /// Provides the image picker service used by the timetable flow.
  TimetableImagePickerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableImagePickerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableImagePickerServiceHash();

  @$internal
  @override
  $ProviderElement<TimetableImagePickerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableImagePickerService create(Ref ref) {
    return timetableImagePickerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableImagePickerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableImagePickerService>(value),
    );
  }
}

String _$timetableImagePickerServiceHash() =>
    r'26e8d322dd5b9eaf0b43d7287ca21c04301855ce';
