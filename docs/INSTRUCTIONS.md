# 🎬 CineVault — Development Instructions

دليل كامل للشغل على مشروع CineVault بعد ما الـ setup الأساسي خلص.

> **Status:** ✅ Setup complete, iOS & Android running successfully
> **Next:** Phase 3 — Movie Details screen

---

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Project Structure Reference](#project-structure-reference)
3. [الـ Files اللي هنشتغل عليها](#الـ-files-اللي-هنشتغل-عليها)
4. [Phase 3 — Movie Details](#phase-3--movie-details)
5. [Development Workflow](#development-workflow)
6. [Common Commands](#common-commands)
7. [Debugging Tips](#debugging-tips)
8. [Architecture Checklist](#architecture-checklist)

---

## 🚀 Quick Start

### يومياً لما تفتح المشروع

```bash
cd ~/Developer/Flutter/cine_vault

# 1. تأكد من الـ dependencies
flutter pub get

# 2. شغل على iOS أو Android
flutter run                    # هيشتغل على أول جهاز متاح
flutter run -d "iPhone"        # iOS Simulator
flutter run -d chrome          # Chrome (أسرع)
```

### Hot Reload Shortcuts

| Shortcut | الوظيفة |
|----------|---------|
| `r` في terminal | Hot Reload (يحافظ على state) |
| `R` في terminal | Hot Restart (يفقد state) |
| `q` | Quit |
| `p` | عرض Performance overlay |
| `o` | Toggle platform (Android/iOS) |

---

## 📁 Project Structure Reference

```
lib/
├── core/                          # المشترك
│   ├── constants/app_constants.dart
│   ├── di/injection_container.dart
│   ├── error/
│   │   ├── failures.dart          # Domain errors
│   │   └── exceptions.dart        # Data errors
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── network_info.dart
│   │   └── interceptors/
│   ├── router/app_router.dart
│   ├── theme/app_theme.dart
│   └── usecase/usecase.dart
│
├── features/
│   ├── movies/                    # ✅ DONE
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── search/                    # 🔜 Phase 4
│   ├── favorites/                 # 🔜 Phase 5
│   └── auth/                      # 🔜 Phase 6
│
├── app.dart
└── main.dart
```

---

## 🎯 الـ Files اللي هنشتغل عليها

### Feature template (لأي feature جديدة)

لما تعمل feature جديدة (زي Search أو Favorites)، اتبع النموذج ده:

```
features/<feature_name>/
├── data/
│   ├── datasources/remote/<feature>_remote_data_source.dart
│   ├── models/<feature>_model.dart
│   └── repositories/<feature>_repository_impl.dart
├── domain/
│   ├── entities/<feature>.dart
│   ├── repositories/<feature>_repository.dart
│   └── usecases/<action_name>.dart
└── presentation/
    ├── bloc/
    │   ├── <feature>_bloc.dart
    │   ├── <feature>_event.dart
    │   └── <feature>_state.dart
    ├── pages/<feature>_page.dart
    └── widgets/<feature>_widget.dart
```

### القواعد الذهبية

1. **Domain ما يعرفش حاجة عن Flutter أو Dio**
   - مفيش `import 'package:flutter/...'` في domain
   - مفيش `fromJson` في Entities
   - Domain pure Dart بس

2. **Data بتنفذ contracts الـ Domain**
   - `XRepositoryImpl implements XRepository`
   - بتحول Exceptions لـ Failures
   - فيها `fromJson` / `toJson`

3. **Presentation بتستخدم UseCases بس**
   - Bloc ما ياخدش Repository مباشرة
   - كل action = UseCase منفصل

---

## 🎬 Phase 3 — Movie Details

### الـ goal
شاشة تفاصيل الفيلم مع Hero animation وParallax scroll.

### 📝 Task List

- [ ] **Task 1:** ضيف method `getMovieDetails` في الـ repository (موجود بس مش مستخدم)
- [ ] **Task 2:** اعمل `GetMovieDetails` use case
- [ ] **Task 3:** اعمل `GetSimilarMovies` use case
- [ ] **Task 4:** اعمل `MovieDetailsBloc` + Events + States
- [ ] **Task 5:** اعمل `MovieDetailsPage` بـ SliverAppBar + Hero
- [ ] **Task 6:** ضيف navigation من HomePage للـ Details
- [ ] **Task 7:** Register في `injection_container.dart`
- [ ] **Task 8:** ضيف route في `app_router.dart`

### 🏗️ Implementation Order (مهم)

**اتبع الترتيب ده عشان تتجنب errors:**

#### Step 1: Domain Layer (الأسهل والنظيف)

**ملف:** `lib/features/movies/domain/usecases/get_movie_details.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails implements UseCase<Movie, MovieIdParams> {
  final MovieRepository repository;
  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, Movie>> call(MovieIdParams params) {
    return repository.getMovieDetails(movieId: params.movieId);
  }
}

class MovieIdParams extends Equatable {
  final int movieId;
  const MovieIdParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
```

**ملف:** `lib/features/movies/domain/usecases/get_similar_movies.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetSimilarMovies implements UseCase<List<Movie>, SimilarMoviesParams> {
  final MovieRepository repository;
  GetSimilarMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SimilarMoviesParams params) {
    return repository.getSimilarMovies(
      movieId: params.movieId,
      page: params.page,
    );
  }
}

class SimilarMoviesParams extends Equatable {
  final int movieId;
  final int page;

  const SimilarMoviesParams({required this.movieId, this.page = 1});

  @override
  List<Object> get props => [movieId, page];
}
```

#### Step 2: Bloc Layer

**ملف:** `lib/features/movies/presentation/bloc/movie_details_event.dart`

```dart
part of 'movie_details_bloc.dart';

sealed class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
  @override
  List<Object?> get props => [];
}

class LoadMovieDetails extends MovieDetailsEvent {
  final int movieId;
  const LoadMovieDetails(this.movieId);

  @override
  List<Object> get props => [movieId];
}
```

**ملف:** `lib/features/movies/presentation/bloc/movie_details_state.dart`

```dart
part of 'movie_details_bloc.dart';

sealed class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {
  const MovieDetailsInitial();
}

class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;
  final List<Movie> similarMovies;

  const MovieDetailsLoaded({
    required this.movie,
    required this.similarMovies,
  });

  @override
  List<Object> get props => [movie, similarMovies];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  const MovieDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
```

**ملف:** `lib/features/movies/presentation/bloc/movie_details_bloc.dart`

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_similar_movies.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;
  final GetSimilarMovies getSimilarMovies;

  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getSimilarMovies,
  }) : super(const MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(const MovieDetailsLoading());

    // اجب الاتنين في parallel
    final results = await Future.wait([
      getMovieDetails(MovieIdParams(movieId: event.movieId)),
      getSimilarMovies(SimilarMoviesParams(movieId: event.movieId)),
    ]);

    final detailsResult = results[0];
    final similarResult = results[1];

    if (detailsResult.isLeft()) {
      final failure = detailsResult.swap().getOrElse(() => throw Exception());
      emit(MovieDetailsError(message: failure.message));
      return;
    }

    emit(MovieDetailsLoaded(
      movie: detailsResult.getOrElse(() => throw Exception()) as Movie,
      similarMovies: similarResult.getOrElse(() => <Movie>[]) as List<Movie>,
    ));
  }
}
```

#### Step 3: UI Layer

**ملف:** `lib/features/movies/presentation/pages/movie_details_page.dart`

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie.dart';
import '../bloc/movie_details_bloc.dart';
import '../widgets/movie_card.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          return switch (state) {
            MovieDetailsInitial() => _triggerLoad(context),
            MovieDetailsLoading() => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            MovieDetailsError(:final message) => _buildError(context, message),
            MovieDetailsLoaded() => _buildContent(context, state),
          };
        },
      ),
    );
  }

  Widget _triggerLoad(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieDetailsBloc>().add(LoadMovieDetails(movieId));
    });
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFE50914)),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ارجع'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetailsLoaded state) {
    final movie = state.movie;

    return CustomScrollView(
      slivers: [
        // Parallax App Bar
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'movie_${movie.id}',
                  child: movie.fullBackdropUrl != null
                      ? CachedNetworkImage(
                          imageUrl: movie.fullBackdropUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[900]),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFB800), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${movie.formattedRating} (${movie.voteCount} votes)',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      movie.releaseYear,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                if (state.similarMovies.isNotEmpty) ...[
                  const Text(
                    'Similar Movies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.similarMovies.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => MovieCard(
                        movie: state.similarMovies[i],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
```

#### Step 4: DI Registration

**في:** `lib/core/di/injection_container.dart`

ضيف في آخر دالة `initDependencies()`:

```dart
// Use cases (ضيف دول)
sl.registerLazySingleton(() => GetMovieDetails(sl()));
sl.registerLazySingleton(() => GetSimilarMovies(sl()));

// Bloc (ضيف ده)
sl.registerFactory(
  () => MovieDetailsBloc(
    getMovieDetails: sl(),
    getSimilarMovies: sl(),
  ),
);
```

وما تنساش تضيف الـ imports في أول الملف:
```dart
import '../../features/movies/domain/usecases/get_movie_details.dart';
import '../../features/movies/domain/usecases/get_similar_movies.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc.dart';
```

#### Step 5: Router

**في:** `lib/core/router/app_router.dart`

ضيف route جديد:

```dart
GoRoute(
  path: '/movie/:id',
  name: 'movieDetails',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return BlocProvider(
      create: (_) => sl<MovieDetailsBloc>(),
      child: MovieDetailsPage(movieId: id),
    );
  },
),
```

وما تنساش الـ imports:
```dart
import '../../features/movies/presentation/bloc/movie_details_bloc.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
```

#### Step 6: Navigation من HomePage

**في:** `lib/features/movies/presentation/pages/home_page.dart`

في `_buildLoaded()`، غيّر:

```dart
// قديم:
FeaturedCarousel(
  movies: state.popularMovies,
  onMovieTap: (movie) {
    // TODO: Navigate to details
  },
),

// جديد:
FeaturedCarousel(
  movies: state.popularMovies,
  onMovieTap: (movie) {
    context.push('/movie/${movie.id}');
  },
),
```

ضيف الـ import:
```dart
import 'package:go_router/go_router.dart';
```

**ضيف onTap للـ MoviesSection برضه:**

```dart
MoviesSection(
  title: 'Popular',
  movies: state.popularMovies,
  onMovieTap: (movie) => context.push('/movie/${movie.id}'),
),
```

### ✅ Testing الـ Phase 3

بعد ما تخلص:

1. Hot restart (`R` في terminal)
2. دوس على أي فيلم
3. المفروض:
   - Smooth Hero animation للبوستر
   - Parallax scroll للـ backdrop
   - تفاصيل الفيلم ظاهرة
   - Similar movies section تحت

---

## 🔄 Development Workflow

### للشغل على feature جديدة

```bash
# 1. اعمل branch جديد
git checkout -b feature/movie-details

# 2. اشتغل بالترتيب: Domain → Data → Bloc → UI
# (في حالة Phase 3، Data موجود أصلاً)

# 3. Hot reload كل شوية تتأكد إن كل حاجة تمام
# في terminal اضغط r

# 4. Commit كل step صغير
git add .
git commit -m "feat: add MovieDetails domain layer"

# 5. لما تخلص كل حاجة
git push origin feature/movie-details
```

### TDD Workflow (موصى به)

```bash
# لكل use case جديد:
# 1. اكتب الـ test الأول (RED)
# 2. اكتب الـ code (GREEN)
# 3. refactor

# شغل الـ tests
flutter test

# شغل test ملف معين
flutter test test/features/movies/presentation/bloc/movies_bloc_test.dart
```

---

## 🛠️ Common Commands

### Development

```bash
# Run التطبيق
flutter run                          # أول جهاز متاح
flutter run -d <device_id>           # جهاز محدد
flutter run --release                # Release mode

# شوف الأجهزة
flutter devices
flutter emulators                    # قائمة emulators
flutter emulators --launch <id>      # شغل emulator

# Cleanup
flutter clean                        # امسح build cache
rm -rf ~/.pub-cache/hosted           # امسح pub cache (extreme)
```

### Code Quality

```bash
# تحليل الكود (مش في errors)
flutter analyze

# Format الكود
dart format lib/ test/

# Fix auto-fixable issues
dart fix --apply
```

### Dependencies

```bash
# نزل dependencies
flutter pub get

# upgrade dependencies
flutter pub upgrade

# شوف packages خارج الـ version الحالية
flutter pub outdated
```

### Testing

```bash
# شغل كل الـ tests
flutter test

# Coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Watch mode (restart tests on file change)
# لازم تنزل: dart pub global activate test_runner
```

---

## 🐛 Debugging Tips

### Print-based debugging

```dart
import 'package:flutter/foundation.dart';

debugPrint('🎬 Movies loaded: ${movies.length}');

// لو عايز تطبع object كامل
debugPrint(movie.toString());
```

### DevTools (أقوى tool)

لما تشغل `flutter run`، في الـ terminal هتلاقي:
```
An Observatory debugger and profiler is available at: http://127.0.0.1:XXXX/
```

اضغط `?` في الـ terminal وهيديك options:
- `d` → Open DevTools
- `w` → Dump widget hierarchy
- `s` → Dump render tree

### Bloc Observer (بنستخدمه بالفعل)

هتلاقي في الـ terminal:
```
📨 Event in MoviesBloc: LoadHomeMovies
🔄 MoviesBloc state changed
```

ده بيطبع كل event و state change.

### Network Debugging

احنا حاطين `PrettyDioLogger` فـ كل request/response هيطبع في terminal. لو مش عايزه:

في `lib/core/network/dio_client.dart`:
```dart
void _setupInterceptors() {
  _dio.interceptors.addAll([
    AuthInterceptor(),
    ErrorInterceptor(),
    if (kDebugMode)              // ← ضيف ده
      PrettyDioLogger(...),
  ]);
}
```

---

## ✅ Architecture Checklist

قبل ما تعمل commit، اتأكد:

### Domain Layer
- [ ] الـ Entity ما فيهاش `fromJson` أو `toJson`
- [ ] الـ Entity extends `Equatable`
- [ ] الـ Repository interface فيه methods واضحة
- [ ] كل UseCase بيعمل حاجة واحدة بس
- [ ] كل UseCase ليه Params class لو محتاج
- [ ] مفيش import لـ Flutter أو Dio في الـ domain

### Data Layer
- [ ] الـ Model فيها `fromJson` و `toJson`
- [ ] الـ Model فيها `toEntity()` method
- [ ] الـ DataSource Interface + Implementation
- [ ] الـ Repository بيترجم Exceptions لـ Failures
- [ ] بنستخدم `NetworkInfo` قبل الـ API calls

### Presentation Layer
- [ ] الـ Events و States في ملفات منفصلة (`part of`)
- [ ] الـ States extend `Equatable`
- [ ] الـ Bloc بياخد UseCases مش Repository مباشرة
- [ ] الـ UI بتستخدم `BlocBuilder` أو `BlocListener` حسب الحالة
- [ ] `sealed class` للـ States عشان exhaustive matching

### DI & Routing
- [ ] كل الـ dependencies مسجلة في `injection_container.dart`
- [ ] الـ Blocs مسجلة كـ `registerFactory` مش `registerLazySingleton`
- [ ] Routes واضحة في `app_router.dart`
- [ ] كل route فيه `BlocProvider`

---

## 📚 Quick Reference Cards

### Either usage

```dart
// إرجاع success
return Right(data);

// إرجاع failure
return Left(ServerFailure(message: 'error'));

// استخدام النتيجة
result.fold(
  (failure) => emit(State.error(failure.message)),
  (data) => emit(State.loaded(data)),
);
```

### Bloc patterns

```dart
// داخل Bloc - emit states
emit(const LoadingState());
emit(LoadedState(data));

// في الـ UI - read state
context.read<MoviesBloc>().state

// في الـ UI - add event
context.read<MoviesBloc>().add(const LoadMovies());

// في الـ UI - build based on state
BlocBuilder<MoviesBloc, MoviesState>(
  builder: (context, state) {
    return switch (state) {
      MoviesLoading() => CircularProgressIndicator(),
      MoviesLoaded(:final movies) => MoviesList(movies),
      MoviesError(:final message) => Text(message),
      _ => const SizedBox(),
    };
  },
)
```

### go_router navigation

```dart
// Push (يحتفظ بالصفحة السابقة)
context.push('/movie/123');

// Go (يستبدل الصفحة)
context.go('/home');

// Pop
context.pop();

// مع data
context.push('/movie/123', extra: movieObject);
```

---

## 🎯 بعد ما تخلص Phase 3

ابعتلي قل "خلصت Phase 3" أو ابعتلي screenshot من الـ Details page وهنبدأ:

**Phase 4 — Search Feature:**
- Search bar في AppBar
- Debounced API calls
- Recent searches (local)
- Empty/loading/no-results states

---

## 💡 نصائح من صاحبك Claude

1. **اعمل commit بعد كل task** — أسهل في الـ rollback
2. **شغل `flutter analyze` قبل كل commit** — ما تنسى warnings
3. **استخدم Hot Reload بكثرة** — بيوفر وقت
4. **لما تعلق** — ارجع لـ `docs/ARCHITECTURE.md` أو اسألني
5. **Clean Architecture في الأول بطيء** — بس بعد feature أو اتنين هتبقى سريع جداً

يلا بسم الله! 🚀
