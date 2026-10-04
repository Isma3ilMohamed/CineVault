// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieDetailsEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailsEvent()';
}


}

/// @nodoc
class $MovieDetailsEventCopyWith<$Res>  {
$MovieDetailsEventCopyWith(MovieDetailsEvent _, $Res Function(MovieDetailsEvent) __);
}


/// Adds pattern-matching-related methods to [MovieDetailsEvent].
extension MovieDetailsEventPatterns on MovieDetailsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovieDetailsStarted value)?  started,TResult Function( MovieDetailsRetried value)?  retried,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovieDetailsStarted() when started != null:
return started(_that);case MovieDetailsRetried() when retried != null:
return retried(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovieDetailsStarted value)  started,required TResult Function( MovieDetailsRetried value)  retried,}){
final _that = this;
switch (_that) {
case MovieDetailsStarted():
return started(_that);case MovieDetailsRetried():
return retried(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovieDetailsStarted value)?  started,TResult? Function( MovieDetailsRetried value)?  retried,}){
final _that = this;
switch (_that) {
case MovieDetailsStarted() when started != null:
return started(_that);case MovieDetailsRetried() when retried != null:
return retried(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  retried,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovieDetailsStarted() when started != null:
return started();case MovieDetailsRetried() when retried != null:
return retried();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  retried,}) {final _that = this;
switch (_that) {
case MovieDetailsStarted():
return started();case MovieDetailsRetried():
return retried();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  retried,}) {final _that = this;
switch (_that) {
case MovieDetailsStarted() when started != null:
return started();case MovieDetailsRetried() when retried != null:
return retried();case _:
  return null;

}
}

}

/// @nodoc


class MovieDetailsStarted implements MovieDetailsEvent {
  const MovieDetailsStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailsEvent.started()';
}


}




/// @nodoc


class MovieDetailsRetried implements MovieDetailsEvent {
  const MovieDetailsRetried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsRetried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailsEvent.retried()';
}


}




/// @nodoc
mixin _$MovieDetailsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailsState()';
}


}

/// @nodoc
class $MovieDetailsStateCopyWith<$Res>  {
$MovieDetailsStateCopyWith(MovieDetailsState _, $Res Function(MovieDetailsState) __);
}


/// Adds pattern-matching-related methods to [MovieDetailsState].
extension MovieDetailsStatePatterns on MovieDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovieDetailsInitial value)?  initial,TResult Function( MovieDetailsLoading value)?  loading,TResult Function( MovieDetailsLoaded value)?  loaded,TResult Function( MovieDetailsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovieDetailsInitial() when initial != null:
return initial(_that);case MovieDetailsLoading() when loading != null:
return loading(_that);case MovieDetailsLoaded() when loaded != null:
return loaded(_that);case MovieDetailsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovieDetailsInitial value)  initial,required TResult Function( MovieDetailsLoading value)  loading,required TResult Function( MovieDetailsLoaded value)  loaded,required TResult Function( MovieDetailsError value)  error,}){
final _that = this;
switch (_that) {
case MovieDetailsInitial():
return initial(_that);case MovieDetailsLoading():
return loading(_that);case MovieDetailsLoaded():
return loaded(_that);case MovieDetailsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovieDetailsInitial value)?  initial,TResult? Function( MovieDetailsLoading value)?  loading,TResult? Function( MovieDetailsLoaded value)?  loaded,TResult? Function( MovieDetailsError value)?  error,}){
final _that = this;
switch (_that) {
case MovieDetailsInitial() when initial != null:
return initial(_that);case MovieDetailsLoading() when loading != null:
return loading(_that);case MovieDetailsLoaded() when loaded != null:
return loaded(_that);case MovieDetailsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Movie movie,  List<Movie> similarMovies,  List<CastMember> cast,  List<String> genres,  Video? trailer)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovieDetailsInitial() when initial != null:
return initial();case MovieDetailsLoading() when loading != null:
return loading();case MovieDetailsLoaded() when loaded != null:
return loaded(_that.movie,_that.similarMovies,_that.cast,_that.genres,_that.trailer);case MovieDetailsError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Movie movie,  List<Movie> similarMovies,  List<CastMember> cast,  List<String> genres,  Video? trailer)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case MovieDetailsInitial():
return initial();case MovieDetailsLoading():
return loading();case MovieDetailsLoaded():
return loaded(_that.movie,_that.similarMovies,_that.cast,_that.genres,_that.trailer);case MovieDetailsError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Movie movie,  List<Movie> similarMovies,  List<CastMember> cast,  List<String> genres,  Video? trailer)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case MovieDetailsInitial() when initial != null:
return initial();case MovieDetailsLoading() when loading != null:
return loading();case MovieDetailsLoaded() when loaded != null:
return loaded(_that.movie,_that.similarMovies,_that.cast,_that.genres,_that.trailer);case MovieDetailsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MovieDetailsInitial implements MovieDetailsState {
  const MovieDetailsInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailsState.initial()';
}


}




/// @nodoc


class MovieDetailsLoading implements MovieDetailsState {
  const MovieDetailsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieDetailsState.loading()';
}


}




/// @nodoc


class MovieDetailsLoaded implements MovieDetailsState {
  const MovieDetailsLoaded({required this.movie, required  List<Movie> similarMovies, required  List<CastMember> cast, required  List<String> genres, this.trailer}): _similarMovies = similarMovies,_cast = cast,_genres = genres;
  

 final  Movie movie;
 final  List<Movie> _similarMovies;
 List<Movie> get similarMovies {
  if (_similarMovies is EqualUnmodifiableListView) return _similarMovies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_similarMovies);
}

 final  List<CastMember> _cast;
 List<CastMember> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

/// Genre names for `movie.genreIds`; empty when genres failed to load.
 final  List<String> _genres;
/// Genre names for `movie.genreIds`; empty when genres failed to load.
 List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  Video? trailer;

/// Create a copy of MovieDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailsLoadedCopyWith<MovieDetailsLoaded> get copyWith => _$MovieDetailsLoadedCopyWithImpl<MovieDetailsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsLoaded&&(identical(other.movie, movie) || other.movie == movie)&&const DeepCollectionEquality().equals(other.similarMovies, _similarMovies)&&const DeepCollectionEquality().equals(other.cast, _cast)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.trailer, trailer) || other.trailer == trailer));
}


@override
int get hashCode {
    return Object.hash(runtimeType,movie,const DeepCollectionEquality().hash(_similarMovies),const DeepCollectionEquality().hash(_cast),const DeepCollectionEquality().hash(_genres),trailer);
}

@override
String toString() {
    return 'MovieDetailsState.loaded(movie: $movie, similarMovies: $similarMovies, cast: $cast, genres: $genres, trailer: $trailer)';
}


}

/// @nodoc
abstract mixin class $MovieDetailsLoadedCopyWith<$Res> implements $MovieDetailsStateCopyWith<$Res> {
  factory $MovieDetailsLoadedCopyWith(MovieDetailsLoaded value, $Res Function(MovieDetailsLoaded) _then) = _$MovieDetailsLoadedCopyWithImpl;
@useResult
$Res call({
 Movie movie, List<Movie> similarMovies, List<CastMember> cast, List<String> genres, Video? trailer
});




}
/// @nodoc
class _$MovieDetailsLoadedCopyWithImpl<$Res>
    implements $MovieDetailsLoadedCopyWith<$Res> {
  _$MovieDetailsLoadedCopyWithImpl(this._self, this._then);

  final MovieDetailsLoaded _self;
  final $Res Function(MovieDetailsLoaded) _then;

/// Create a copy of MovieDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? movie = null,Object? similarMovies = null,Object? cast = null,Object? genres = null,Object? trailer = freezed,}) {
  return _then(MovieDetailsLoaded(
movie: null == movie ? _self.movie : movie // ignore: cast_nullable_to_non_nullable
as Movie,similarMovies: null == similarMovies ? _self._similarMovies : similarMovies // ignore: cast_nullable_to_non_nullable
as List<Movie>,cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMember>,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,trailer: freezed == trailer ? _self.trailer : trailer // ignore: cast_nullable_to_non_nullable
as Video?,
  ));
}


}

/// @nodoc


class MovieDetailsError implements MovieDetailsState {
  const MovieDetailsError(this.failure);
  

 final  Failure failure;

/// Create a copy of MovieDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieDetailsErrorCopyWith<MovieDetailsError> get copyWith => _$MovieDetailsErrorCopyWithImpl<MovieDetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieDetailsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'MovieDetailsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MovieDetailsErrorCopyWith<$Res> implements $MovieDetailsStateCopyWith<$Res> {
  factory $MovieDetailsErrorCopyWith(MovieDetailsError value, $Res Function(MovieDetailsError) _then) = _$MovieDetailsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MovieDetailsErrorCopyWithImpl<$Res>
    implements $MovieDetailsErrorCopyWith<$Res> {
  _$MovieDetailsErrorCopyWithImpl(this._self, this._then);

  final MovieDetailsError _self;
  final $Res Function(MovieDetailsError) _then;

/// Create a copy of MovieDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MovieDetailsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
