// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_calendar_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetableCalendarEntry {

 int get slotNumber; String get artistName; TimetableCalendarEntryType get type; String get title; String get description; String get location; DateTime get startAt; DateTime get endAt;
/// Create a copy of TimetableCalendarEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableCalendarEntryCopyWith<TimetableCalendarEntry> get copyWith => _$TimetableCalendarEntryCopyWithImpl<TimetableCalendarEntry>(this as TimetableCalendarEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableCalendarEntry&&(identical(other.slotNumber, slotNumber) || other.slotNumber == slotNumber)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt));
}


@override
int get hashCode => Object.hash(runtimeType,slotNumber,artistName,type,title,description,location,startAt,endAt);

@override
String toString() {
  return 'TimetableCalendarEntry(slotNumber: $slotNumber, artistName: $artistName, type: $type, title: $title, description: $description, location: $location, startAt: $startAt, endAt: $endAt)';
}


}

/// @nodoc
abstract mixin class $TimetableCalendarEntryCopyWith<$Res>  {
  factory $TimetableCalendarEntryCopyWith(TimetableCalendarEntry value, $Res Function(TimetableCalendarEntry) _then) = _$TimetableCalendarEntryCopyWithImpl;
@useResult
$Res call({
 int slotNumber, String artistName, TimetableCalendarEntryType type, String title, String description, String location, DateTime startAt, DateTime endAt
});




}
/// @nodoc
class _$TimetableCalendarEntryCopyWithImpl<$Res>
    implements $TimetableCalendarEntryCopyWith<$Res> {
  _$TimetableCalendarEntryCopyWithImpl(this._self, this._then);

  final TimetableCalendarEntry _self;
  final $Res Function(TimetableCalendarEntry) _then;

/// Create a copy of TimetableCalendarEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slotNumber = null,Object? artistName = null,Object? type = null,Object? title = null,Object? description = null,Object? location = null,Object? startAt = null,Object? endAt = null,}) {
  return _then(_self.copyWith(
slotNumber: null == slotNumber ? _self.slotNumber : slotNumber // ignore: cast_nullable_to_non_nullable
as int,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TimetableCalendarEntryType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableCalendarEntry].
extension TimetableCalendarEntryPatterns on TimetableCalendarEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableCalendarEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableCalendarEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableCalendarEntry value)  $default,){
final _that = this;
switch (_that) {
case _TimetableCalendarEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableCalendarEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableCalendarEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int slotNumber,  String artistName,  TimetableCalendarEntryType type,  String title,  String description,  String location,  DateTime startAt,  DateTime endAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableCalendarEntry() when $default != null:
return $default(_that.slotNumber,_that.artistName,_that.type,_that.title,_that.description,_that.location,_that.startAt,_that.endAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int slotNumber,  String artistName,  TimetableCalendarEntryType type,  String title,  String description,  String location,  DateTime startAt,  DateTime endAt)  $default,) {final _that = this;
switch (_that) {
case _TimetableCalendarEntry():
return $default(_that.slotNumber,_that.artistName,_that.type,_that.title,_that.description,_that.location,_that.startAt,_that.endAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int slotNumber,  String artistName,  TimetableCalendarEntryType type,  String title,  String description,  String location,  DateTime startAt,  DateTime endAt)?  $default,) {final _that = this;
switch (_that) {
case _TimetableCalendarEntry() when $default != null:
return $default(_that.slotNumber,_that.artistName,_that.type,_that.title,_that.description,_that.location,_that.startAt,_that.endAt);case _:
  return null;

}
}

}

/// @nodoc


class _TimetableCalendarEntry extends TimetableCalendarEntry {
  const _TimetableCalendarEntry({required this.slotNumber, required this.artistName, required this.type, required this.title, required this.description, required this.location, required this.startAt, required this.endAt}): super._();
  

@override final  int slotNumber;
@override final  String artistName;
@override final  TimetableCalendarEntryType type;
@override final  String title;
@override final  String description;
@override final  String location;
@override final  DateTime startAt;
@override final  DateTime endAt;

/// Create a copy of TimetableCalendarEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableCalendarEntryCopyWith<_TimetableCalendarEntry> get copyWith => __$TimetableCalendarEntryCopyWithImpl<_TimetableCalendarEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableCalendarEntry&&(identical(other.slotNumber, slotNumber) || other.slotNumber == slotNumber)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt));
}


@override
int get hashCode => Object.hash(runtimeType,slotNumber,artistName,type,title,description,location,startAt,endAt);

@override
String toString() {
  return 'TimetableCalendarEntry(slotNumber: $slotNumber, artistName: $artistName, type: $type, title: $title, description: $description, location: $location, startAt: $startAt, endAt: $endAt)';
}


}

/// @nodoc
abstract mixin class _$TimetableCalendarEntryCopyWith<$Res> implements $TimetableCalendarEntryCopyWith<$Res> {
  factory _$TimetableCalendarEntryCopyWith(_TimetableCalendarEntry value, $Res Function(_TimetableCalendarEntry) _then) = __$TimetableCalendarEntryCopyWithImpl;
@override @useResult
$Res call({
 int slotNumber, String artistName, TimetableCalendarEntryType type, String title, String description, String location, DateTime startAt, DateTime endAt
});




}
/// @nodoc
class __$TimetableCalendarEntryCopyWithImpl<$Res>
    implements _$TimetableCalendarEntryCopyWith<$Res> {
  __$TimetableCalendarEntryCopyWithImpl(this._self, this._then);

  final _TimetableCalendarEntry _self;
  final $Res Function(_TimetableCalendarEntry) _then;

/// Create a copy of TimetableCalendarEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slotNumber = null,Object? artistName = null,Object? type = null,Object? title = null,Object? description = null,Object? location = null,Object? startAt = null,Object? endAt = null,}) {
  return _then(_TimetableCalendarEntry(
slotNumber: null == slotNumber ? _self.slotNumber : slotNumber // ignore: cast_nullable_to_non_nullable
as int,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TimetableCalendarEntryType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
