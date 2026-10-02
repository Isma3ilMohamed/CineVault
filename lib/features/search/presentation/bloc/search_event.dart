part of 'search_bloc.dart';

/// ببساطة كدا: كل Event من UI → action
/// Sealed + Equatable = exhaustive pattern matching + rebuild tuning
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// بيتبعت كل لما المستخدم يكتب حرف — الـ bloc بيدبونس للـ query الفعلي
final class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Internal event — بيتفجر بعد الـ debounce window بينفذ الـ API call
final class _SearchExecuted extends SearchEvent {
  final String query;

  const _SearchExecuted(this.query);

  @override
  List<Object> get props => [query];
}

/// المستخدم دوس على query قديم من الـ recents
final class RecentSearchTapped extends SearchEvent {
  final String query;

  const RecentSearchTapped(this.query);

  @override
  List<Object> get props => [query];
}

/// المستخدم مسح الـ query (X button)
final class SearchCleared extends SearchEvent {
  const SearchCleared();
}

/// Load المزيد من النتائج لنفس الـ query (pagination)
final class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}

/// Retry بعد error
final class SearchRetried extends SearchEvent {
  const SearchRetried();
}

/// نمسح كل الـ recent searches (X button فوق recents list)
final class RecentSearchesCleared extends SearchEvent {
  const RecentSearchesCleared();
}

/// Load الـ recents لأول مرة لما الصفحة تفتح
final class SearchStarted extends SearchEvent {
  const SearchStarted();
}
