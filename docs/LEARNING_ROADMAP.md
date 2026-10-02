# 🗺️ Flutter Learning Roadmap — CineVault

دي الخطة اللي هنمشي عليها سوا. كل phase فيها learning goal + deliverable.

---

## ✅ Phase 1: Project Setup & Foundation (done)

**الـ goal:** تبني base structure احترافي قابل للتوسع.

**اللي اتعمل:**
- [x] Clean Architecture folder structure
- [x] `pubspec.yaml` بكل الـ dependencies
- [x] Error handling (Failures + Exceptions)
- [x] Dio setup + interceptors
- [x] Dependency Injection (GetIt)
- [x] Theme (Material 3 dark)
- [x] go_router setup

**Key concepts:**
- Dart null safety
- Either monad
- Dependency injection
- Folder organization

---

## ✅ Phase 2: Movies Feature (done)

**الـ goal:** تبني feature كاملة من A to Z.

**اللي اتعمل:**
- [x] Movie entity + repository interface
- [x] DTO (MovieModel) with JSON mapping
- [x] Remote data source (Dio calls)
- [x] Repository implementation
- [x] GetPopularMovies use case
- [x] MoviesBloc + Events + States
- [x] HomePage + MovieCard + MoviesSection + FeaturedCarousel

**Key concepts:**
- Bloc pattern (events → states)
- `sealed class` في Dart (pattern matching)
- `Equatable` للـ state comparison
- `BlocBuilder` vs `BlocListener` vs `BlocConsumer`
- `CustomScrollView` + Slivers
- `CachedNetworkImage`
- Hero animations

---

## ✅ Phase 3: Movie Details Screen (done)

**الـ goal:** navigation، deep animations، شاشة تفاصيل الفيلم.

**اللي اتعمل:**
- [x] `GetMovieDetails` + `GetSimilarMovies` use cases
- [x] `MovieDetailsBloc` (parallel fetch: details critical, similar best-effort)
- [x] `MovieDetailsPage` مع:
  - Hero animation من الـ MovieCard → backdrop
  - Parallax `SliverAppBar` (expandedHeight 400)
  - Rating + release year meta row
  - Overview
  - Similar movies horizontal row
- [x] `/movie/:id` route + `extra: {'heroTag': ...}` للـ hero matching
- [x] Private sub-widgets (`_LoadingView`, `_ErrorView`, `_LoadedView`, `_DetailsAppBar`)
- [x] Hero tag collision fix (section prefix per card — `popular_$id`, `top_rated_$id`...)

**Key concepts (اتعلمنا):**
- `Hero` widgets + tag uniqueness rules
- `SliverAppBar` + `FlexibleSpaceBar` للـ parallax
- `CustomScrollView` + Slivers للـ scroll مرن
- `go_router` path params (`:id`) + `state.extra` للـ context
- Fire-and-forget event in `BlocProvider.create` (`..add(LoadMovieDetails(id))`) بدل لـ build
- Sealed states + exhaustive `switch` expression
- `Either.fold` بدل manual type casting
- Private `Stateless` sub-widgets لـ scoped rebuilds

---

## ✅ Phase 4: Search Feature (done)

**الـ goal:** feature كاملة تانية + debouncing + local caching.

**اللي اتعمل:**
- [x] Search feature بنفس الـ Clean Architecture pattern
- [x] `SearchMovies` + `GetRecentSearches` + `SaveRecentSearch` + `ClearRecentSearches` use cases
- [x] `SearchBloc` بـ Timer-based debounce (400ms) + internal `_SearchExecuted` event
- [x] Recent searches محفوظة في `shared_preferences` (max 10, dedupe case-insensitive)
- [x] States exhaustive: `SearchIdle` / `SearchLoading` / `SearchLoaded` / `SearchEmpty` / `SearchError`
- [x] Pagination بـ `ScrollController` عند 80% scroll
- [x] `_SearchField` widget بـ `ValueListenableBuilder` للـ clear button

**Key concepts (اتعلمنا):**
- Debouncing عبر `Timer` + internal event dispatch (بدل rxdart)
- Cross-feature DTO reuse (`SearchRemoteDataSource` بيستخدم `MoviesPageResponse` من movies)
- `TextEditingController` + `FocusNode` + `autofocus` لـ UX المفاتيح
- `ValueListenableBuilder` للـ rebuilds محدودة على الـ controller text
- `copyWith` في الـ state لـ pagination updates
- Pattern matching على الـ current state لـ retry logic

---

## ✅ Phase 5: Favorites Feature (done)

**الـ goal:** Local database + reactive streams + offline-first.

> **ملاحظة:** الخطة الأصلية كانت Isar، لكن اتنقلنا لـ **Hive** بسبب dep conflict
> (isar_generator v3 بيلزم analyzer <6.0.0، بينما bloc_test محتاج أعلى).
> Hive بيدينا نفس الـ reactive UX من غير codegen.

**اللي اتعمل:**
- [x] Favorites feature بـ Hive (NoSQL, pure Dart, `box.watch()` streams)
- [x] `WatchFavorites` / `WatchFavoriteIds` / `ToggleFavorite` / `IsFavorite` use cases
- [x] `FavoritesBloc` للصفحة (subscribed لـ stream)
- [x] `FavoriteIdsCubit` global (one Set<int> للـ UI كله)
- [x] `FavoriteHeartButton` — overlay على MovieCard + action في MovieDetailsPage AppBar
- [x] `FavoritesPage` بـ 2-col grid + empty state مع CTA للـ search
- [x] Bottom nav عبر `StatefulShellRoute.indexedStack` (Home / Favorites)
- [x] Optimistic toggle — UI بيـ flip قبل الـ Hive write

**Key concepts (اتعلمنا):**
- Hive basics: `initFlutter`, `openBox`, `box.put/get/delete`, `box.watch()`
- NoSQL storage باستخدام JSON maps (بدل codegen TypeAdapters)
- Reactive streams: `async*` generator بيبعت snapshot على كل تغيير
- Global singleton Cubit مع `context.select` لـ O(1) lookups بدون N-streams
- Optimistic updates: UI first, storage second, stream is authoritative
- `StatefulShellRoute.indexedStack` للـ tabs مع preserved state
- `parentNavigatorKey: _rootNavigatorKey` علشان pages كاملة الشاشة تختفي تحتها bottom nav
- Cross-feature widget usage (MovieCard بيستورد FavoriteHeartButton)

---

## 🔜 Phase 6: Authentication with Firebase

**الـ goal:** Real-world auth flow + sync favorites across devices.

**اللي هنعمله:**
- [ ] Firebase project setup
- [ ] Auth feature (Email/Password + Google Sign-In)
- [ ] `LoginPage` + `RegisterPage`
- [ ] `AuthBloc`
- [ ] Protect routes (require auth for favorites)
- [ ] Sync favorites with Firestore
- [ ] User profile page

**Key concepts:**
- Firebase Auth
- Cloud Firestore
- Auth state changes
- go_router redirects
- Offline sync

---

## 🔜 Phase 7: Testing

**الـ goal:** test pyramid كامل.

**اللي هنعمله:**
- [ ] Unit tests للـ use cases (100% coverage)
- [ ] Repository tests with mocks
- [ ] Bloc tests بـ `bloc_test`
- [ ] Widget tests للـ screens
- [ ] Golden tests للـ UI regression
- [ ] Integration tests (end-to-end flows)

**Key concepts:**
- Test pyramid
- Mocking with `mocktail`
- `bloc_test` patterns
- Golden tests
- `integration_test` package

---

## 🔜 Phase 8: Polish & Production-Ready

**الـ goal:** التطبيق جاهز للـ store.

**اللي هنعمله:**
- [ ] Analytics (Firebase Analytics)
- [ ] Crash reporting (Firebase Crashlytics)
- [ ] App icon + splash screen
- [ ] Localization (Arabic + English)
- [ ] Accessibility (screen readers, font scaling)
- [ ] CI/CD (GitHub Actions)
- [ ] Release build + signing
- [ ] Performance profiling

**Key concepts:**
- `flutter_localizations` + `intl`
- Semantics widgets
- Fastlane
- Flutter DevTools profiling
- Build flavors (dev/staging/prod)

---

## 📊 Phase Comparison

| Phase | Difficulty | Time Estimate | What You'll Master |
|-------|-----------|---------------|---------------------|
| 1 | ⭐⭐ | 2-3 hours | Setup, DI, Architecture |
| 2 | ⭐⭐⭐ | 4-6 hours | Bloc, Widgets, API |
| 3 | ⭐⭐⭐ | 3-4 hours | Navigation, Animations |
| 4 | ⭐⭐⭐ | 3-4 hours | Debouncing, Streams |
| 5 | ⭐⭐⭐⭐ | 5-6 hours | Local DB, Offline |
| 6 | ⭐⭐⭐⭐ | 6-8 hours | Firebase, Auth |
| 7 | ⭐⭐⭐⭐ | 6-8 hours | Testing strategy |
| 8 | ⭐⭐⭐ | 4-6 hours | Production concerns |

**Total: ~40-50 hours** من التعلم المركز.

---

## 💡 نصايح للرحلة

1. **اعمل commits صغيرة ومتكررة** — أسهل في الـ review
2. **اكتب tests أثناء التطوير مش بعده** — TDD بيوفر وقت
3. **استخدم Claude Code** — المشروع ده perfect للـ agentic coding
4. **لما تعلق، افتح docs/** — كل الشرح موجود بالعربي
5. **قارن دايماً مع Kee/KMP** — هتلاقي patterns متشابهة

---

## 🎯 المهارات اللي هتكتسبها

بعد ما تخلص الـ 8 phases دي:

- ✅ Flutter architecture على مستوى senior
- ✅ Bloc pattern mastery
- ✅ Dart advanced features (sealed classes, records, extensions)
- ✅ Firebase integration
- ✅ Testing (unit, widget, integration)
- ✅ CI/CD for Flutter
- ✅ Performance optimization

**وأهم حاجة:** Transferable skills بين Android/KMP وFlutter.

---

**يلا نبدأ!** 🚀
