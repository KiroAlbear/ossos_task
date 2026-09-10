// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteResponse<T> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteResponse<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteResponse<$T>()';
}


}

/// @nodoc
class $RemoteResponseCopyWith<T,$Res>  {
$RemoteResponseCopyWith(RemoteResponse<T> _, $Res Function(RemoteResponse<T>) __);
}


/// Adds pattern-matching-related methods to [RemoteResponse].
extension RemoteResponsePatterns<T> on RemoteResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _NoConnection<T> value)?  noConnection,TResult Function( _Failure<T> value)?  failure,TResult Function( _Data<T> value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoConnection() when noConnection != null:
return noConnection(_that);case _Failure() when failure != null:
return failure(_that);case _Data() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _NoConnection<T> value)  noConnection,required TResult Function( _Failure<T> value)  failure,required TResult Function( _Data<T> value)  data,}){
final _that = this;
switch (_that) {
case _NoConnection():
return noConnection(_that);case _Failure():
return failure(_that);case _Data():
return data(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _NoConnection<T> value)?  noConnection,TResult? Function( _Failure<T> value)?  failure,TResult? Function( _Data<T> value)?  data,}){
final _that = this;
switch (_that) {
case _NoConnection() when noConnection != null:
return noConnection(_that);case _Failure() when failure != null:
return failure(_that);case _Data() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noConnection,TResult Function( String message,  bool success)?  failure,TResult Function( T data)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoConnection() when noConnection != null:
return noConnection();case _Failure() when failure != null:
return failure(_that.message,_that.success);case _Data() when data != null:
return data(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noConnection,required TResult Function( String message,  bool success)  failure,required TResult Function( T data)  data,}) {final _that = this;
switch (_that) {
case _NoConnection():
return noConnection();case _Failure():
return failure(_that.message,_that.success);case _Data():
return data(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noConnection,TResult? Function( String message,  bool success)?  failure,TResult? Function( T data)?  data,}) {final _that = this;
switch (_that) {
case _NoConnection() when noConnection != null:
return noConnection();case _Failure() when failure != null:
return failure(_that.message,_that.success);case _Data() when data != null:
return data(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _NoConnection<T> extends RemoteResponse<T> {
  const _NoConnection(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoConnection<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RemoteResponse<$T>.noConnection()';
}


}




/// @nodoc


class _Failure<T> extends RemoteResponse<T> {
  const _Failure(this.message, this.success): super._();
  

 final  String message;
 final  bool success;

/// Create a copy of RemoteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<T, _Failure<T>> get copyWith => __$FailureCopyWithImpl<T, _Failure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure<T>&&(identical(other.message, message) || other.message == message)&&(identical(other.success, success) || other.success == success));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,success);
}

@override
String toString() {
    return 'RemoteResponse<$T>.failure(message: $message, success: $success)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<T,$Res> implements $RemoteResponseCopyWith<T, $Res> {
  factory _$FailureCopyWith(_Failure<T> value, $Res Function(_Failure<T>) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String message, bool success
});




}
/// @nodoc
class __$FailureCopyWithImpl<T,$Res>
    implements _$FailureCopyWith<T, $Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure<T> _self;
  final $Res Function(_Failure<T>) _then;

/// Create a copy of RemoteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? success = null,}) {
  return _then(_Failure<T>(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Data<T> extends RemoteResponse<T> {
  const _Data(this.data): super._();
  

 final  T data;

/// Create a copy of RemoteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataCopyWith<T, _Data<T>> get copyWith => __$DataCopyWithImpl<T, _Data<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Data<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data));
}

@override
String toString() {
    return 'RemoteResponse<$T>.data(data: $data)';
}


}

/// @nodoc
abstract mixin class _$DataCopyWith<T,$Res> implements $RemoteResponseCopyWith<T, $Res> {
  factory _$DataCopyWith(_Data<T> value, $Res Function(_Data<T>) _then) = __$DataCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class __$DataCopyWithImpl<T,$Res>
    implements _$DataCopyWith<T, $Res> {
  __$DataCopyWithImpl(this._self, this._then);

  final _Data<T> _self;
  final $Res Function(_Data<T>) _then;

/// Create a copy of RemoteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_Data<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

// dart format on
