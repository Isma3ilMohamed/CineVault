// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent()';
}


}

/// @nodoc
class $SearchEventCopyWith<$Res>  {
$SearchEventCopyWith(SearchEvent _, $Res Function(SearchEvent) __);
}


/// Adds pattern-matching-related methods to [SearchEvent].
extension SearchEventPatterns on SearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchStarted value)?  started,TResult Function( SearchQueryChanged value)?  queryChanged,TResult Function( RecentSearchTapped value)?  recentSearchTapped,TResult Function( SearchCleared value)?  cleared,TResult Function( SearchLoadMoreRequested value)?  loadMoreRequested,TResult Function( SearchRetried value)?  retried,TResult Function( RecentSearchesCleared value)?  recentSearchesCleared,TResult Function( SearchRequested value)?  requested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started(_that);case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case RecentSearchTapped() when recentSearchTapped != null:
return recentSearchTapped(_that);case SearchCleared() when cleared != null:
return cleared(_that);case SearchLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case SearchRetried() when retried != null:
return retried(_that);case RecentSearchesCleared() when recentSearchesCleared != null:
return recentSearchesCleared(_that);case SearchRequested() when requested != null:
return requested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchStarted value)  started,required TResult Function( SearchQueryChanged value)  queryChanged,required TResult Function( RecentSearchTapped value)  recentSearchTapped,required TResult Function( SearchCleared value)  cleared,required TResult Function( SearchLoadMoreRequested value)  loadMoreRequested,required TResult Function( SearchRetried value)  retried,required TResult Function( RecentSearchesCleared value)  recentSearchesCleared,required TResult Function( SearchRequested value)  requested,}){
final _that = this;
switch (_that) {
case SearchStarted():
return started(_that);case SearchQueryChanged():
return queryChanged(_that);case RecentSearchTapped():
return recentSearchTapped(_that);case SearchCleared():
return cleared(_that);case SearchLoadMoreRequested():
return loadMoreRequested(_that);case SearchRetried():
return retried(_that);case RecentSearchesCleared():
return recentSearchesCleared(_that);case SearchRequested():
return requested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchStarted value)?  started,TResult? Function( SearchQueryChanged value)?  queryChanged,TResult? Function( RecentSearchTapped value)?  recentSearchTapped,TResult? Function( SearchCleared value)?  cleared,TResult? Function( SearchLoadMoreRequested value)?  loadMoreRequested,TResult? Function( SearchRetried value)?  retried,TResult? Function( RecentSearchesCleared value)?  recentSearchesCleared,TResult? Function( SearchRequested value)?  requested,}){
final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started(_that);case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case RecentSearchTapped() when recentSearchTapped != null:
return recentSearchTapped(_that);case SearchCleared() when cleared != null:
return cleared(_that);case SearchLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested(_that);case SearchRetried() when retried != null:
return retried(_that);case RecentSearchesCleared() when recentSearchesCleared != null:
return recentSearchesCleared(_that);case SearchRequested() when requested != null:
return requested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String query)?  queryChanged,TResult Function( String query)?  recentSearchTapped,TResult Function()?  cleared,TResult Function()?  loadMoreRequested,TResult Function()?  retried,TResult Function()?  recentSearchesCleared,TResult Function( String query)?  requested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started();case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case RecentSearchTapped() when recentSearchTapped != null:
return recentSearchTapped(_that.query);case SearchCleared() when cleared != null:
return cleared();case SearchLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case SearchRetried() when retried != null:
return retried();case RecentSearchesCleared() when recentSearchesCleared != null:
return recentSearchesCleared();case SearchRequested() when requested != null:
return requested(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String query)  queryChanged,required TResult Function( String query)  recentSearchTapped,required TResult Function()  cleared,required TResult Function()  loadMoreRequested,required TResult Function()  retried,required TResult Function()  recentSearchesCleared,required TResult Function( String query)  requested,}) {final _that = this;
switch (_that) {
case SearchStarted():
return started();case SearchQueryChanged():
return queryChanged(_that.query);case RecentSearchTapped():
return recentSearchTapped(_that.query);case SearchCleared():
return cleared();case SearchLoadMoreRequested():
return loadMoreRequested();case SearchRetried():
return retried();case RecentSearchesCleared():
return recentSearchesCleared();case SearchRequested():
return requested(_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String query)?  queryChanged,TResult? Function( String query)?  recentSearchTapped,TResult? Function()?  cleared,TResult? Function()?  loadMoreRequested,TResult? Function()?  retried,TResult? Function()?  recentSearchesCleared,TResult? Function( String query)?  requested,}) {final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started();case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case RecentSearchTapped() when recentSearchTapped != null:
return recentSearchTapped(_that.query);case SearchCleared() when cleared != null:
return cleared();case SearchLoadMoreRequested() when loadMoreRequested != null:
return loadMoreRequested();case SearchRetried() when retried != null:
return retried();case RecentSearchesCleared() when recentSearchesCleared != null:
return recentSearchesCleared();case SearchRequested() when requested != null:
return requested(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class SearchStarted implements SearchEvent {
  const SearchStarted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.started()';
}


}




/// @nodoc


class SearchQueryChanged implements SearchEvent {
  const SearchQueryChanged(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchQueryChangedCopyWith<SearchQueryChanged> get copyWith => _$SearchQueryChangedCopyWithImpl<SearchQueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchQueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchQueryChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchQueryChangedCopyWith(SearchQueryChanged value, $Res Function(SearchQueryChanged) _then) = _$SearchQueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchQueryChangedCopyWithImpl<$Res>
    implements $SearchQueryChangedCopyWith<$Res> {
  _$SearchQueryChangedCopyWithImpl(this._self, this._then);

  final SearchQueryChanged _self;
  final $Res Function(SearchQueryChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchQueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RecentSearchTapped implements SearchEvent {
  const RecentSearchTapped(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentSearchTappedCopyWith<RecentSearchTapped> get copyWith => _$RecentSearchTappedCopyWithImpl<RecentSearchTapped>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentSearchTapped&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchEvent.recentSearchTapped(query: $query)';
}


}

/// @nodoc
abstract mixin class $RecentSearchTappedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $RecentSearchTappedCopyWith(RecentSearchTapped value, $Res Function(RecentSearchTapped) _then) = _$RecentSearchTappedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$RecentSearchTappedCopyWithImpl<$Res>
    implements $RecentSearchTappedCopyWith<$Res> {
  _$RecentSearchTappedCopyWithImpl(this._self, this._then);

  final RecentSearchTapped _self;
  final $Res Function(RecentSearchTapped) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(RecentSearchTapped(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchCleared implements SearchEvent {
  const SearchCleared();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.cleared()';
}


}




/// @nodoc


class SearchLoadMoreRequested implements SearchEvent {
  const SearchLoadMoreRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoadMoreRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.loadMoreRequested()';
}


}




/// @nodoc


class SearchRetried implements SearchEvent {
  const SearchRetried();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRetried);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.retried()';
}


}




/// @nodoc


class RecentSearchesCleared implements SearchEvent {
  const RecentSearchesCleared();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentSearchesCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchEvent.recentSearchesCleared()';
}


}




/// @nodoc


class SearchRequested implements SearchEvent {
  const SearchRequested(this.query);
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchRequestedCopyWith<SearchRequested> get copyWith => _$SearchRequestedCopyWithImpl<SearchRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRequested&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchEvent.requested(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchRequestedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchRequestedCopyWith(SearchRequested value, $Res Function(SearchRequested) _then) = _$SearchRequestedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchRequestedCopyWithImpl<$Res>
    implements $SearchRequestedCopyWith<$Res> {
  _$SearchRequestedCopyWithImpl(this._self, this._then);

  final SearchRequested _self;
  final $Res Function(SearchRequested) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchRequested(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchIdle value)?  idle,TResult Function( SearchLoading value)?  loading,TResult Function( SearchLoaded value)?  loaded,TResult Function( SearchEmpty value)?  empty,TResult Function( SearchError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchLoaded() when loaded != null:
return loaded(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchIdle value)  idle,required TResult Function( SearchLoading value)  loading,required TResult Function( SearchLoaded value)  loaded,required TResult Function( SearchEmpty value)  empty,required TResult Function( SearchError value)  error,}){
final _that = this;
switch (_that) {
case SearchIdle():
return idle(_that);case SearchLoading():
return loading(_that);case SearchLoaded():
return loaded(_that);case SearchEmpty():
return empty(_that);case SearchError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchIdle value)?  idle,TResult? Function( SearchLoading value)?  loading,TResult? Function( SearchLoaded value)?  loaded,TResult? Function( SearchEmpty value)?  empty,TResult? Function( SearchError value)?  error,}){
final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchLoaded() when loaded != null:
return loaded(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<String> recentSearches)?  idle,TResult Function( String query)?  loading,TResult Function( String query,  List<Movie> results,  int page,  bool hasReachedMax,  bool isLoadingMore)?  loaded,TResult Function( String query)?  empty,TResult Function( String query,  Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle(_that.recentSearches);case SearchLoading() when loading != null:
return loading(_that.query);case SearchLoaded() when loaded != null:
return loaded(_that.query,_that.results,_that.page,_that.hasReachedMax,_that.isLoadingMore);case SearchEmpty() when empty != null:
return empty(_that.query);case SearchError() when error != null:
return error(_that.query,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<String> recentSearches)  idle,required TResult Function( String query)  loading,required TResult Function( String query,  List<Movie> results,  int page,  bool hasReachedMax,  bool isLoadingMore)  loaded,required TResult Function( String query)  empty,required TResult Function( String query,  Failure failure)  error,}) {final _that = this;
switch (_that) {
case SearchIdle():
return idle(_that.recentSearches);case SearchLoading():
return loading(_that.query);case SearchLoaded():
return loaded(_that.query,_that.results,_that.page,_that.hasReachedMax,_that.isLoadingMore);case SearchEmpty():
return empty(_that.query);case SearchError():
return error(_that.query,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<String> recentSearches)?  idle,TResult? Function( String query)?  loading,TResult? Function( String query,  List<Movie> results,  int page,  bool hasReachedMax,  bool isLoadingMore)?  loaded,TResult? Function( String query)?  empty,TResult? Function( String query,  Failure failure)?  error,}) {final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle(_that.recentSearches);case SearchLoading() when loading != null:
return loading(_that.query);case SearchLoaded() when loaded != null:
return loaded(_that.query,_that.results,_that.page,_that.hasReachedMax,_that.isLoadingMore);case SearchEmpty() when empty != null:
return empty(_that.query);case SearchError() when error != null:
return error(_that.query,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SearchIdle implements SearchState {
  const SearchIdle({ List<String> recentSearches = const <String>[]}): _recentSearches = recentSearches;
  

 final  List<String> _recentSearches;
@JsonKey() List<String> get recentSearches {
  if (_recentSearches is EqualUnmodifiableListView) return _recentSearches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSearches);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchIdleCopyWith<SearchIdle> get copyWith => _$SearchIdleCopyWithImpl<SearchIdle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchIdle&&const DeepCollectionEquality().equals(other.recentSearches, _recentSearches));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_recentSearches));
}

@override
String toString() {
    return 'SearchState.idle(recentSearches: $recentSearches)';
}


}

/// @nodoc
abstract mixin class $SearchIdleCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchIdleCopyWith(SearchIdle value, $Res Function(SearchIdle) _then) = _$SearchIdleCopyWithImpl;
@useResult
$Res call({
 List<String> recentSearches
});




}
/// @nodoc
class _$SearchIdleCopyWithImpl<$Res>
    implements $SearchIdleCopyWith<$Res> {
  _$SearchIdleCopyWithImpl(this._self, this._then);

  final SearchIdle _self;
  final $Res Function(SearchIdle) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? recentSearches = null,}) {
  return _then(SearchIdle(
recentSearches: null == recentSearches ? _self._recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class SearchLoading implements SearchState {
  const SearchLoading({required this.query});
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadingCopyWith<SearchLoading> get copyWith => _$SearchLoadingCopyWithImpl<SearchLoading>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchState.loading(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchLoadingCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadingCopyWith(SearchLoading value, $Res Function(SearchLoading) _then) = _$SearchLoadingCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchLoadingCopyWithImpl<$Res>
    implements $SearchLoadingCopyWith<$Res> {
  _$SearchLoadingCopyWithImpl(this._self, this._then);

  final SearchLoading _self;
  final $Res Function(SearchLoading) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchLoading(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchLoaded implements SearchState {
  const SearchLoaded({required this.query, required  List<Movie> results, required this.page, required this.hasReachedMax, this.isLoadingMore = false}): _results = results;
  

 final  String query;
 final  List<Movie> _results;
 List<Movie> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  int page;
 final  bool hasReachedMax;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadedCopyWith<SearchLoaded> get copyWith => _$SearchLoadedCopyWithImpl<SearchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoaded&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.page, page) || other.page == page)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_results),page,hasReachedMax,isLoadingMore);
}

@override
String toString() {
    return 'SearchState.loaded(query: $query, results: $results, page: $page, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $SearchLoadedCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadedCopyWith(SearchLoaded value, $Res Function(SearchLoaded) _then) = _$SearchLoadedCopyWithImpl;
@useResult
$Res call({
 String query, List<Movie> results, int page, bool hasReachedMax, bool isLoadingMore
});




}
/// @nodoc
class _$SearchLoadedCopyWithImpl<$Res>
    implements $SearchLoadedCopyWith<$Res> {
  _$SearchLoadedCopyWithImpl(this._self, this._then);

  final SearchLoaded _self;
  final $Res Function(SearchLoaded) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? results = null,Object? page = null,Object? hasReachedMax = null,Object? isLoadingMore = null,}) {
  return _then(SearchLoaded(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Movie>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SearchEmpty implements SearchState {
  const SearchEmpty({required this.query});
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchEmptyCopyWith<SearchEmpty> get copyWith => _$SearchEmptyCopyWithImpl<SearchEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEmpty&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'SearchState.empty(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchEmptyCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchEmptyCopyWith(SearchEmpty value, $Res Function(SearchEmpty) _then) = _$SearchEmptyCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchEmptyCopyWithImpl<$Res>
    implements $SearchEmptyCopyWith<$Res> {
  _$SearchEmptyCopyWithImpl(this._self, this._then);

  final SearchEmpty _self;
  final $Res Function(SearchEmpty) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchEmpty(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchError implements SearchState {
  const SearchError({required this.query, required this.failure});
  

 final  String query;
 final  Failure failure;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchErrorCopyWith<SearchError> get copyWith => _$SearchErrorCopyWithImpl<SearchError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchError&&(identical(other.query, query) || other.query == query)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,failure);
}

@override
String toString() {
    return 'SearchState.error(query: $query, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SearchErrorCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchErrorCopyWith(SearchError value, $Res Function(SearchError) _then) = _$SearchErrorCopyWithImpl;
@useResult
$Res call({
 String query, Failure failure
});




}
/// @nodoc
class _$SearchErrorCopyWithImpl<$Res>
    implements $SearchErrorCopyWith<$Res> {
  _$SearchErrorCopyWithImpl(this._self, this._then);

  final SearchError _self;
  final $Res Function(SearchError) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? failure = null,}) {
  return _then(SearchError(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
