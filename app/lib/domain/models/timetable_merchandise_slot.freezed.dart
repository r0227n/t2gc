// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_merchandise_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetableMerchandiseSlot {

 int get slotNumber; String get artistName; DateTime get startAt; DateTime get endAt; String get sourceText; String? get boothLabel; bool get isAfterShow;
/// Create a copy of TimetableMerchandiseSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableMerchandiseSlotCopyWith<TimetableMerchandiseSlot> get copyWith => _$TimetableMerchandiseSlotCopyWithImpl<TimetableMerchandiseSlot>(this as TimetableMerchandiseSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableMerchandiseSlot&&(identical(other.slotNumber, slotNumber) || other.slotNumber == slotNumber)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.boothLabel, boothLabel) || other.boothLabel == boothLabel)&&(identical(other.isAfterShow, isAfterShow) || other.isAfterShow == isAfterShow));
}


@override
int get hashCode => Object.hash(runtimeType,slotNumber,artistName,startAt,endAt,sourceText,boothLabel,isAfterShow);

@override
String toString() {
  return 'TimetableMerchandiseSlot(slotNumber: $slotNumber, artistName: $artistName, startAt: $startAt, endAt: $endAt, sourceText: $sourceText, boothLabel: $boothLabel, isAfterShow: $isAfterShow)';
}


}

/// @nodoc
abstract mixin class $TimetableMerchandiseSlotCopyWith<$Res>  {
  factory $TimetableMerchandiseSlotCopyWith(TimetableMerchandiseSlot value, $Res Function(TimetableMerchandiseSlot) _then) = _$TimetableMerchandiseSlotCopyWithImpl;
@useResult
$Res call({
 int slotNumber, String artistName, DateTime startAt, DateTime endAt, String sourceText, String? boothLabel, bool isAfterShow
});




}
/// @nodoc
class _$TimetableMerchandiseSlotCopyWithImpl<$Res>
    implements $TimetableMerchandiseSlotCopyWith<$Res> {
  _$TimetableMerchandiseSlotCopyWithImpl(this._self, this._then);

  final TimetableMerchandiseSlot _self;
  final $Res Function(TimetableMerchandiseSlot) _then;

/// Create a copy of TimetableMerchandiseSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slotNumber = null,Object? artistName = null,Object? startAt = null,Object? endAt = null,Object? sourceText = null,Object? boothLabel = freezed,Object? isAfterShow = null,}) {
  return _then(_self.copyWith(
slotNumber: null == slotNumber ? _self.slotNumber : slotNumber // ignore: cast_nullable_to_non_nullable
as int,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,boothLabel: freezed == boothLabel ? _self.boothLabel : boothLabel // ignore: cast_nullable_to_non_nullable
as String?,isAfterShow: null == isAfterShow ? _self.isAfterShow : isAfterShow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableMerchandiseSlot].
extension TimetableMerchandiseSlotPatterns on TimetableMerchandiseSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableMerchandiseSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableMerchandiseSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableMerchandiseSlot value)  $default,){
final _that = this;
switch (_that) {
case _TimetableMerchandiseSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableMerchandiseSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableMerchandiseSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int slotNumber,  String artistName,  DateTime startAt,  DateTime endAt,  String sourceText,  String? boothLabel,  bool isAfterShow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableMerchandiseSlot() when $default != null:
return $default(_that.slotNumber,_that.artistName,_that.startAt,_that.endAt,_that.sourceText,_that.boothLabel,_that.isAfterShow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int slotNumber,  String artistName,  DateTime startAt,  DateTime endAt,  String sourceText,  String? boothLabel,  bool isAfterShow)  $default,) {final _that = this;
switch (_that) {
case _TimetableMerchandiseSlot():
return $default(_that.slotNumber,_that.artistName,_that.startAt,_that.endAt,_that.sourceText,_that.boothLabel,_that.isAfterShow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int slotNumber,  String artistName,  DateTime startAt,  DateTime endAt,  String sourceText,  String? boothLabel,  bool isAfterShow)?  $default,) {final _that = this;
switch (_that) {
case _TimetableMerchandiseSlot() when $default != null:
return $default(_that.slotNumber,_that.artistName,_that.startAt,_that.endAt,_that.sourceText,_that.boothLabel,_that.isAfterShow);case _:
  return null;

}
}

}

/// @nodoc


class _TimetableMerchandiseSlot extends TimetableMerchandiseSlot {
  const _TimetableMerchandiseSlot({required this.slotNumber, required this.artistName, required this.startAt, required this.endAt, required this.sourceText, this.boothLabel, this.isAfterShow = false}): super._();
  

@override final  int slotNumber;
@override final  String artistName;
@override final  DateTime startAt;
@override final  DateTime endAt;
@override final  String sourceText;
@override final  String? boothLabel;
@override@JsonKey() final  bool isAfterShow;

/// Create a copy of TimetableMerchandiseSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableMerchandiseSlotCopyWith<_TimetableMerchandiseSlot> get copyWith => __$TimetableMerchandiseSlotCopyWithImpl<_TimetableMerchandiseSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableMerchandiseSlot&&(identical(other.slotNumber, slotNumber) || other.slotNumber == slotNumber)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.boothLabel, boothLabel) || other.boothLabel == boothLabel)&&(identical(other.isAfterShow, isAfterShow) || other.isAfterShow == isAfterShow));
}


@override
int get hashCode => Object.hash(runtimeType,slotNumber,artistName,startAt,endAt,sourceText,boothLabel,isAfterShow);

@override
String toString() {
  return 'TimetableMerchandiseSlot(slotNumber: $slotNumber, artistName: $artistName, startAt: $startAt, endAt: $endAt, sourceText: $sourceText, boothLabel: $boothLabel, isAfterShow: $isAfterShow)';
}


}

/// @nodoc
abstract mixin class _$TimetableMerchandiseSlotCopyWith<$Res> implements $TimetableMerchandiseSlotCopyWith<$Res> {
  factory _$TimetableMerchandiseSlotCopyWith(_TimetableMerchandiseSlot value, $Res Function(_TimetableMerchandiseSlot) _then) = __$TimetableMerchandiseSlotCopyWithImpl;
@override @useResult
$Res call({
 int slotNumber, String artistName, DateTime startAt, DateTime endAt, String sourceText, String? boothLabel, bool isAfterShow
});




}
/// @nodoc
class __$TimetableMerchandiseSlotCopyWithImpl<$Res>
    implements _$TimetableMerchandiseSlotCopyWith<$Res> {
  __$TimetableMerchandiseSlotCopyWithImpl(this._self, this._then);

  final _TimetableMerchandiseSlot _self;
  final $Res Function(_TimetableMerchandiseSlot) _then;

/// Create a copy of TimetableMerchandiseSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slotNumber = null,Object? artistName = null,Object? startAt = null,Object? endAt = null,Object? sourceText = null,Object? boothLabel = freezed,Object? isAfterShow = null,}) {
  return _then(_TimetableMerchandiseSlot(
slotNumber: null == slotNumber ? _self.slotNumber : slotNumber // ignore: cast_nullable_to_non_nullable
as int,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,boothLabel: freezed == boothLabel ? _self.boothLabel : boothLabel // ignore: cast_nullable_to_non_nullable
as String?,isAfterShow: null == isAfterShow ? _self.isAfterShow : isAfterShow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
