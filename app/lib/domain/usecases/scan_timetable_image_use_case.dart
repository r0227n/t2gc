import 'package:app/data/repositories/artist_name_exclusion_repository.dart';
import 'package:app/data/services/timetable_ocr_service.dart';
import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_metadata.dart';
import 'package:app/domain/models/timetable_performance_slot.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/domain/services/supported_timetable_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:ndlocr_lite_flutter/ndlocr_lite_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_timetable_image_use_case.g.dart';

/// Provides the timetable image scanning use case.
@Riverpod(keepAlive: true)
ScanTimetableImageUseCase scanTimetableImageUseCase(Ref ref) {
  return ScanTimetableImageUseCase(
    ocrService: ref.watch(timetableOcrServiceProvider),
    getExcludedArtistWords: ref
        .watch(artistNameExclusionRepositoryProvider)
        .getExcludedWords,
  );
}

/// Runs OCR and parsing for a selected timetable image.
class ScanTimetableImageUseCase {
  /// Creates a timetable scanning use case.
  ScanTimetableImageUseCase({
    required TimetableOcrService ocrService,
    List<String> Function()? getExcludedArtistWords,
    Future<TimetableScanResult> Function(
      NdlocrResult result,
      List<String> excludedArtistWords,
    )?
    parseResult,
  }) : _ocrService = ocrService,
       _getExcludedArtistWords =
           getExcludedArtistWords ?? (() => const <String>[]),
       _parseResult =
           parseResult ??
           ((result, excludedArtistWords) async {
             final parsedJson = await compute(
               _parseTimetableScanResult,
               <String, Object?>{
                 'result': result.toJson(),
                 'excludedArtistWords': excludedArtistWords,
               },
             );
             return _timetableScanResultFromJson(parsedJson);
           });

  final TimetableOcrService _ocrService;
  final List<String> Function() _getExcludedArtistWords;
  final Future<TimetableScanResult> Function(
    NdlocrResult result,
    List<String> excludedArtistWords,
  )
  _parseResult;

  /// Scans the provided image and returns the parsed timetable.
  Future<TimetableScanResult> call({
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    final ocrResult = await _ocrService.recognizeImageBytes(
      imageBytes: imageBytes,
      imageName: imageName,
    );
    return _parseResult(ocrResult, _getExcludedArtistWords());
  }

  static Map<String, dynamic> _parseTimetableScanResult(
    Map<String, dynamic> json,
  ) {
    final excludedArtistWords =
        (json['excludedArtistWords'] as List<Object?>? ?? const <Object?>[])
            .whereType<String>()
            .toList(growable: false);
    final parser = SupportedTimetableParser(
      excludedArtistWords: excludedArtistWords,
    );
    final parsed = parser.parse(
      _ndlocrResultFromJson(
        json['result'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
    );
    return _timetableScanResultToJson(parsed);
  }

  static NdlocrResult _ndlocrResultFromJson(Map<String, dynamic> json) {
    final imageSizeJson = _asObjectMap(json['imageSize']);
    final linesJson = json['lines'] as List<Object?>? ?? const <Object?>[];
    return NdlocrResult(
      text: json['text'] as String? ?? '',
      lines: [
        for (final lineJson in linesJson)
          _ndlocrLineFromJson(_asObjectMap(lineJson)),
      ],
      imageSize: NdlocrImageSize(
        width: imageSizeJson['width'] as int? ?? 0,
        height: imageSizeJson['height'] as int? ?? 0,
      ),
      xml: json['xml'] as String?,
      json: (json['json'] as Map<Object?, Object?>?)?.cast<String, dynamic>(),
    );
  }

  static NdlocrLine _ndlocrLineFromJson(Map<Object?, Object?> json) {
    final boundingBoxJson = _asObjectMap(json['boundingBox']);
    return NdlocrLine(
      order: json['order'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      boundingBox: NdlocrBoundingBox(
        x: boundingBoxJson['x'] as int? ?? 0,
        y: boundingBoxJson['y'] as int? ?? 0,
        width: boundingBoxJson['width'] as int? ?? 0,
        height: boundingBoxJson['height'] as int? ?? 0,
      ),
      type: json['type'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      isVertical: json['isVertical'] as bool? ?? false,
      predictedCharCount: (json['predictedCharCount'] as num?)?.toDouble(),
    );
  }

  static Map<String, dynamic> _timetableScanResultToJson(
    TimetableScanResult result,
  ) {
    return <String, dynamic>{
      'metadata': _timetableMetadataToJson(result.metadata),
      'schedules': [
        for (final schedule in result.schedules)
          _artistScheduleToJson(schedule),
      ],
      'warnings': result.warnings,
      'rawText': result.rawText,
    };
  }

  static TimetableScanResult _timetableScanResultFromJson(
    Map<String, dynamic> json,
  ) {
    final schedulesJson =
        json['schedules'] as List<Object?>? ?? const <Object?>[];
    return TimetableScanResult(
      metadata: _timetableMetadataFromJson(
        json['metadata'] as Map<Object?, Object?>? ??
            const <Object?, Object?>{},
      ),
      schedules: [
        for (final scheduleJson in schedulesJson)
          _artistScheduleFromJson(_asObjectMap(scheduleJson)),
      ],
      warnings: (json['warnings'] as List<Object?>? ?? const <Object?>[])
          .whereType<String>()
          .toList(growable: false),
      rawText: json['rawText'] as String? ?? '',
    );
  }

  static Map<String, dynamic> _timetableMetadataToJson(
    TimetableMetadata metadata,
  ) {
    return <String, dynamic>{
      'eventTitle': metadata.eventTitle,
      'venueName': metadata.venueName,
      'eventDate': metadata.eventDate.toIso8601String(),
      'timeZoneId': metadata.timeZoneId,
      'openAt': metadata.openAt?.toIso8601String(),
      'startAt': metadata.startAt?.toIso8601String(),
      'afterShowMerchandiseStartAt': metadata.afterShowMerchandiseStartAt
          ?.toIso8601String(),
      'afterShowMerchandiseEndAt': metadata.afterShowMerchandiseEndAt
          ?.toIso8601String(),
    };
  }

  static TimetableMetadata _timetableMetadataFromJson(
    Map<Object?, Object?> json,
  ) {
    return TimetableMetadata(
      eventTitle: json['eventTitle'] as String? ?? '',
      venueName: json['venueName'] as String? ?? '',
      eventDate: DateTime.parse(
        json['eventDate'] as String? ?? DateTime(1970).toIso8601String(),
      ),
      timeZoneId: json['timeZoneId'] as String? ?? 'Asia/Tokyo',
      openAt: _dateTimeOrNull(json['openAt']),
      startAt: _dateTimeOrNull(json['startAt']),
      afterShowMerchandiseStartAt: _dateTimeOrNull(
        json['afterShowMerchandiseStartAt'],
      ),
      afterShowMerchandiseEndAt: _dateTimeOrNull(
        json['afterShowMerchandiseEndAt'],
      ),
    );
  }

  static Map<String, dynamic> _artistScheduleToJson(
    TimetableArtistSchedule schedule,
  ) {
    return <String, dynamic>{
      'performance': _performanceSlotToJson(schedule.performance),
      'merchandise': schedule.merchandise == null
          ? null
          : _merchandiseSlotToJson(schedule.merchandise!),
    };
  }

  static TimetableArtistSchedule _artistScheduleFromJson(
    Map<Object?, Object?> json,
  ) {
    final merchandiseJson = json['merchandise'] as Map<Object?, Object?>?;
    return TimetableArtistSchedule(
      performance: _performanceSlotFromJson(
        json['performance'] as Map<Object?, Object?>? ??
            const <Object?, Object?>{},
      ),
      merchandise: merchandiseJson == null
          ? null
          : _merchandiseSlotFromJson(merchandiseJson),
    );
  }

  static Map<String, dynamic> _performanceSlotToJson(
    TimetablePerformanceSlot slot,
  ) {
    return <String, dynamic>{
      'slotNumber': slot.slotNumber,
      'artistName': slot.artistName,
      'startAt': slot.startAt.toIso8601String(),
      'endAt': slot.endAt.toIso8601String(),
      'sourceText': slot.sourceText,
    };
  }

  static TimetablePerformanceSlot _performanceSlotFromJson(
    Map<Object?, Object?> json,
  ) {
    return TimetablePerformanceSlot(
      slotNumber: json['slotNumber'] as int? ?? 0,
      artistName: json['artistName'] as String? ?? '',
      startAt: DateTime.parse(
        json['startAt'] as String? ?? DateTime(1970).toIso8601String(),
      ),
      endAt: DateTime.parse(
        json['endAt'] as String? ?? DateTime(1970).toIso8601String(),
      ),
      sourceText: json['sourceText'] as String? ?? '',
    );
  }

  static Map<String, dynamic> _merchandiseSlotToJson(
    TimetableMerchandiseSlot slot,
  ) {
    return <String, dynamic>{
      'slotNumber': slot.slotNumber,
      'artistName': slot.artistName,
      'startAt': slot.startAt.toIso8601String(),
      'endAt': slot.endAt.toIso8601String(),
      'sourceText': slot.sourceText,
      'boothLabel': slot.boothLabel,
      'isAfterShow': slot.isAfterShow,
    };
  }

  static TimetableMerchandiseSlot _merchandiseSlotFromJson(
    Map<Object?, Object?> json,
  ) {
    return TimetableMerchandiseSlot(
      slotNumber: json['slotNumber'] as int? ?? 0,
      artistName: json['artistName'] as String? ?? '',
      startAt: DateTime.parse(
        json['startAt'] as String? ?? DateTime(1970).toIso8601String(),
      ),
      endAt: DateTime.parse(
        json['endAt'] as String? ?? DateTime(1970).toIso8601String(),
      ),
      sourceText: json['sourceText'] as String? ?? '',
      boothLabel: json['boothLabel'] as String?,
      isAfterShow: json['isAfterShow'] as bool? ?? false,
    );
  }

  static DateTime? _dateTimeOrNull(Object? value) {
    final iso8601 = value as String?;
    return iso8601 == null ? null : DateTime.parse(iso8601);
  }

  static Map<Object?, Object?> _asObjectMap(Object? value) {
    return value is Map<Object?, Object?> ? value : const <Object?, Object?>{};
  }
}
