# 🏛️ Clean Architecture — شرح مفصل بالعربي

## ليه إحنا بنعمل كل ده أصلاً؟

تخيل إنك شغال على Kee أو Spinneys لمدة سنة. التطبيق كبر. جه منيجر قالك:
- **"عايزين نغير الـ backend من REST لـ GraphQL"**
- **"عايزين ندعم offline mode"**
- **"عايزين نضيف tests"**

لو الـ UI متعلقة مباشرة بـ Dio والـ API calls، هتدمر دماغك. Clean Architecture بتحل ده.

---

## 🎯 الفكرة الأساسية: Dependency Rule

```
    Presentation   →   Domain   ←   Data
      (Flutter)         (Pure)      (Dio, DB)
```

**Arrows بتشاور للـ Domain، مفيش arrow بيطلع منه.**

- Domain ماعندوش ولا import من Flutter
- Domain ماعندوش ولا import من Dio
- Domain pure Dart classes بس

---

## 📐 الـ Layers الثلاثة

### 1️⃣ Domain Layer — "اللي التطبيق بيعمله"

ده القلب. لو بدلنا Flutter بـ React Native، Domain يفضل زي ما هو.

**محتوياته:**
- **Entities**: الـ business models (Movie, User, Favorite)
- **Repositories (abstract)**: contracts بس، مفيش implementation
- **UseCases**: كل action واحدة في الأبليكيشن

**مثال Movie Entity:**
```dart
class Movie {
  final int id;
  final String title;
  final double voteAverage;
  // لا JSON، لا Dio، لا Flutter
}
```

**مثال UseCase:**
```dart
class GetPopularMovies {
  final MovieRepository repository; // interface
  Future<Either<Failure, List<Movie>>> call(PageParams params) {
    return repository.getPopularMovies(page: params.page);
  }
}
```

### 2️⃣ Data Layer — "من فين بتيجي الداتا"

هنا بيحصل الـ "القذر":
- API calls
- Database queries
- SharedPreferences

**محتوياته:**
- **Models (DTOs)**: بتعمل JSON → Entity
- **DataSources**: Remote (Dio) + Local (Isar/SharedPrefs)
- **Repository Implementations**: بتنفذ الـ contracts اللي في Domain

**مثال Repository Impl:**
```dart
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remote;
  final NetworkInfo network;

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({required int page}) async {
    if (!await network.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final models = await remote.getPopularMovies(page: page);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
```

لاحظ: **الـ Repository بيترجم Exceptions (من Data) لـ Failures (في Domain).** Domain ما لازمش يعرف عن DioException.

### 3️⃣ Presentation Layer — "اللي المستخدم بيشوفه"

**محتوياته:**
- **Bloc/Cubit**: State management
- **Pages**: Full screens
- **Widgets**: Reusable UI components

**مثال Bloc:**
```dart
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;

  Future<void> _onLoadMovies(LoadHomeMovies e, Emitter emit) async {
    emit(MoviesLoading());
    final result = await getPopularMovies(PageParams(page: 1));
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) => emit(MoviesLoaded(popularMovies: movies, ...)),
    );
  }
}
```

---

## 🔄 Data Flow Example — "مستخدم فتح الـ Home"

```
1. User يفتح HomePage
         │
         ▼
2. HomePage.initState() → context.read<MoviesBloc>().add(LoadHomeMovies())
         │
         ▼
3. MoviesBloc:
   - emit(MoviesLoading())
   - يستدعي GetPopularMovies(params)
         │
         ▼
4. GetPopularMovies (UseCase):
   - ينادي movieRepository.getPopularMovies(page: 1)
         │
         ▼
5. MovieRepositoryImpl:
   - يتحقق من الإنترنت (NetworkInfo)
   - ينادي remoteDataSource.getPopularMovies(page: 1)
         │
         ▼
6. MovieRemoteDataSourceImpl:
   - يستخدم Dio لعمل GET /movie/popular?page=1
   - يحول الـ JSON لـ List<MovieModel>
         │
         ▼
7. Return journey:
   - RemoteDataSource → List<MovieModel>
   - Repository: MovieModel.toEntity() → Right(List<Movie>)
   - UseCase: بيعدي الـ Either زي ما هي
   - Bloc: Either.fold() → emit(MoviesLoaded(movies))
         │
         ▼
8. BlocBuilder في الـ UI:
   - يشوف state = MoviesLoaded
   - يرسم الأفلام
```

---

## 🤔 ليه Either<Failure, T>؟

في Kotlin إحنا عندنا:
```kotlin
sealed class Result<T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val failure: Failure) : Result<Nothing>()
}
```

في Dart، `dartz` بيوفرلنا `Either<L, R>`:
- `Left(failure)` = error
- `Right(value)` = success

**ليه مش throw exceptions في UseCases؟**
- Exceptions في Dart unchecked
- ممكن تنسى تمسكهم
- Either بيجبرك تتعامل مع الـ 2 cases

**Fold pattern:**
```dart
result.fold(
  (failure) => /* handle error */,
  (data) => /* handle success */,
);
```

زي `when` في Kotlin tamaman.

---

## 🧪 Testability

الـ layers المنفصلة دي بتخلي الـ testing سهل جداً:

```dart
// Test UseCase — مفيش Dio، مفيش Flutter
test('GetPopularMovies returns movies on success', () async {
  final mockRepo = MockMovieRepository();
  when(() => mockRepo.getPopularMovies(page: 1))
    .thenAnswer((_) async => Right([testMovie]));

  final useCase = GetPopularMovies(mockRepo);
  final result = await useCase(const PageParams(page: 1));

  expect(result, Right([testMovie]));
});

// Test Bloc — مفيش UI
blocTest<MoviesBloc, MoviesState>(
  'emits [Loading, Loaded] on LoadHomeMovies',
  build: () => MoviesBloc(getPopularMovies: mockUseCase, ...),
  act: (bloc) => bloc.add(const LoadHomeMovies()),
  expect: () => [
    isA<MoviesLoading>(),
    isA<MoviesLoaded>(),
  ],
);
```

---

## ⚖️ متى لا تستخدم Clean Architecture؟

**لو عندك:**
- Todo app فيه 3 screens
- Prototype / Hackathon project
- MVP بتعمله في أسبوع

**مش محتاجها.** Overhead أكبر من الفائدة.

**محتاجها لما:**
- Production app
- Team أكتر من 2 devs
- Features كتير هتتضاف
- Testing مهم

---

## 🎓 نصائح من تجربتي في KMP

1. **ماتبالغش في الـ abstractions** — مش كل حاجة محتاجة interface
2. **UseCase = 1 method فقط** — لو بتضيف methods، اعمل UseCase جديد
3. **الـ Models منفصلة عن Entities** — إوعى تخلي الـ Entity فيها `fromJson`
4. **الـ Failure واحد، الـ Exception تاني** — متخلطهمش
5. **الـ Bloc ماياخدش من الـ Repository مباشرة** — UseCases بس

---

## 📚 Further Reading

- Robert C. Martin — *Clean Architecture* (الكتاب الأصلي)
- ResoCoder's Flutter TDD Clean Architecture series (YouTube)
- Very Good Ventures blog — Bloc best practices
