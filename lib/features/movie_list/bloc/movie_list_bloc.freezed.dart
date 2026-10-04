// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieListEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListEvent()';
}


}

/// @nodoc
class $MovieListEventCopyWith<$Res>  {
$MovieListEventCopyWith(MovieListEvent _, $Res Function(MovieListEvent) __);
}


/// Adds pattern-matching-related methods to [MovieListEvent].
extension MovieListEventPatterns on MovieListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovieListStarted value)?  started,TResult Function( MovieListRetried value)?  retried,TResult Function( MovieListLoadMoreRequested value)?  loadMoreRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovieListStarted() when started != null:
return started(_that);case MovieListRetried() when retried != null:
return retried(_that);case MovieListLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovieListStarted value)  started,required TResult Function( MovieListRetried value)  retried,required TResult Function( MovieListLoadMoreRequested value)  loadMoreRequested,}){
final _that = this;
switch (_that) {
case MovieListStarted():
return started(_that);case MovieListRetried():
return retried(_that);case MovieListLoadMoreRequested():
return loadMoreRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovieListStarted value)?  started,TResult? Function( MovieListRetried value)?  retried,TResult? Function( MovieListLoadMoreRequested value)?  loadMoreRequested,}){
final _that = this;
switch (_that) {
case MovieListStarted() when started != null:
return started(_that);case MovieListRetried() when retried != null:
return retried(_that);case MovieListLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  retried,TResult Function()?  loadMoreRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovieListStarted() when started != null:
return started();case MovieListRetried() when retried != null:
return retried();case MovieListLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  retried,required TResult Function()  loadMoreRequested,}) {final _that = this;
switch (_that) {
case MovieListStarted():
return started();case MovieListRetried():
return retried();case MovieListLoadMoreRequested():
return loadMoreRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  retried,TResult? Function()?  loadMoreRequested,}) {final _that = this;
switch (_that) {
case MovieListStarted() when started != null:
return started();case MovieListRetried() when retried != null:
return retried();case MovieListLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case _:
  return null;

}
}

}

/// @nodoc


class MovieListStarted implements MovieListEvent {
  const MovieListStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListEvent.started()';
}


}




/// @nodoc


class MovieListRetried implements MovieListEvent {
  const MovieListRetried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListRetried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListEvent.retried()';
}


}




/// @nodoc


class MovieListLoadMoreRequested implements MovieListEvent {
  const MovieListLoadMoreRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListLoadMoreRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListEvent.loadMoreRequested()';
}


}




/// @nodoc
mixin _$MovieListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListState()';
}


}

/// @nodoc
class $MovieListStateCopyWith<$Res>  {
$MovieListStateCopyWith(MovieListState _, $Res Function(MovieListState) __);
}


/// Adds pattern-matching-related methods to [MovieListState].
extension MovieListStatePatterns on MovieListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MovieListInitial value)?  initial,TResult Function( MovieListLoading value)?  loading,TResult Function( MovieListLoaded value)?  loaded,TResult Function( MovieListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial(_that);case MovieListLoading() when loading != null:
return loading(_that);case MovieListLoaded() when loaded != null:
return loaded(_that);case MovieListError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MovieListInitial value)  initial,required TResult Function( MovieListLoading value)  loading,required TResult Function( MovieListLoaded value)  loaded,required TResult Function( MovieListError value)  error,}){
final _that = this;
switch (_that) {
case MovieListInitial():
return initial(_that);case MovieListLoading():
return loading(_that);case MovieListLoaded():
return loaded(_that);case MovieListError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MovieListInitial value)?  initial,TResult? Function( MovieListLoading value)?  loading,TResult? Function( MovieListLoaded value)?  loaded,TResult? Function( MovieListError value)?  error,}){
final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial(_that);case MovieListLoading() when loading != null:
return loading(_that);case MovieListLoaded() when loaded != null:
return loaded(_that);case MovieListError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Movie> movies,  int page,  bool hasReachedMax,  bool isLoadingMore)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial();case MovieListLoading() when loading != null:
return loading();case MovieListLoaded() when loaded != null:
return loaded(_that.movies,_that.page,_that.hasReachedMax,_that.isLoadingMore);case MovieListError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Movie> movies,  int page,  bool hasReachedMax,  bool isLoadingMore)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case MovieListInitial():
return initial();case MovieListLoading():
return loading();case MovieListLoaded():
return loaded(_that.movies,_that.page,_that.hasReachedMax,_that.isLoadingMore);case MovieListError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Movie> movies,  int page,  bool hasReachedMax,  bool isLoadingMore)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case MovieListInitial() when initial != null:
return initial();case MovieListLoading() when loading != null:
return loading();case MovieListLoaded() when loaded != null:
return loaded(_that.movies,_that.page,_that.hasReachedMax,_that.isLoadingMore);case MovieListError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MovieListInitial implements MovieListState {
  const MovieListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListState.initial()';
}


}




/// @nodoc


class MovieListLoading implements MovieListState {
  const MovieListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MovieListState.loading()';
}


}




/// @nodoc


class MovieListLoaded implements MovieListState {
  const MovieListLoaded({required  List<Movie> movies, required this.page, required this.hasReachedMax, this.isLoadingMore = false}): _movies = movies;
  

 final  List<Movie> _movies;
 List<Movie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

 final  int page;
 final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListLoadedCopyWith<MovieListLoaded> get copyWith => _$MovieListLoadedCopyWithImpl<MovieListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListLoaded&&const DeepCollectionEquality().equals(other.movies, _movies)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_movies),page,hasReachedMax,isLoadingMore);
}

@override
String toString() {
    return 'MovieListState.loaded(movies: $movies, page: $page, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $MovieListLoadedCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory $MovieListLoadedCopyWith(MovieListLoaded value, $Res Function(MovieListLoaded) _then) = _$MovieListLoadedCopyWithImpl;
@useResult
$Res call({
 List<Movie> movies, int page, bool hasReachedMax, bool isLoadingMore
});




}
/// @nodoc
class _$MovieListLoadedCopyWithImpl<$Res>
    implements $MovieListLoadedCopyWith<$Res> {
  _$MovieListLoadedCopyWithImpl(this._self, this._then);

  final MovieListLoaded _self;
  final $Res Function(MovieListLoaded) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? movies = null,Object? page = null,Object? hasReachedMax = null,Object? isLoadingMore = null,}) {
  return _then(MovieListLoaded(
movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<Movie>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MovieListError implements MovieListState {
  const MovieListError(this.failure);
  

 final  Failure failure;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieListErrorCopyWith<MovieListError> get copyWith => _$MovieListErrorCopyWithImpl<MovieListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieListError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'MovieListState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MovieListErrorCopyWith<$Res> implements $MovieListStateCopyWith<$Res> {
  factory $MovieListErrorCopyWith(MovieListError value, $Res Function(MovieListError) _then) = _$MovieListErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MovieListErrorCopyWithImpl<$Res>
    implements $MovieListErrorCopyWith<$Res> {
  _$MovieListErrorCopyWithImpl(this._self, this._then);

  final MovieListError _self;
  final $Res Function(MovieListError) _then;

/// Create a copy of MovieListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MovieListError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
