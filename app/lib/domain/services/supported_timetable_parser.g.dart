// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_timetable_parser.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the parser tuned to the supported timetable layout.

@ProviderFor(supportedTimetableParser)
final supportedTimetableParserProvider = SupportedTimetableParserProvider._();

/// Provides the parser tuned to the supported timetable layout.

final class SupportedTimetableParserProvider
    extends
        $FunctionalProvider<
          SupportedTimetableParser,
          SupportedTimetableParser,
          SupportedTimetableParser
        >
    with $Provider<SupportedTimetableParser> {
  /// Provides the parser tuned to the supported timetable layout.
  SupportedTimetableParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportedTimetableParserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportedTimetableParserHash();

  @$internal
  @override
  $ProviderElement<SupportedTimetableParser> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupportedTimetableParser create(Ref ref) {
    return supportedTimetableParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportedTimetableParser value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportedTimetableParser>(value),
    );
  }
}

String _$supportedTimetableParserHash() =>
    r'e41e21b88c733965f1c8b1e935ce8bc3332099d3';
