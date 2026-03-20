// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetableScanResult {

 TimetableMetadata get metadata; List<TimetableArtistSchedule> get schedules; List<String> get warnings; String get rawText;
/// Create a copy of TimetableScanResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableScanResultCopyWith<TimetableScanResult> get copyWith => _$TimetableScanResultCopyWithImpl<TimetableScanResult>(this as TimetableScanResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableScanResult&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&(identical(other.rawText, rawText) || other.rawText == rawText));
}


@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(schedules),const DeepCollectionEquality().hash(warnings),rawText);

@override
String toString() {
  return 'TimetableScanResult(metadata: $metadata, schedules: $schedules, warnings: $warnings, rawText: $rawText)';
}


}

/// @nodoc
abstract mixin class $TimetableScanResultCopyWith<$Res>  {
  factory $TimetableScanResultCopyWith(TimetableScanResult value, $Res Function(TimetableScanResult) _then) = _$TimetableScanResultCopyWithImpl;
@useResult
$Res call({
 TimetableMetadata metadata, List<TimetableArtistSchedule> schedules, List<String> warnings, String rawText
});


$TimetableMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$TimetableScanResultCopyWithImpl<$Res>
    implements $TimetableScanResultCopyWith<$Res> {
  _$TimetableScanResultCopyWithImpl(this._self, this._then);

  final TimetableScanResult _self;
  final $Res Function(TimetableScanResult) _then;

/// Create a copy of TimetableScanResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = null,Object? schedules = null,Object? warnings = null,Object? rawText = null,}) {
  return _then(_self.copyWith(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TimetableMetadata,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<TimetableArtistSchedule>,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TimetableScanResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableMetadataCopyWith<$Res> get metadata {
  
  return $TimetableMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimetableScanResult].
extension TimetableScanResultPatterns on TimetableScanResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableScanResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableScanResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableScanResult value)  $default,){
final _that = this;
switch (_that) {
case _TimetableScanResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableScanResult value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableScanResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimetableMetadata metadata,  List<TimetableArtistSchedule> schedules,  List<String> warnings,  String rawText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableScanResult() when $default != null:
return $default(_that.metadata,_that.schedules,_that.warnings,_that.rawText);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimetableMetadata metadata,  List<TimetableArtistSchedule> schedules,  List<String> warnings,  String rawText)  $default,) {final _that = this;
switch (_that) {
case _TimetableScanResult():
return $default(_that.metadata,_that.schedules,_that.warnings,_that.rawText);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimetableMetadata metadata,  List<TimetableArtistSchedule> schedules,  List<String> warnings,  String rawText)?  $default,) {final _that = this;
switch (_that) {
case _TimetableScanResult() when $default != null:
return $default(_that.metadata,_that.schedules,_that.warnings,_that.rawText);case _:
  return null;

}
}

}

/// @nodoc


class _TimetableScanResult extends TimetableScanResult {
  const _TimetableScanResult({required this.metadata, required final  List<TimetableArtistSchedule> schedules, final  List<String> warnings = const <String>[], this.rawText = ''}): _schedules = schedules,_warnings = warnings,super._();
  

@override final  TimetableMetadata metadata;
 final  List<TimetableArtistSchedule> _schedules;
@override List<TimetableArtistSchedule> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override@JsonKey() final  String rawText;

/// Create a copy of TimetableScanResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableScanResultCopyWith<_TimetableScanResult> get copyWith => __$TimetableScanResultCopyWithImpl<_TimetableScanResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableScanResult&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&(identical(other.rawText, rawText) || other.rawText == rawText));
}


@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(_schedules),const DeepCollectionEquality().hash(_warnings),rawText);

@override
String toString() {
  return 'TimetableScanResult(metadata: $metadata, schedules: $schedules, warnings: $warnings, rawText: $rawText)';
}


}

/// @nodoc
abstract mixin class _$TimetableScanResultCopyWith<$Res> implements $TimetableScanResultCopyWith<$Res> {
  factory _$TimetableScanResultCopyWith(_TimetableScanResult value, $Res Function(_TimetableScanResult) _then) = __$TimetableScanResultCopyWithImpl;
@override @useResult
$Res call({
 TimetableMetadata metadata, List<TimetableArtistSchedule> schedules, List<String> warnings, String rawText
});


@override $TimetableMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$TimetableScanResultCopyWithImpl<$Res>
    implements _$TimetableScanResultCopyWith<$Res> {
  __$TimetableScanResultCopyWithImpl(this._self, this._then);

  final _TimetableScanResult _self;
  final $Res Function(_TimetableScanResult) _then;

/// Create a copy of TimetableScanResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = null,Object? schedules = null,Object? warnings = null,Object? rawText = null,}) {
  return _then(_TimetableScanResult(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as TimetableMetadata,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<TimetableArtistSchedule>,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TimetableScanResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableMetadataCopyWith<$Res> get metadata {
  
  return $TimetableMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
