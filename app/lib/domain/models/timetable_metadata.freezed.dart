// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetableMetadata {

 String get eventTitle; String get venueName; DateTime get eventDate; String get timeZoneId; DateTime? get openAt; DateTime? get startAt; DateTime? get afterShowMerchandiseStartAt; DateTime? get afterShowMerchandiseEndAt;
/// Create a copy of TimetableMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableMetadataCopyWith<TimetableMetadata> get copyWith => _$TimetableMetadataCopyWithImpl<TimetableMetadata>(this as TimetableMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableMetadata&&(identical(other.eventTitle, eventTitle) || other.eventTitle == eventTitle)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.openAt, openAt) || other.openAt == openAt)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.afterShowMerchandiseStartAt, afterShowMerchandiseStartAt) || other.afterShowMerchandiseStartAt == afterShowMerchandiseStartAt)&&(identical(other.afterShowMerchandiseEndAt, afterShowMerchandiseEndAt) || other.afterShowMerchandiseEndAt == afterShowMerchandiseEndAt));
}


@override
int get hashCode => Object.hash(runtimeType,eventTitle,venueName,eventDate,timeZoneId,openAt,startAt,afterShowMerchandiseStartAt,afterShowMerchandiseEndAt);

@override
String toString() {
  return 'TimetableMetadata(eventTitle: $eventTitle, venueName: $venueName, eventDate: $eventDate, timeZoneId: $timeZoneId, openAt: $openAt, startAt: $startAt, afterShowMerchandiseStartAt: $afterShowMerchandiseStartAt, afterShowMerchandiseEndAt: $afterShowMerchandiseEndAt)';
}


}

/// @nodoc
abstract mixin class $TimetableMetadataCopyWith<$Res>  {
  factory $TimetableMetadataCopyWith(TimetableMetadata value, $Res Function(TimetableMetadata) _then) = _$TimetableMetadataCopyWithImpl;
@useResult
$Res call({
 String eventTitle, String venueName, DateTime eventDate, String timeZoneId, DateTime? openAt, DateTime? startAt, DateTime? afterShowMerchandiseStartAt, DateTime? afterShowMerchandiseEndAt
});




}
/// @nodoc
class _$TimetableMetadataCopyWithImpl<$Res>
    implements $TimetableMetadataCopyWith<$Res> {
  _$TimetableMetadataCopyWithImpl(this._self, this._then);

  final TimetableMetadata _self;
  final $Res Function(TimetableMetadata) _then;

/// Create a copy of TimetableMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventTitle = null,Object? venueName = null,Object? eventDate = null,Object? timeZoneId = null,Object? openAt = freezed,Object? startAt = freezed,Object? afterShowMerchandiseStartAt = freezed,Object? afterShowMerchandiseEndAt = freezed,}) {
  return _then(_self.copyWith(
eventTitle: null == eventTitle ? _self.eventTitle : eventTitle // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,openAt: freezed == openAt ? _self.openAt : openAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,afterShowMerchandiseStartAt: freezed == afterShowMerchandiseStartAt ? _self.afterShowMerchandiseStartAt : afterShowMerchandiseStartAt // ignore: cast_nullable_to_non_nullable
as DateTime?,afterShowMerchandiseEndAt: freezed == afterShowMerchandiseEndAt ? _self.afterShowMerchandiseEndAt : afterShowMerchandiseEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableMetadata].
extension TimetableMetadataPatterns on TimetableMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableMetadata value)  $default,){
final _that = this;
switch (_that) {
case _TimetableMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventTitle,  String venueName,  DateTime eventDate,  String timeZoneId,  DateTime? openAt,  DateTime? startAt,  DateTime? afterShowMerchandiseStartAt,  DateTime? afterShowMerchandiseEndAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableMetadata() when $default != null:
return $default(_that.eventTitle,_that.venueName,_that.eventDate,_that.timeZoneId,_that.openAt,_that.startAt,_that.afterShowMerchandiseStartAt,_that.afterShowMerchandiseEndAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventTitle,  String venueName,  DateTime eventDate,  String timeZoneId,  DateTime? openAt,  DateTime? startAt,  DateTime? afterShowMerchandiseStartAt,  DateTime? afterShowMerchandiseEndAt)  $default,) {final _that = this;
switch (_that) {
case _TimetableMetadata():
return $default(_that.eventTitle,_that.venueName,_that.eventDate,_that.timeZoneId,_that.openAt,_that.startAt,_that.afterShowMerchandiseStartAt,_that.afterShowMerchandiseEndAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventTitle,  String venueName,  DateTime eventDate,  String timeZoneId,  DateTime? openAt,  DateTime? startAt,  DateTime? afterShowMerchandiseStartAt,  DateTime? afterShowMerchandiseEndAt)?  $default,) {final _that = this;
switch (_that) {
case _TimetableMetadata() when $default != null:
return $default(_that.eventTitle,_that.venueName,_that.eventDate,_that.timeZoneId,_that.openAt,_that.startAt,_that.afterShowMerchandiseStartAt,_that.afterShowMerchandiseEndAt);case _:
  return null;

}
}

}

/// @nodoc


class _TimetableMetadata extends TimetableMetadata {
  const _TimetableMetadata({required this.eventTitle, required this.venueName, required this.eventDate, required this.timeZoneId, this.openAt, this.startAt, this.afterShowMerchandiseStartAt, this.afterShowMerchandiseEndAt}): super._();
  

@override final  String eventTitle;
@override final  String venueName;
@override final  DateTime eventDate;
@override final  String timeZoneId;
@override final  DateTime? openAt;
@override final  DateTime? startAt;
@override final  DateTime? afterShowMerchandiseStartAt;
@override final  DateTime? afterShowMerchandiseEndAt;

/// Create a copy of TimetableMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableMetadataCopyWith<_TimetableMetadata> get copyWith => __$TimetableMetadataCopyWithImpl<_TimetableMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableMetadata&&(identical(other.eventTitle, eventTitle) || other.eventTitle == eventTitle)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.openAt, openAt) || other.openAt == openAt)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.afterShowMerchandiseStartAt, afterShowMerchandiseStartAt) || other.afterShowMerchandiseStartAt == afterShowMerchandiseStartAt)&&(identical(other.afterShowMerchandiseEndAt, afterShowMerchandiseEndAt) || other.afterShowMerchandiseEndAt == afterShowMerchandiseEndAt));
}


@override
int get hashCode => Object.hash(runtimeType,eventTitle,venueName,eventDate,timeZoneId,openAt,startAt,afterShowMerchandiseStartAt,afterShowMerchandiseEndAt);

@override
String toString() {
  return 'TimetableMetadata(eventTitle: $eventTitle, venueName: $venueName, eventDate: $eventDate, timeZoneId: $timeZoneId, openAt: $openAt, startAt: $startAt, afterShowMerchandiseStartAt: $afterShowMerchandiseStartAt, afterShowMerchandiseEndAt: $afterShowMerchandiseEndAt)';
}


}

/// @nodoc
abstract mixin class _$TimetableMetadataCopyWith<$Res> implements $TimetableMetadataCopyWith<$Res> {
  factory _$TimetableMetadataCopyWith(_TimetableMetadata value, $Res Function(_TimetableMetadata) _then) = __$TimetableMetadataCopyWithImpl;
@override @useResult
$Res call({
 String eventTitle, String venueName, DateTime eventDate, String timeZoneId, DateTime? openAt, DateTime? startAt, DateTime? afterShowMerchandiseStartAt, DateTime? afterShowMerchandiseEndAt
});




}
/// @nodoc
class __$TimetableMetadataCopyWithImpl<$Res>
    implements _$TimetableMetadataCopyWith<$Res> {
  __$TimetableMetadataCopyWithImpl(this._self, this._then);

  final _TimetableMetadata _self;
  final $Res Function(_TimetableMetadata) _then;

/// Create a copy of TimetableMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventTitle = null,Object? venueName = null,Object? eventDate = null,Object? timeZoneId = null,Object? openAt = freezed,Object? startAt = freezed,Object? afterShowMerchandiseStartAt = freezed,Object? afterShowMerchandiseEndAt = freezed,}) {
  return _then(_TimetableMetadata(
eventTitle: null == eventTitle ? _self.eventTitle : eventTitle // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,openAt: freezed == openAt ? _self.openAt : openAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,afterShowMerchandiseStartAt: freezed == afterShowMerchandiseStartAt ? _self.afterShowMerchandiseStartAt : afterShowMerchandiseStartAt // ignore: cast_nullable_to_non_nullable
as DateTime?,afterShowMerchandiseEndAt: freezed == afterShowMerchandiseEndAt ? _self.afterShowMerchandiseEndAt : afterShowMerchandiseEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
