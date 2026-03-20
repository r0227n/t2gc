// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_performance_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetablePerformanceSlot {

 int get slotNumber; String get artistName; DateTime get startAt; DateTime get endAt; String get sourceText;
/// Create a copy of TimetablePerformanceSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetablePerformanceSlotCopyWith<TimetablePerformanceSlot> get copyWith => _$TimetablePerformanceSlotCopyWithImpl<TimetablePerformanceSlot>(this as TimetablePerformanceSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetablePerformanceSlot&&(identical(other.slotNumber, slotNumber) || other.slotNumber == slotNumber)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText));
}


@override
int get hashCode => Object.hash(runtimeType,slotNumber,artistName,startAt,endAt,sourceText);

@override
String toString() {
  return 'TimetablePerformanceSlot(slotNumber: $slotNumber, artistName: $artistName, startAt: $startAt, endAt: $endAt, sourceText: $sourceText)';
}


}

/// @nodoc
abstract mixin class $TimetablePerformanceSlotCopyWith<$Res>  {
  factory $TimetablePerformanceSlotCopyWith(TimetablePerformanceSlot value, $Res Function(TimetablePerformanceSlot) _then) = _$TimetablePerformanceSlotCopyWithImpl;
@useResult
$Res call({
 int slotNumber, String artistName, DateTime startAt, DateTime endAt, String sourceText
});




}
/// @nodoc
class _$TimetablePerformanceSlotCopyWithImpl<$Res>
    implements $TimetablePerformanceSlotCopyWith<$Res> {
  _$TimetablePerformanceSlotCopyWithImpl(this._self, this._then);

  final TimetablePerformanceSlot _self;
  final $Res Function(TimetablePerformanceSlot) _then;

/// Create a copy of TimetablePerformanceSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slotNumber = null,Object? artistName = null,Object? startAt = null,Object? endAt = null,Object? sourceText = null,}) {
  return _then(_self.copyWith(
slotNumber: null == slotNumber ? _self.slotNumber : slotNumber // ignore: cast_nullable_to_non_nullable
as int,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetablePerformanceSlot].
extension TimetablePerformanceSlotPatterns on TimetablePerformanceSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetablePerformanceSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetablePerformanceSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetablePerformanceSlot value)  $default,){
final _that = this;
switch (_that) {
case _TimetablePerformanceSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetablePerformanceSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TimetablePerformanceSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int slotNumber,  String artistName,  DateTime startAt,  DateTime endAt,  String sourceText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetablePerformanceSlot() when $default != null:
return $default(_that.slotNumber,_that.artistName,_that.startAt,_that.endAt,_that.sourceText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int slotNumber,  String artistName,  DateTime startAt,  DateTime endAt,  String sourceText)  $default,) {final _that = this;
switch (_that) {
case _TimetablePerformanceSlot():
return $default(_that.slotNumber,_that.artistName,_that.startAt,_that.endAt,_that.sourceText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int slotNumber,  String artistName,  DateTime startAt,  DateTime endAt,  String sourceText)?  $default,) {final _that = this;
switch (_that) {
case _TimetablePerformanceSlot() when $default != null:
return $default(_that.slotNumber,_that.artistName,_that.startAt,_that.endAt,_that.sourceText);case _:
  return null;

}
}

}

/// @nodoc


class _TimetablePerformanceSlot extends TimetablePerformanceSlot {
  const _TimetablePerformanceSlot({required this.slotNumber, required this.artistName, required this.startAt, required this.endAt, required this.sourceText}): super._();
  

@override final  int slotNumber;
@override final  String artistName;
@override final  DateTime startAt;
@override final  DateTime endAt;
@override final  String sourceText;

/// Create a copy of TimetablePerformanceSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetablePerformanceSlotCopyWith<_TimetablePerformanceSlot> get copyWith => __$TimetablePerformanceSlotCopyWithImpl<_TimetablePerformanceSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetablePerformanceSlot&&(identical(other.slotNumber, slotNumber) || other.slotNumber == slotNumber)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText));
}


@override
int get hashCode => Object.hash(runtimeType,slotNumber,artistName,startAt,endAt,sourceText);

@override
String toString() {
  return 'TimetablePerformanceSlot(slotNumber: $slotNumber, artistName: $artistName, startAt: $startAt, endAt: $endAt, sourceText: $sourceText)';
}


}

/// @nodoc
abstract mixin class _$TimetablePerformanceSlotCopyWith<$Res> implements $TimetablePerformanceSlotCopyWith<$Res> {
  factory _$TimetablePerformanceSlotCopyWith(_TimetablePerformanceSlot value, $Res Function(_TimetablePerformanceSlot) _then) = __$TimetablePerformanceSlotCopyWithImpl;
@override @useResult
$Res call({
 int slotNumber, String artistName, DateTime startAt, DateTime endAt, String sourceText
});




}
/// @nodoc
class __$TimetablePerformanceSlotCopyWithImpl<$Res>
    implements _$TimetablePerformanceSlotCopyWith<$Res> {
  __$TimetablePerformanceSlotCopyWithImpl(this._self, this._then);

  final _TimetablePerformanceSlot _self;
  final $Res Function(_TimetablePerformanceSlot) _then;

/// Create a copy of TimetablePerformanceSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slotNumber = null,Object? artistName = null,Object? startAt = null,Object? endAt = null,Object? sourceText = null,}) {
  return _then(_TimetablePerformanceSlot(
slotNumber: null == slotNumber ? _self.slotNumber : slotNumber // ignore: cast_nullable_to_non_nullable
as int,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
