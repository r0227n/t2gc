// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_scan_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetableScanState implements DiagnosticableTreeMixin {

 Uint8List? get imageBytes; String get imageName; String get statusMessage; bool get isBusy; TimetableScanResult? get scanResult; Set<int> get selectedSlots;
/// Create a copy of TimetableScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableScanStateCopyWith<TimetableScanState> get copyWith => _$TimetableScanStateCopyWithImpl<TimetableScanState>(this as TimetableScanState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TimetableScanState'))
    ..add(DiagnosticsProperty('imageBytes', imageBytes))..add(DiagnosticsProperty('imageName', imageName))..add(DiagnosticsProperty('statusMessage', statusMessage))..add(DiagnosticsProperty('isBusy', isBusy))..add(DiagnosticsProperty('scanResult', scanResult))..add(DiagnosticsProperty('selectedSlots', selectedSlots));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableScanState&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes)&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.scanResult, scanResult) || other.scanResult == scanResult)&&const DeepCollectionEquality().equals(other.selectedSlots, selectedSlots));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(imageBytes),imageName,statusMessage,isBusy,scanResult,const DeepCollectionEquality().hash(selectedSlots));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TimetableScanState(imageBytes: $imageBytes, imageName: $imageName, statusMessage: $statusMessage, isBusy: $isBusy, scanResult: $scanResult, selectedSlots: $selectedSlots)';
}


}

/// @nodoc
abstract mixin class $TimetableScanStateCopyWith<$Res>  {
  factory $TimetableScanStateCopyWith(TimetableScanState value, $Res Function(TimetableScanState) _then) = _$TimetableScanStateCopyWithImpl;
@useResult
$Res call({
 Uint8List? imageBytes, String imageName, String statusMessage, bool isBusy, TimetableScanResult? scanResult, Set<int> selectedSlots
});


$TimetableScanResultCopyWith<$Res>? get scanResult;

}
/// @nodoc
class _$TimetableScanStateCopyWithImpl<$Res>
    implements $TimetableScanStateCopyWith<$Res> {
  _$TimetableScanStateCopyWithImpl(this._self, this._then);

  final TimetableScanState _self;
  final $Res Function(TimetableScanState) _then;

/// Create a copy of TimetableScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageBytes = freezed,Object? imageName = null,Object? statusMessage = null,Object? isBusy = null,Object? scanResult = freezed,Object? selectedSlots = null,}) {
  return _then(_self.copyWith(
imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,scanResult: freezed == scanResult ? _self.scanResult : scanResult // ignore: cast_nullable_to_non_nullable
as TimetableScanResult?,selectedSlots: null == selectedSlots ? _self.selectedSlots : selectedSlots // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}
/// Create a copy of TimetableScanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableScanResultCopyWith<$Res>? get scanResult {
    if (_self.scanResult == null) {
    return null;
  }

  return $TimetableScanResultCopyWith<$Res>(_self.scanResult!, (value) {
    return _then(_self.copyWith(scanResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimetableScanState].
extension TimetableScanStatePatterns on TimetableScanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableScanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableScanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableScanState value)  $default,){
final _that = this;
switch (_that) {
case _TimetableScanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableScanState value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableScanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List? imageBytes,  String imageName,  String statusMessage,  bool isBusy,  TimetableScanResult? scanResult,  Set<int> selectedSlots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableScanState() when $default != null:
return $default(_that.imageBytes,_that.imageName,_that.statusMessage,_that.isBusy,_that.scanResult,_that.selectedSlots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List? imageBytes,  String imageName,  String statusMessage,  bool isBusy,  TimetableScanResult? scanResult,  Set<int> selectedSlots)  $default,) {final _that = this;
switch (_that) {
case _TimetableScanState():
return $default(_that.imageBytes,_that.imageName,_that.statusMessage,_that.isBusy,_that.scanResult,_that.selectedSlots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List? imageBytes,  String imageName,  String statusMessage,  bool isBusy,  TimetableScanResult? scanResult,  Set<int> selectedSlots)?  $default,) {final _that = this;
switch (_that) {
case _TimetableScanState() when $default != null:
return $default(_that.imageBytes,_that.imageName,_that.statusMessage,_that.isBusy,_that.scanResult,_that.selectedSlots);case _:
  return null;

}
}

}

/// @nodoc


class _TimetableScanState extends TimetableScanState with DiagnosticableTreeMixin {
  const _TimetableScanState({this.imageBytes, this.imageName = '', this.statusMessage = TimetableScanState.initialStatusMessage, this.isBusy = false, this.scanResult, final  Set<int> selectedSlots = const <int>{}}): _selectedSlots = selectedSlots,super._();
  

@override final  Uint8List? imageBytes;
@override@JsonKey() final  String imageName;
@override@JsonKey() final  String statusMessage;
@override@JsonKey() final  bool isBusy;
@override final  TimetableScanResult? scanResult;
 final  Set<int> _selectedSlots;
@override@JsonKey() Set<int> get selectedSlots {
  if (_selectedSlots is EqualUnmodifiableSetView) return _selectedSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedSlots);
}


/// Create a copy of TimetableScanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableScanStateCopyWith<_TimetableScanState> get copyWith => __$TimetableScanStateCopyWithImpl<_TimetableScanState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TimetableScanState'))
    ..add(DiagnosticsProperty('imageBytes', imageBytes))..add(DiagnosticsProperty('imageName', imageName))..add(DiagnosticsProperty('statusMessage', statusMessage))..add(DiagnosticsProperty('isBusy', isBusy))..add(DiagnosticsProperty('scanResult', scanResult))..add(DiagnosticsProperty('selectedSlots', selectedSlots));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableScanState&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes)&&(identical(other.imageName, imageName) || other.imageName == imageName)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.scanResult, scanResult) || other.scanResult == scanResult)&&const DeepCollectionEquality().equals(other._selectedSlots, _selectedSlots));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(imageBytes),imageName,statusMessage,isBusy,scanResult,const DeepCollectionEquality().hash(_selectedSlots));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TimetableScanState(imageBytes: $imageBytes, imageName: $imageName, statusMessage: $statusMessage, isBusy: $isBusy, scanResult: $scanResult, selectedSlots: $selectedSlots)';
}


}

/// @nodoc
abstract mixin class _$TimetableScanStateCopyWith<$Res> implements $TimetableScanStateCopyWith<$Res> {
  factory _$TimetableScanStateCopyWith(_TimetableScanState value, $Res Function(_TimetableScanState) _then) = __$TimetableScanStateCopyWithImpl;
@override @useResult
$Res call({
 Uint8List? imageBytes, String imageName, String statusMessage, bool isBusy, TimetableScanResult? scanResult, Set<int> selectedSlots
});


@override $TimetableScanResultCopyWith<$Res>? get scanResult;

}
/// @nodoc
class __$TimetableScanStateCopyWithImpl<$Res>
    implements _$TimetableScanStateCopyWith<$Res> {
  __$TimetableScanStateCopyWithImpl(this._self, this._then);

  final _TimetableScanState _self;
  final $Res Function(_TimetableScanState) _then;

/// Create a copy of TimetableScanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageBytes = freezed,Object? imageName = null,Object? statusMessage = null,Object? isBusy = null,Object? scanResult = freezed,Object? selectedSlots = null,}) {
  return _then(_TimetableScanState(
imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,imageName: null == imageName ? _self.imageName : imageName // ignore: cast_nullable_to_non_nullable
as String,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,scanResult: freezed == scanResult ? _self.scanResult : scanResult // ignore: cast_nullable_to_non_nullable
as TimetableScanResult?,selectedSlots: null == selectedSlots ? _self._selectedSlots : selectedSlots // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}

/// Create a copy of TimetableScanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableScanResultCopyWith<$Res>? get scanResult {
    if (_self.scanResult == null) {
    return null;
  }

  return $TimetableScanResultCopyWith<$Res>(_self.scanResult!, (value) {
    return _then(_self.copyWith(scanResult: value));
  });
}
}

// dart format on
