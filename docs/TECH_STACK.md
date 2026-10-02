# 🧰 CineVault — Tech Stack Reference

دليل شامل لكل الأدوات والمكتبات اللي بنستخدمها في المشروع، ليه اخترناها، وإزاي بيـتوصلوا مع بعض.

> **Audience:** أي developer بيقرا المشروع لأول مرة — سواء انت رجعتله بعد فترة أو حد تاني بيراجع الكود.

---

## 📋 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Layer Breakdown](#layer-breakdown)
3. [Library Catalog](#library-catalog)
4. [Current Features](#current-features)
5. [Data Flow Example](#data-flow-example)
6. [Patterns Demonstrated](#patterns-demonstrated)
7. [File Map](#file-map)
8. [How to Extend](#how-to-extend)

---

## 🏛️ Architecture Overview

المشروع بيتبع **Clean Architecture** بـ 3 layers: Domain / Data / Presentation.

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│   Flutter Widgets ─ Bloc/Cubit ─ go_router ─ UI extras     │
└──────────────────────────┬──────────────────────────────────┘
                           │ uses
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│      Pure Dart: Entities ─ Repositories (abstract) ─        │
│                          UseCases                            │
└──────────────────────────▲──────────────────────────────────┘
                           │ implements
┌──────────────────────────┴──────────────────────────────────┐
│                       Data Layer                             │
│   Dio (network) ─ Hive (DB) ─ shared_preferences ─          │
│              Models (DTOs) ─ Repository Impls                │
└─────────────────────────────────────────────────────────────┘
```

**Dependency Rule:** Presentation و Data كلهم بيعتمدوا على Domain. Domain ماعندوش أي import من Flutter أو Dio أو Hive.

---

## 📐 Layer Breakdown

### 1️⃣ Domain Layer — القلب

**محتوياته:**
- **Entities** — business models (`Movie`)
- **Repositories (abstract)** — contracts بين الـ layers
- **UseCases** — كل action واحدة في التطبيق

**قواعد ذهبية:**
- مفيش `import 'package:flutter/...'`
- مفيش `import 'package:dio/...'`
- مفيش `fromJson` / `toJson`
- كل class `extends Equatable`
- `Either<Failure, T>` في return types

**مثال:**
```dart
// domain/entities/movie.dart — pure Dart
class Movie extends Equatable { ... }

// domain/repositories/movie_repository.dart — abstract
abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({required int page});
}

// domain/usecases/get_popular_movies.dart — single responsibility
class GetPopularMovies implements UseCase<List<Movie>, PageParams> { ... }
```

### 2️⃣ Data Layer — من فين الداتا

**محتوياته:**
- **Models (DTOs)** — JSON mapping + `toEntity()`
- **Data sources** — Remote (Dio) + Local (Hive / SharedPreferences)
- **Repository implementations** — تحويل Exceptions لـ Failures

**قواعد ذهبية:**
- Model عندها `fromJson` / `toJson` / `toEntity`
- Data source بترمي `ServerException` / `NetworkException` / `CacheException`
- Repository بتمسكها وترجع `Left(Failure)`
- Network-aware: بنعمل check على `NetworkInfo.isConnected` قبل API

### 3️⃣ Presentation Layer — الـ UI

**محتوياته:**
- **Bloc / Cubit** — state holders
- **Pages** — screens (`StatelessWidget` أو `StatefulWidget`)
- **Widgets** — reusable pieces

**قواعد ذهبية:**
- Bloc بياخد UseCases، مش Repository مباشرة
- Events + States في ملفات منفصلة (`part of`)
- States `sealed` عشان exhaustive `switch`
- الـ UI بتستخدم `BlocBuilder` / `BlocSelector` / `BlocListener`

---

## 📚 Library Catalog

### State Management

#### `flutter_bloc` + `bloc` + `equatable`
**الدور:** state management عبر Bloc pattern.

**ليه اخترناها؟**
- Industry standard في Flutter projects الكبيرة
- Separation of concerns (events → state → UI)
- Testable: الـ bloc logic مستقل عن الـ UI
- `sealed class` states بتدي exhaustive pattern matching
- `Equatable` بتقلل rebuilds لأن الـ bloc مش هيـ emit state جديد لو `props` زي القديم

**استخدامها في المشروع:**
- `MoviesBloc` — home page (4 sections في parallel)
- `MovieDetailsBloc` — details page
- `SearchBloc` — search with debouncing
- `FavoritesBloc` — favorites page (subscribed to stream)
- `FavoriteIdsCubit` — global favorites state

**Example:**
```dart
// lib/features/movies/presentation/bloc/movies_bloc.dart
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;
  MoviesBloc({...}) : super(const MoviesInitial()) {
    on<LoadHomeMovies>(_onLoadHomeMovies);
  }
}
```

#### `Cubit` (subset of bloc)
`Cubit` هو lightweight bloc بدون events — بتعمل `emit(newState)` مباشرة. استخدمناه في `FavoriteIdsCubit` لأن الـ input الوحيد هو `toggle(movie)`.

---

### Networking

#### `dio`
**الدور:** HTTP client.

**ليه اخترناها بدل `http`؟**
- Interceptors (auth, logging, errors) — تلاقيها في `core/network/interceptors/`
- BaseOptions، timeouts، query params بسهولة
- Multipart uploads (لو احتجنا)
- Transformers + response handling مرن

**استخدامها:**
```dart
// lib/core/network/dio_client.dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.themoviedb.org/3',
  queryParameters: {'api_key': apiKey},
  connectTimeout: AppConstants.connectionTimeout,
));
dio.interceptors.addAll([
  AuthInterceptor(),
  ErrorInterceptor(),
  PrettyDioLogger(...),
]);
```

#### `pretty_dio_logger`
Dev-time logger — بيطبع requests/responses في الـ console بشكل مقروء. في production بنخليه behind `kDebugMode`.

---

### Functional Error Handling

#### `dartz` — `Either<L, R>`
**الدور:** return type للـ operations اللي ممكن تفشل.

**ليه `Either<Failure, T>` بدل throw/try?**
- Exceptions في Dart unchecked — الـ compiler مش هيذكرك تمسكها
- `Either<Failure, T>` في return type بيخلّي الفشل جزء من الـ type signature
- Code reader بيعرف فوراً إن الـ method ممكن تفشل
- `fold(onLeft, onRight)` بيضمن إنك تتعامل مع الحالتين

**استخدامها:**
```dart
// Everywhere in repositories
Future<Either<Failure, List<Movie>>> getPopularMovies({required int page}) async {
  if (!await networkInfo.isConnected) return const Left(NetworkFailure());
  try {
    final response = await remoteDataSource.getPopularMovies(page: page);
    return Right(response.results.map((m) => m.toEntity()).toList());
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  }
}

// In bloc
result.fold(
  (failure) => emit(MoviesError(message: failure.message)),
  (movies) => emit(MoviesLoaded(movies: movies)),
);
```

**مقارنة مع Kee:** زي `Result<T>` أو `Either<L, R>` في Arrow-kt. نفس الفكرة.

---

### Dependency Injection

#### `get_it` — Service Locator
**الدور:** DI container — instance واحدة من كل service متاحة لأي class.

**ليه get_it بدل provider/riverpod/kiwi?**
- Simple: `sl.registerLazySingleton(...)` و `sl<T>()` لما تحتاجها
- خفيف جداً (< 5KB)
- بيدعم async init (Hive, SharedPreferences)
- Framework-agnostic — ممكن نستخدمه في Dart pure project

**3 types of registration:**
| Type | Lifecycle | Usage |
|---|---|---|
| `registerSingleton` | واحدة ثابتة من اللحظة الأولى | External deps (e.g. `Connectivity`) |
| `registerLazySingleton` | واحدة لما نطلبها أول مرة | Repositories, DataSources, UseCases |
| `registerFactory` | instance جديدة كل مرة | Blocs (per page) |

**استخدامها:**
```dart
// lib/core/di/injection_container.dart
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton(() => Connectivity());
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Features - Movies (Data → Domain → Presentation)
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerFactory(() => MoviesBloc(getPopularMovies: sl(), ...));
}
```

**مقارنة مع Kee:** شبيه بـ Koin — `module { single { ... } factory { ... } }`.

---

### Routing

#### `go_router`
**الدور:** declarative routing، deep linking، shell navigation.

**ليه go_router بدل Navigator 2.0 مباشرة؟**
- Navigator 2.0 API معقدة جداً
- `go_router` بيخفيها ورا declarative config
- Deep linking بيشتغل out-of-the-box
- `StatefulShellRoute.indexedStack` أحسن طريقة لـ bottom nav

**Structure في المشروع:**
```
StatefulShellRoute (bottom nav)
├── /home           (tab 0)
└── /favorites      (tab 1)

Pushed above shell (full-screen, hides bottom nav):
├── /search
└── /movie/:id
```

**Key tricks:**
1. **BlocProvider per route** — الـ bloc بيتعمل لما الصفحة تفتح وبيتدمر لما تـ pop
   ```dart
   GoRoute(
     path: '/movie/:id',
     builder: (context, state) => BlocProvider(
       create: (_) => sl<MovieDetailsBloc>()..add(LoadMovieDetails(id)),
       child: MovieDetailsPage(movieId: id),
     ),
   )
   ```

2. **Fire event in `create`, NOT `build`** — لو عملناها في build هتعاد مع كل rebuild.

3. **`parentNavigatorKey: _rootNavigatorKey`** — بيخلّي الـ route يتفتح فوق الـ shell (bottom nav يختفي).

4. **`state.extra` للـ context** — بنبعت `heroTag` في الـ extra للـ animation matching:
   ```dart
   context.push('/movie/${movie.id}', extra: {'heroTag': 'popular_${movie.id}'});
   ```

**استخدامها:** `lib/core/router/app_router.dart`

---

### Local Storage

#### `shared_preferences`
**الدور:** key-value storage بسيط للـ primitives (String, int, bool, List&lt;String&gt;).

**استخدامها:** recent searches
```dart
// lib/features/search/data/datasources/local/recent_searches_local_data_source.dart
await prefs.setStringList('recent_searches', ['الهوبيت', 'interstellar', ...]);
```

**متى نستخدمها؟**
- data صغير + primitives
- settings / preferences
- auth tokens (حالياً، بس `flutter_secure_storage` أنضف)

#### `hive` + `hive_flutter`
**الدور:** NoSQL object DB، pure Dart، reactive streams.

**ليه Hive بدل Isar؟**
- Isar v3 بيلزم analyzer < 6.0.0 اللي بيعمل conflict مع bloc_test
- Hive بيدينا نفس الـ reactivity (`box.watch()`) من غير codegen
- Pure Dart — مفيش native libs مضافة
- أخف وأبسط للـ learning project

**ليه Hive بدل sqflite؟**
- sqflite SQL — لكن مفيش reactive streams built-in
- Hive بيدي `box.watch()` stream بيطلق event على كل write → UI يـ rebuild تلقائي
- مفيش schema migrations معقدة — key-value بسيط

**استخدامها:** favorites
```dart
// lib/features/favorites/data/datasources/local/favorites_local_data_source.dart
final box = await Hive.openBox<dynamic>('favorites');
await box.put(movie.id, favoriteMap);    // write
final ids = box.keys.whereType<int>().toSet();  // read
final stream = box.watch();               // reactive!
```

**Storage structure:**
```
Box<dynamic>('favorites')
  key: int (movieId)
  value: Map<String, dynamic> (Movie JSON + _added_at timestamp)
```

#### `path_provider`
**الدور:** بيدي الـ paths الصحيحة للـ OS (documents, cache, temp).

**استخدامها:** مطلوب جوا `Hive.initFlutter()` عشان يختار الـ storage location.

---

### UI Libraries

#### `cached_network_image`
Network images + disk cache + placeholder/error builders.
```dart
CachedNetworkImage(
  imageUrl: movie.fullPosterUrl!,
  placeholder: (_, __) => Shimmer.fromColors(...),
  errorWidget: (_, __, ___) => Icon(Icons.movie_outlined),
)
```

#### `shimmer`
Shimmer loading effect — بنستخدمه أثناء الـ image loading.

#### `carousel_slider`
Auto-playing carousel — featured movies في home page.

---

### Configuration

#### `flutter_dotenv`
`.env` file → environment variables.

**استخدامها:**
```
.env (git-ignored):
TMDB_API_KEY=abc123

main.dart:
await dotenv.load(fileName: '.env');

dio_client.dart (via AuthInterceptor):
options.queryParameters['api_key'] = dotenv.env['TMDB_API_KEY']!;
```

---

### Connectivity

#### `connectivity_plus`
**الدور:** check لو الموبايل connected للـ internet.

**استخدامها:** كل repository بيستدعي `networkInfo.isConnected` قبل أي API call.
```dart
if (!await networkInfo.isConnected) return const Left(NetworkFailure());
```

---

### Testing

#### `bloc_test` + `mocktail` + `flutter_test`
**الدور:** testing للـ blocs.

**استخدامها:** `test/features/movies/presentation/bloc/movies_bloc_test.dart`
```dart
blocTest<MoviesBloc, MoviesState>(
  'emits [loading, loaded] on LoadHomeMovies success',
  build: () {
    when(() => mockGetPopularMovies(any())).thenAnswer((_) async => Right([movie]));
    return moviesBloc;
  },
  act: (bloc) => bloc.add(const LoadHomeMovies()),
  expect: () => [isA<MoviesLoading>(), isA<MoviesLoaded>()],
);
```

---

### Utils

#### `equatable`
Value equality — `extends Equatable` + `get props` → `==` و `hashCode` تلقائي.

#### `intl`
Internationalization + date/number formatting (حالياً مش مستخدمة بالكامل).

---

## 🎬 Current Features

| Feature | Status | Key files |
|---|---|---|
| **Home** | ✅ | `features/movies/presentation/pages/home_page.dart` |
| **Movie Details** | ✅ | `features/movies/presentation/pages/movie_details_page.dart` |
| **Search** | ✅ | `features/search/presentation/pages/search_page.dart` |
| **Favorites** | ✅ | `features/favorites/presentation/pages/favorites_page.dart` |
| **Bottom Nav** | ✅ | `core/widgets/app_shell.dart` |
| **Auth** | 🔜 Phase 6 | — |

---

## 🔄 Data Flow Example

**Scenario:** User opens app → HomePage → taps "Interstellar" → MovieDetailsPage → taps heart.

```
1. App starts
   main.dart → initDependencies() → Hive.initFlutter() → openBox('favorites')
   → registers all use cases, repos, blocs in get_it
   → runApp() with BlocProvider<FavoriteIdsCubit> at root

2. Router shows /home
   → BlocProvider creates MoviesBloc
   → HomePage auto-triggers LoadHomeMovies event
   → Bloc calls GetPopularMovies + 3 other repo methods in parallel
   → Repo: networkInfo.isConnected? → remoteDataSource.getPopular() → model.toEntity()
   → Bloc emits MoviesLoaded
   → HomePage rebuilds → FeaturedCarousel + 4 MoviesSection rows

3. User taps "Interstellar" card
   → onMovieTap callback fires with heroTag='popular_157336'
   → context.push('/movie/157336', extra: {'heroTag': 'popular_157336'})
   → Router builds MovieDetailsPage, creates MovieDetailsBloc,
     fires LoadMovieDetails(157336) in create:
   → Hero animation flies poster from card to details appbar
   → Bloc fetches details + similar movies in parallel
   → MovieDetailsLoaded state → page renders

4. User taps heart icon
   → FavoriteHeartButton reads context.read<FavoriteIdsCubit>()
   → cubit.toggle(movie) → optimistic emit (UI flips red instantly)
   → cubit calls ToggleFavorite usecase → repo.toggleFavorite(movie)
   → Hive writes Map to box[movieId]
   → box.watch() fires → FavoritesRepository stream emits new Set<int>
   → Cubit receives stream event → emit(newSet)
   → Every context.select listening to this cubit rebuilds (just the hearts)
   → Heart stays red. Favorites tab shows the movie if user navigates there.
```

---

## 🎯 Patterns Demonstrated

### 1. Clean Architecture
Domain / Data / Presentation separation. مفيش import من Flutter في الـ domain.

### 2. Repository Pattern
Domain بيعرّف `abstract class XRepository`. Data بينفّذ. Presentation بيستخدم UseCases اللي بتستخدم الـ contract.

### 3. Either Monad for Error Handling
كل repo method بترجع `Future<Either<Failure, T>>`. مفيش `throw` في API الـ domain.

### 4. UseCase Per Action
`GetPopularMovies`, `GetMovieDetails`, `SearchMovies`, `ToggleFavorite`... كل واحدة بتعمل حاجة واحدة بس.

### 5. Sealed States + Exhaustive Switch
```dart
return switch (state) {
  SearchIdle() => RecentSearchesList(...),
  SearchLoading() => CircularProgressIndicator(),
  SearchLoaded() => SearchResultsGrid(...),
  SearchEmpty() => _EmptyResults(...),
  SearchError() => _ErrorView(...),
};
```
الـ compiler بيجبرك تتعامل مع كل حالة.

### 6. Reactive Streams → Cubit → `context.select`
`Hive.watch()` → Stream → Cubit → `context.select((c) => c.state.contains(id))`.
النتيجة: card الـ heart بيـ rebuild بس لما حالته تتغير.

### 7. Debouncing بـ Timer + Internal Event
```dart
void _onQueryChanged(event, emit) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 400), () {
    add(_SearchExecuted(event.query));  // internal event
  });
}
```
ما احتجناش rxdart — Dart's native Timer + bloc event system كفاية.

### 8. Optimistic Updates
```dart
Future<void> toggle(Movie movie) async {
  final next = state.contains(movie.id) ? ... : ...;
  emit(next);  // UI first
  await toggleFavoriteUseCase(...);  // storage second
  // إذا فشل، الـ stream هيرجعها لحالتها الصحيحة
}
```

### 9. Hero Tag Collisions Handled
لو الفيلم موجود في أكتر من section، كل MovieCard بياخد prefix فريد:
`popular_157336`, `top_rated_157336`, `search_157336`...
والـ heroTag بيتبعت للـ details page عبر `extra`.

### 10. Stateful Shell Navigation
`StatefulShellRoute.indexedStack` → كل tab عنده navigator مستقل → scroll وstate بيتحفظوا.

---

## 📁 File Map

```
lib/
├── main.dart                              # Entry point — init DI, runApp
├── app.dart                               # MaterialApp.router + root BlocProvider
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart            # Pagination, timeouts, TMDB endpoints
│   ├── di/
│   │   └── injection_container.dart      # get_it registrations (sl)
│   ├── error/
│   │   ├── failures.dart                 # Domain errors (Equatable)
│   │   └── exceptions.dart               # Data layer errors
│   ├── network/
│   │   ├── dio_client.dart              # Dio singleton + interceptors
│   │   ├── network_info.dart            # NetworkInfo via connectivity_plus
│   │   └── interceptors/                # Auth + Error interceptors
│   ├── router/
│   │   └── app_router.dart              # go_router + StatefulShellRoute
│   ├── theme/
│   │   └── app_theme.dart               # Material 3 dark theme
│   ├── usecase/
│   │   └── usecase.dart                 # UseCase<Type, Params> base class
│   └── widgets/
│       └── app_shell.dart               # Bottom nav scaffold
│
├── features/
│   ├── movies/                          # Home + Details
│   │   ├── data/
│   │   │   ├── datasources/remote/movie_remote_data_source.dart
│   │   │   ├── models/movie_model.dart
│   │   │   └── repositories/movie_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/movie.dart
│   │   │   ├── repositories/movie_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_popular_movies.dart
│   │   │       ├── get_movie_details.dart
│   │   │       └── get_similar_movies.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── movies_bloc.dart         # home
│   │       │   └── movie_details_bloc.dart  # details
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── movie_details_page.dart
│   │       └── widgets/
│   │           ├── movie_card.dart          # heart overlay + rating
│   │           ├── movies_section.dart      # horizontal row
│   │           └── featured_carousel.dart
│   │
│   ├── search/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── remote/search_remote_data_source.dart
│   │   │   │   └── local/recent_searches_local_data_source.dart
│   │   │   └── repositories/search_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/search_repository.dart
│   │   │   └── usecases/
│   │   │       ├── search_movies.dart
│   │   │       ├── get_recent_searches.dart
│   │   │       ├── save_recent_search.dart
│   │   │       └── clear_recent_searches.dart
│   │   └── presentation/
│   │       ├── bloc/search_bloc.dart
│   │       ├── pages/search_page.dart
│   │       └── widgets/
│   │           ├── recent_searches_list.dart
│   │           └── search_results_grid.dart
│   │
│   └── favorites/
│       ├── data/
│       │   ├── datasources/local/favorites_local_data_source.dart
│       │   ├── models/favorite_movie_model.dart
│       │   └── repositories/favorites_repository_impl.dart
│       ├── domain/
│       │   ├── repositories/favorites_repository.dart
│       │   └── usecases/
│       │       ├── watch_favorites.dart
│       │       ├── watch_favorite_ids.dart
│       │       ├── toggle_favorite.dart
│       │       └── is_favorite.dart
│       └── presentation/
│           ├── bloc/favorites_bloc.dart
│           ├── cubit/favorite_ids_cubit.dart   # global singleton
│           ├── pages/favorites_page.dart
│           └── widgets/favorite_heart_button.dart
│
└── assets/
    └── images/, icons/
```

---

## 🚀 How to Extend

### إضافة feature جديدة (مثال: Watchlist)

1. **Domain first** (أنضف layer):
   ```
   features/watchlist/domain/
   ├── repositories/watchlist_repository.dart
   └── usecases/
       ├── add_to_watchlist.dart
       ├── remove_from_watchlist.dart
       └── watch_watchlist.dart
   ```

2. **Data layer:**
   ```
   features/watchlist/data/
   ├── datasources/local/watchlist_local_data_source.dart
   └── repositories/watchlist_repository_impl.dart
   ```
   - فتح `Hive.openBox('watchlist')` في DI
   - تسجيل الـ DataSource + Repository

3. **Presentation:**
   ```
   features/watchlist/presentation/
   ├── bloc/watchlist_bloc.dart
   └── pages/watchlist_page.dart
   ```

4. **Wiring:**
   - `injection_container.dart`: سجّل use cases + bloc
   - `app_router.dart`: ضيف `StatefulShellBranch` تالتة (أو route منفصل)
   - `app_shell.dart`: ضيف `NavigationDestination` تالتة

### إضافة tab جديدة للـ bottom nav

```dart
// app_router.dart
StatefulShellBranch(
  navigatorKey: _watchlistNavigatorKey,
  routes: [GoRoute(path: '/watchlist', ...)],
),

// app_shell.dart
NavigationDestination(
  icon: Icon(Icons.bookmark_border_rounded),
  selectedIcon: Icon(Icons.bookmark_rounded),
  label: 'Watchlist',
),
```

### إضافة endpoint جديد للـ API

1. ضيف الـ path في `core/constants/app_constants.dart`:
   ```dart
   static const String trendingMovies = '/trending/movie/day';
   ```
2. ضيف method في `MovieRemoteDataSource`
3. ضيف method في `MovieRepository` (domain contract)
4. نفذها في `MovieRepositoryImpl`
5. (اختياري) اعمل UseCase لو الـ bloc محتاج

---

## 🔗 Quick Links

- **Architecture concepts:** `docs/ARCHITECTURE.md`
- **Learning path:** `docs/LEARNING_ROADMAP.md`
- **Setup instructions:** `docs/SETUP_GUIDE.md`
- **Original phase instructions:** `docs/INSTRUCTIONS.md`

---

**آخر تحديث:** بعد Phase 5 (Favorites). الـ stack stable حالياً.
