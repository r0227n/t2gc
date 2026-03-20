// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_timetable_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedTimetableImage {

 Uint8List get bytes; String get name;
/// Create a copy of SelectedTimetableImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedTimetableImageCopyWith<SelectedTimetableImage> get copyWith => _$SelectedTimetableImageCopyWithImpl<SelectedTimetableImage>(this as SelectedTimetableImage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedTimetableImage&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),name);

@override
String toString() {
  return 'SelectedTimetableImage(bytes: $bytes, name: $name)';
}


}

/// @nodoc
abstract mixin class $SelectedTimetableImageCopyWith<$Res>  {
  factory $SelectedTimetableImageCopyWith(SelectedTimetableImage value, $Res Function(SelectedTimetableImage) _then) = _$SelectedTimetableImageCopyWithImpl;
@useResult
$Res call({
 Uint8List bytes, String name
});




}
/// @nodoc
class _$SelectedTimetableImageCopyWithImpl<$Res>
    implements $SelectedTimetableImageCopyWith<$Res> {
  _$SelectedTimetableImageCopyWithImpl(this._self, this._then);

  final SelectedTimetableImage _self;
  final $Res Function(SelectedTimetableImage) _then;

/// Create a copy of SelectedTimetableImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bytes = null,Object? name = null,}) {
  return _then(_self.copyWith(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedTimetableImage].
extension SelectedTimetableImagePatterns on SelectedTimetableImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedTimetableImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedTimetableImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedTimetableImage value)  $default,){
final _that = this;
switch (_that) {
case _SelectedTimetableImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedTimetableImage value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedTimetableImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List bytes,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedTimetableImage() when $default != null:
return $default(_that.bytes,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List bytes,  String name)  $default,) {final _that = this;
switch (_that) {
case _SelectedTimetableImage():
return $default(_that.bytes,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List bytes,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SelectedTimetableImage() when $default != null:
return $default(_that.bytes,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedTimetableImage implements SelectedTimetableImage {
  const _SelectedTimetableImage({required this.bytes, required this.name});
  

@override final  Uint8List bytes;
@override final  String name;

/// Create a copy of SelectedTimetableImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedTimetableImageCopyWith<_SelectedTimetableImage> get copyWith => __$SelectedTimetableImageCopyWithImpl<_SelectedTimetableImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedTimetableImage&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bytes),name);

@override
String toString() {
  return 'SelectedTimetableImage(bytes: $bytes, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SelectedTimetableImageCopyWith<$Res> implements $SelectedTimetableImageCopyWith<$Res> {
  factory _$SelectedTimetableImageCopyWith(_SelectedTimetableImage value, $Res Function(_SelectedTimetableImage) _then) = __$SelectedTimetableImageCopyWithImpl;
@override @useResult
$Res call({
 Uint8List bytes, String name
});




}
/// @nodoc
class __$SelectedTimetableImageCopyWithImpl<$Res>
    implements _$SelectedTimetableImageCopyWith<$Res> {
  __$SelectedTimetableImageCopyWithImpl(this._self, this._then);

  final _SelectedTimetableImage _self;
  final $Res Function(_SelectedTimetableImage) _then;

/// Create a copy of SelectedTimetableImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bytes = null,Object? name = null,}) {
  return _then(_SelectedTimetableImage(
bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
