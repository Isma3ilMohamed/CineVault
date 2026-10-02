# CineVault — Architecture Notes

> Refactor plan for moving CineVault onto the agreed **Target Architecture** (Obsidian: `Projects/Target Architecture.md`).
> Written from a full read of `lib/` (~6.8k lines, excluding generated l10n). Date: 2026-10-02.

**الهدف الأساسي:** كود **بيتقري** — أي حد يفتح feature يعرف كل ملف بيعمل إيه من اسمه، ومفيش ملف شايل مسؤوليات مش بتاعته (زي `app_router.dart` النهارده).

---

## 0. الخلاصة

| | الحالة |
|---|---|
| `sealed Result` | ✅ موجود (`core/result/result.dart`) — نوتة Obsidian لسه بتقول dartz `Either`، محتاجة تتحدث |
| Repository interfaces في `domain` | ✅ |
| UseCases | ⚠️ موجودة بس الـ Blocs بتتخطاها |
| `sealed` State / Event | ✅ (بس الـ modifiers مش موحدة) |
| حدود بالـ compiler (melos) | ❌ package واحدة، فولدرات بس |
| Route / Screen / Content | ❌ `Page` واحدة شايلة كله (`movie_details_page.dart` = 440 سطر) |
| Effects | ❌ مش موجودة |
| Tests | ❌ ملف واحد، 3 tests |
| Lint / readability rules | ❌ `flutter_lints` الافتراضي بس |

> ⚠️ **المشروع مش git repo** — `git init` + commit للوضع الحالي قبل أي خطوة.

---

## 1. الـ Feature Anatomy (القاعدة الأهم)

كل شاشة = **6 ملفات بأسماء ثابتة**. الاسم بيقولك المسؤولية، والـ lint بيمنع أي ملف يتعدى حدوده.

```
packages/features/movie_details/
├── lib/
│   ├── movie_details.dart                  ← barrel: بيصدّر الـ Route والـ NavigationEffect بس
│   └── src/
│       ├── movie_details_route.dart        ← ENTRY & EXIT
│       ├── movie_details_navigation.dart   ← EXIT: NavigationEffect (من الـ UI)
│       ├── movie_details_screen.dart       ← STATE BINDING
│       ├── movie_details_content.dart      ← PURE UI
│       ├── movie_details_contract.dart     ← State · Event · Effect
│       ├── movie_details_bloc.dart         ← VIEW MODEL
│       └── widgets/                        ← أجزاء الـ Content (pure برضه)
│           ├── details_header.dart
│           └── cast_row.dart
└── test/
    ├── movie_details_bloc_test.dart
    └── movie_details_content_golden_test.dart
```

### مين يعمل إيه — ومين ممنوع يعرف إيه

| الملف | المسؤولية | مسموح يعمل import لـ | **ممنوع** |
|---|---|---|---|
| `_route` | يجيب الـ Bloc من DI · يبعت أول event **مرة واحدة** · يسمع الـ `Effect` · يحوّل `NavigationEffect` → callbacks | كل حاجة في الـ feature | `go_router` (الـ package أصلاً مش معتمد عليه) |
| `_navigation` | `sealed class XxxNavigationEffect` — ضغطات مباشرة (`OnBack`, `OpenMovie`) | `domain` | أي حاجة تانية |
| `_screen` | `BlocBuilder` → Content · يحوّل callbacks الـ Content لـ Event أو NavigationEffect | `flutter_bloc` · contract · content · navigation | DI · `go_router` · use cases |
| `_content` | رسم بس — `StatelessWidget` بياخد state + callbacks | `flutter` · `core_ui` · `domain` entities | `flutter_bloc` · الـ bloc · الـ contract events |
| `_contract` | `XxxState` · `XxxEvent` · `XxxEffect` | `domain` · `equatable`/`freezed` | `flutter` |
| `_bloc` | events → state + effects | contract · `domain` use cases · `core/base` | **`flutter`** (pure Dart، `package:bloc` بس) |

### نوعين Effects (زي الشغل)
| | مصدره | مثال | بيتعرّف في |
|---|---|---|---|
| `XxxEffect` | الـ **Bloc** بعد منطق/async | `ShowError(failure)` · `NavigateToDetails(id)` بعد lookup | `_contract` |
| `XxxNavigationEffect` | الـ **UI** ضغطة مباشرة | `OnBack` · `OpenMovie(id, heroTag)` | `_navigation` |

**القاعدة:** تنقل ناتج عن **منطق** = `Effect`. تنقل ناتج عن **ضغطة** = `NavigationEffect`. الاتنين بيتجمعوا في **الـ Route بس**.

### Skeleton

```dart
// movie_details_navigation.dart
sealed class MovieDetailsNavigationEffect { const MovieDetailsNavigationEffect(); }
final class OnBack extends MovieDetailsNavigationEffect { const OnBack(); }
final class OpenMovie extends MovieDetailsNavigationEffect {
  const OpenMovie(this.movieId);
  final int movieId;
}
```

```dart
// movie_details_route.dart
class MovieDetailsRoute extends StatelessWidget {
  const MovieDetailsRoute({
    required this.movieId,
    required this.onBack,
    required this.onOpenMovie,
    super.key,
  });

  final int movieId;
  final VoidCallback onBack;
  final ValueChanged<int> onOpenMovie;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieDetailsBloc>()..add(MovieDetailsStarted(movieId)),
      child: BlocEffectListener<MovieDetailsBloc, MovieDetailsEffect>(
        onEffect: (context, effect) => switch (effect) {
          ShowError(:final failure) => context.showFailure(failure),
        },
        child: MovieDetailsScreen(
          onNavigation: (effect) => switch (effect) {
            OnBack() => onBack(),
            OpenMovie(:final movieId) => onOpenMovie(movieId),
          },
        ),
      ),
    );
  }
}
```

```dart
// movie_details_screen.dart
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({required this.onNavigation, super.key});

  final ValueChanged<MovieDetailsNavigationEffect> onNavigation;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieDetailsBloc>();
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) => MovieDetailsContent(
        state: state,
        onBack: () => onNavigation(const OnBack()),
        onMovieTap: (id) => onNavigation(OpenMovie(id)),
        onRetry: () => bloc.add(const MovieDetailsRetried()),
      ),
    );
  }
}
```

```dart
// movie_details_content.dart — no bloc, no navigation, golden-testable
class MovieDetailsContent extends StatelessWidget {
  const MovieDetailsContent({
    required this.state,
    required this.onBack,
    required this.onMovieTap,
    required this.onRetry,
    super.key,
  });
  // ...
}
```

### الـ Base في `core/base`
- `mixin EffectEmitter<E>` على الـ Bloc — `StreamController<E>.broadcast()` + `emitEffect(E)` + بيتقفل في `close()`. ده المقابل لـ `Channel` + `receiveAsFlow`.
- `BlocEffectListener<B, E>` widget — بيعمل subscribe في `initState` وبيلغي في `dispose`.
- `allowedEvents` — `assert` في debug و log في release لو الـ event مش مسموح في الـ state الحالية.
- **helper واحد بس.** لو حد احتاج تاني، نسأل ليه.

---

## 2. Readability — الـ "ktlint" بتاعنا

ktlint = formatter + ruleset. في Flutter بنعملها على 3 طبقات:

### الطبقة 1 — Formatter: `dart format`
- ✅ `environment.sdk: ^3.13.0` (Phase 0-B). `very_good_analysis` 11 محتاج 3.13، فـ `^3.7` كان هيبقى constraint كدّاب. الـ formatter بقى "tall style" — بيحط الـ trailing commas ويكسر السطور لوحده.
- **ممنوع الـ syntax الجديدة بتاعة Dart 3.13** (`new(...)` بدل اسم الكلاس، و `class X;` بدل `class X {}`) — الـ lints اللي بتفرضها مقفولة في `analysis_options.yaml`. الهدف قراءة، مش أحدث syntax.

```yaml
# analysis_options.yaml
formatter:
  page_width: 100
```

### الطبقة 2 — Lint rules: `very_good_analysis`
مجموعة strict جاهزة (أشد بكتير من `flutter_lints`) + شوية إضافات:

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    # warnings = errors — الـ CI ميعديش
    missing_required_param: error
    missing_return: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/generated/**"

linter:
  rules:
    public_member_api_docs: false   # مش library عامة
    prefer_final_locals: true
    avoid_dynamic_calls: true       # كان هيمسك _getMoviesList
    use_build_context_synchronously: true
```

### الطبقة 3 — قواعدنا: analyzer plugin (`cine_vault_lints`)
الـ Dart الحديث بيدعم analyzer plugins مباشرة (`plugins:` في `analysis_options.yaml`). بنعمل package صغيرة فيها القواعد اللي محدش هيكتبهالنا — **ده اللي بيفرض الـ Feature Anatomy**:

| القاعدة | بتمنع إيه |
|---|---|
| `content_must_be_pure` | `*_content.dart` و`widgets/` يعملوا import لـ `flutter_bloc` أو `*_bloc.dart` |
| `bloc_must_be_pure_dart` | `*_bloc.dart` و`*_contract.dart` يعملوا import لـ `package:flutter` |
| `screen_no_di` | `*_screen.dart` يستخدم `getIt` |
| `provider_only_in_route` | `BlocProvider` / `BlocEffectListener` برّه `*_route.dart` |
| `no_navigation_in_features` | `context.push` / `Navigator.` جوه أي feature package |
| `max_file_lines` | ملف > 250 سطر (Content يتقسم لـ `widgets/`) |
| `no_build_helper_methods` | `Widget _buildX()` — تتحول لـ private widget class (أوضح + rebuilds أقل) |
| `no_hardcoded_colors` | `Color(0x...)` برّه `core_ui/theme` |
| `english_comments_only` | تعليقات فيها حروف عربي |

> لو الـ plugin API طلع لسه مش مستقر وقت التنفيذ، البديل `custom_lint` بنفس القواعد.

### Enforcement
```bash
# melos scripts
melos run format   # dart format --set-exit-if-changed .
melos run analyze  # dart analyze --fatal-infos
melos run test
```
+ pre-commit hook (`lefthook`) بيشغّل format + analyze على الملفات المتغيرة بس.

### قواعد مكتوبة (للي الـ lint مش هيمسكه)
1. **ملف = مسؤولية واحدة = class عامة واحدة** (الـ contract استثناء).
2. اسم الملف بيقول الدور: `_route` · `_screen` · `_content` · `_contract` · `_bloc` · `_navigation`.
3. Events بصيغة الماضي: `MovieDetailsStarted` · `MovieDetailsRetried` (مش `LoadMovieDetails`).
4. `final class` لكل حاجة في الـ contract والـ navigation.
5. Comments بالإنجليزي، وبتشرح **ليه** مش **إيه**.
6. مفيش `dynamic`، ومفيش `as` cast من غير سبب مكتوب.

---

## 3. الـ Modules (melos)

```
cine_vault/
├── app/                    main · DI composition · theme wiring · MaterialApp
├── packages/
│   ├── core/
│   │   ├── base/           EffectEmitter · BlocEffectListener · allowedEvents
│   │   ├── result/         Result · sealed Failure
│   │   ├── network/        Dio client · interceptors
│   │   ├── storage/        Hive · SharedPreferences wrappers
│   │   └── ui/             theme tokens · MovieCard · shimmer · error view
│   ├── domain/             entities · repository interfaces · use cases   (pure Dart)
│   ├── data/               repo impls · DTOs · data sources · mappers
│   ├── features/
│   │   ├── home/  movie_details/  movie_list/  search/  favorites/  settings/
│   ├── navigation/         typed routes · shell · wiring callbacks
│   └── lints/              cine_vault_lints (analyzer plugin)
└── melos.yaml
```

| Package | بيعتمد على | ممنوع |
|---|---|---|
| `domain` | — | أي حاجة (ولا `flutter`) |
| `data` | `domain` · `core/*` | `features` |
| `features/*` | `domain` · `core/*` | `data` · `go_router` · features تانية |
| `navigation` | `features/*` · `domain` | `data` |
| `app` | الكل | — |

**الـ Feature = شاشة**، مش "movies". `movies` الحالية بتتقسم لـ `home` · `movie_details` · `movie_list`.

---

## 4. Navigation — علاج صداع `app_router.dart`

**الحالي:** ملف واحد بيعمل 6 حاجات (routing · DI · BlocProvider · dispatch · parsing · error UI).

**الجديد:** كل route في ملف، والـ builder سطر واحد:

```
packages/navigation/lib/src/
├── app_router.dart              ← الـ tree بس (shell + list of routes)
├── app_shell.dart
└── routes/
    ├── home_route_data.dart
    ├── movie_details_route_data.dart
    ├── movie_list_route_data.dart
    ├── search_route_data.dart
    ├── favorites_route_data.dart
    └── settings_route_data.dart
```

```dart
// movie_details_route_data.dart
@TypedGoRoute<MovieDetailsRouteData>(path: '/movie/:movieId')
class MovieDetailsRouteData extends GoRouteData {
  const MovieDetailsRouteData({required this.movieId});
  final int movieId; // parsed & validated by the generator

  @override
  Widget build(BuildContext context, GoRouterState state) => MovieDetailsRoute(
        movieId: movieId,
        onBack: context.pop,
        onOpenMovie: (id) => MovieDetailsRouteData(movieId: id).push(context),
      );
}
```

- مفيش strings — الـ paths والـ params typed.
- مفيش `state.extra` → الـ heroTag يتشال أو يتحسب من الـ `movieId` (`'poster-$id'`) فيشتغل مع deep links.
- مفيش DI ولا `BlocProvider` في الـ navigation — ده شغل الـ Route.
- `themeBoundaryKey` يطلع من الراوتر → `InheritedWidget` في `app` يقراه `ThemeRevealController`.
- نحافظ على: `StatefulShellRoute.indexedStack` · `parentNavigatorKey` للشاشات فوق الـ shell.

---

## 5. Findings من الكود الحالي

### 🐛 Bugs
| # | المشكلة | المكان | الحل |
|---|---|---|---|
| 1 | **Race في البحث** — `_SearchExecuted` بيشتغل concurrent؛ request قديم يرجع متأخر يكتب فوق الأحدث | `search_bloc.dart` | `restartable()` + debounce transformer بدل الـ `Timer` |
| 2 | **Interceptor بيعمل `throw`** جوه `onError` — Dio 5 بيلفها في `DioException`، فالـ `on NetworkException` مش بيلقطها والمستخدم يشوف `"Unexpected error: DioException..."` (**محتاج تأكيد بتجربة offline**) | `error_interceptor.dart` | الـ interceptor يعمل `handler.reject(...)`، والـ mapping من `DioException` → Failure في `guard()` |
| 3 | `RefreshIndicator` بيقفل فوراً — `onRefresh` مش بيستنى | `home_page.dart` | `await bloc.stream.firstWhere(...)` أو `Completer` في الـ event |
| 4 | Load-more بيضيف على `popularMovies` اللي الـ carousel بيعرضها | `movies_bloc.dart` | الـ carousel ياخد snapshot منفصل |
| 5 | `.env` (فيه TMDB key) bundled في الـ assets | `pubspec.yaml` | `--dart-define-from-file` |
| 6 | أول load بيتعمل من `build()` بـ `addPostFrameCallback` (نفس bug `LaunchedEffect(state)`) | `home_page.dart` | الـ Route يبعت `Started` مرة واحدة |

### 🏗️ Architecture
- **Circular dependency** `movies` ⇄ `favorites`: `MovieCard` → `FavoriteHeartButton` → … ← `favorites_page` → `MovieCard`. الحل: `MovieCard` في `core/ui` بـ `trailing: Widget?`.
- **`Movie` entity** مستخدمة في 4 features → مكانها `domain`.
- **Domain فيها Flutter**: `settings/domain` بتعمل import لـ `material.dart` (`ThemeMode`, `Locale`) في 4 ملفات → `AppThemeMode` enum + `String? languageCode`.
- **`Movie.fullPosterUrl`** فيها TMDB URLs → mapper في `data` أو helper في `core/ui`.
- **UseCases بتتخطّى**: `MoviesBloc` و`MovieListBloc` بيكلموا `MovieRepository` مباشرة → use case واحد `GetMoviesByCategory`.
- **منطق اختيار الـ trailer** في `MovieDetailsBloc` → use case `GetMovieTrailer` أو method على `List<Video>` في الـ domain.
- **`injection_container.dart`** في `core` بيعمل import لكل الـ features → `injectable` + module لكل package، والـ composition في `app`.
- Global cubits متسجلة بطرق مختلفة (`create:` مع lazy singleton، و`.value` مع singleton) → قاعدة واحدة.

### ⚠️ Errors
- `Failure` معمولة `abstract` → **`sealed`** عشان الـ `switch` exhaustive.
- رسايل الـ Failure **عربي ومتكتبة في الكود** وبتتعرض مباشرة (`failure.message`) → الـ i18n بايظ. الـ presentation تعمل `switch` على نوع الـ Failure وتجيب النص من `AppLocalizations`.
- try/catch متكرر ×5 في `MovieRepositoryImpl` + `_getMoviesList` بـ `dynamic` → `Future<Result<T>> guard<T>(Future<T> Function())` واحد في `data`.
- `NetworkInfo.isConnected` قبل كل request — connectivity ≠ internet، وDio بيرمي أصلاً → يتشال.

### 🧹 Readability
- `Color(0xFFE50914)` متكرر 18 مرة → token في `core/ui`.
- ~~76 ملف فيهم تعليقات عربي.~~ ✅ اتشالت (2026-10-02): الكومنتات التعليمية اتمسحت، واللي بيشرح "ليه" اتحوّل لسطر إنجليزي.
- `_buildX()` methods في كل الـ pages → private widgets.
- Modifiers مش موحدة (`movies_event` classes عادية، `search`/`details` `final class`).
- `List<Movie>` في الـ states → `IList` (`fast_immutable_collections`).
- `copyWith` يدوي في كل state.

---

## 6. خطة التنفيذ

| Phase | الشغل | Done when |
|---|---|---|
| **0-A** | إصلاح الـ test القديم · bugs 1، 2، 5 · flavors (staging/production) + config per flavor | tests خضرا، الـ flavors بتعمل build على Android و iOS |
| **0-B** | رفع الـ SDK لـ `^3.13` · `very_good_analysis` · `dart format` · `dart fix` + إصلاح الباقي بإيدينا | ✅ `flutter analyze`: No issues |
| **1** | melos workspace · `core/result` (sealed Failure) · `core/base` (EffectEmitter, BlocEffectListener, allowedEvents) + tests | الـ base مغطاة بـ tests |
| **2** | `lints` package — أول 4 قواعد (content pure · bloc pure · provider only in route · no navigation in features) | القواعد بتفشل على الكود الحالي ✔ |
| **3** | `domain` pure Dart · نقل الـ entities · `GetMoviesByCategory` · `GetMovieTrailer` + tests | `domain` من غير `flutter` |
| **4** | `data` · `guard()` · interceptor بـ `reject` · repo tests | |
| **5** | **`movie_details`** كنموذج كامل بالـ 6 ملفات + bloc test + golden | ده الـ reference لباقي الـ features |
| **6** | `home` · `movie_list` · `search` · `favorites` · `settings` على نفس النموذج | |
| **7** | `navigation` typed routes · `injectable` · `app` composition · باقي قواعد الـ lint | `app_router.dart` < 80 سطر |

---

## 7. القرارات

| القرار | الحالة |
|---|---|
| `freezed` للـ states والـ contracts | ✅ متفق (2026-10-02) |
| `go_router_builder` للـ typed routes | ✅ متفق |
| melos من Phase 1 | ✅ متفق |
| Flavors: `staging` · `production` | ✅ متعملة في Phase 0 |
| analyzer plugin ولا `custom_lint` | ⏳ نقرر في Phase 2 بعد ما نجرّب الـ plugin API على Dart 3.13 |
| إعادة تسمية الـ app id (`cine_vault_temp` → ?) | ⏳ مفتوح |

## 8. Workflow
- **مفيش commit من غير مراجعة.** كل دفعة بتتسلّم كـ diff، والـ commit بيحصل بعد الموافقة.
- التغييرات الميكانيكية (format · `dart fix`) دايماً في دفعة لوحدها عشان متدفنش التغييرات الحقيقية.
