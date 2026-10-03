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

### الـ Base في `core/base` ✅ (Phase 1)
مدخلين عشان الـ bloc والـ contract يفضلوا pure Dart:
- `package:core_base/core_base.dart` (من غير Flutter):
  - `mixin EffectEmitter<S, E> on BlocBase<S>` — `emitEffect(effect)` + `effects` stream. الـ effect بيوصل **مرة واحدة**: لو مفيش listener بيتخزن لحد أول واحد، ومبيتعادش لحد بعده. نفس سلوك `Channel` في CMP.
  - `mixin EventGuard<E, S> on Bloc<E, S>` — بديل `allowedEvents`. الـ bloc بيعمل override لـ `isEventAllowed(event, state)` بـ `switch ((state, event))`. المرفوض: `assert` في debug، و log + تجاهل في release. **الـ check بيحصل وقت `add()`** على الـ state الحالية، مش وقت معالجة الـ event.
  - اتحط على الـ bloc مش الـ state عشان مايحتاجش `const State._()` مع `freezed`.
- `package:core_base/widgets.dart`: `BlocEffectListener<B, E>` — بياخد الـ bloc من `BlocProvider` أو من `bloc:`، وبيعمل resubscribe لو الـ bloc اتغير.
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

### الطبقة 3 — قواعدنا: analyzer plugin (`cine_vault_lints`) ✅ (Phase 2)
analyzer plugin بالـ API الجديد (`analysis_server_plugin`، Dart ≥ 3.10) في `packages/lints`، متفعّل من `plugins:` في الـ root `analysis_options.yaml`. **ده اللي بيفرض الـ Feature Anatomy.**

- **النطاق:** قواعد الـ anatomy على `packages/features/<name>/lib/` بس، ودور الملف بيتحدد من اسمه (`_route` · `_navigation` · `_screen` · `_content` · `_contract` · `_bloc` / `_cubit` · `widgets/`). القواعد العامة (طول الملف · `_buildX` · الألوان · التعليقات) على كل الكود اللي مكتوب بإيد في `packages/*/lib` و`app/lib`، من غير الـ generated (`isHandWrittenSource`).
- **الـ severity:** warning، يعني بتقع في `melos run analyze`، وبتظهر في الـ IDE.
- **⚠ `dart analyze` مش `flutter analyze`:** على Flutter 3.47، `flutter analyze` **مبيطلّعش** الـ diagnostics بتاعة الـ plugins (اتجرّب). وكمان الـ plugins **بتشتغل بس لما الـ analyze يتعمل من root الـ workspace** (تحليل فولدر فرعي مش بيشغّلها).
- **الـ package برّه الـ workspace بقصد:** الـ analysis server بيعمل resolution للـ plugin في synthetic package لوحدها، و`analyzer` بيمشي مع إصدار الـ SDK.
- بعد أي تعديل في الـ plugin أو في `plugins:`، لازم تعمل restart للـ analysis server في الـ IDE.

| القاعدة | الحالة | بتمنع إيه |
|---|---|---|
| `content_must_be_pure` | ✅ | `_content` و`widgets/` يعملوا import لـ `bloc` / `flutter_bloc` / `provider` / `get_it` / `go_router` / `core_base` أو `*_bloc` / `*_route` / `*_screen` |
| `bloc_must_be_pure_dart` | ✅ | `_bloc` و`_contract` و`_navigation` يعملوا import لـ `flutter` / `dart:ui` / `flutter_bloc` / `go_router` / `core_base/widgets.dart` |
| `provider_only_in_route` | ✅ | `BlocProvider` / `MultiBlocProvider` / `RepositoryProvider` / `BlocEffectListener` يتعملوا برّه `_route` (بيتشيّك على الـ library الحقيقية، فأي class بنفس الاسم مش بيتأثر) |
| `no_navigation_in_features` | ✅ | `go_router` / `auto_route` أو `Navigator` في أي ملف feature، **حتى الـ Route نفسه** (الـ Route بياخد callbacks) |
| `screen_no_di` | ✅ Phase 7 | `*_screen.dart` يعمل import لـ `get_it` أو `injectable` (الـ Screen بيقرا الـ bloc بـ `context.read`) |
| `max_file_lines` | ✅ Phase 7 | ملف أكبر من 250 سطر (الـ Content يتقسم لـ `widgets/`) |
| `no_build_helper_methods` | ✅ Phase 7 | method أو function خاصة (`_x`) بترجّع `Widget`: تتحول لـ private widget class. الـ local functions جوه `build` مسموحة |
| `no_hardcoded_colors` | ✅ Phase 7 | `Color(...)` برّه `packages/core/ui/lib/src/theme/` |
| `english_comments_only` | ✅ Phase 7 | تعليق فيه حروف عربي (الـ strings مش تعليقات، والنصوص مكانها الـ ARB) |

### Enforcement
```bash
# melos scripts
melos run format   # dart format --set-exit-if-changed .
melos run analyze  # dart analyze --fatal-infos (+ pub get للـ plugin)
melos run test     # dart test + flutter test + plugin tests
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
cine_vault/                 pubspec.yaml: workspace list + melos scripts
├── app/                    main · DI order (composition root) · MaterialApp · android/ ios/ config/
├── packages/
│   ├── core/
│   │   ├── base/           EffectEmitter · EventGuard · BlocEffectListener
│   │   ├── result/         Result · sealed Failure
│   │   └── ui/             theme tokens · PosterCard · RemoteImage · ErrorView   (no domain)
│   ├── domain/             entities · repository interfaces · use cases   (pure Dart)
│   ├── data/               repo impls · DTOs · data sources · Dio · storage
│   ├── shared/
│   │   └── movie_ui/       MovieCard · MovieGrid · category labels   (domain + core_ui)
│   ├── features/
│   │   ├── home/  movie_details/  movie_list/  search/  favorites/  settings/
│   ├── navigation/         typed routes · shell · the favorite-button slot
│   └── lints/              cine_vault_lints (analyzer plugin)
```
> الخطة الأولى كان فيها `core/network` و`core/storage`. ماتعملوش بقصد: الـ Dio والـ storage مستخدمين في `data` بس، وفصلهم كان هيعمل packages من غير حد تاني يستخدمها.

> ⚠ **الـ pub workspace مش بيفرض الحدود لوحده:** الـ resolution مشتركة، فأي import لـ package مش موجودة في الـ pubspec بيشتغل عادي. الحماية جاية من `depend_on_referenced_packages: error` في الـ root `analysis_options.yaml` (Phase 3)، وده اتجرّب: import لـ `flutter` من `domain` بقى error.

| Package | بيعتمد على | ممنوع |
|---|---|---|
| `domain` | — | أي حاجة (ولا `flutter`) |
| `data` | `domain` · `core/*` | `features` |
| `shared/*` | `domain` · `core/*` | `data` · `features` |
| `features/*` | `domain` · `core/*` · `shared/*` | `data` · `go_router` · features تانية |
| `navigation` | `features/*` · `shared/*` · `domain` | `data` |
| `app` | الكل | — |

**الـ Feature = شاشة**، مش "movies". `movies` الحالية بتتقسم لـ `home` · `movie_details` · `movie_list`.

---

## 4. Navigation — علاج صداع `app_router.dart` ✅ (Phase 7)

**كان:** ملف واحد بيعمل 6 حاجات (routing · DI · BlocProvider · dispatch · parsing · error UI)، 134 سطر.

**بقى:** `packages/navigation`. الـ `app_router.dart` بقى 41 سطر، وكل route في ملف لوحده:

```
packages/navigation/lib/src/
├── app_router.dart              ← library: الـ parts + `createAppRouter()` بس
├── app_shell.dart
├── favorite_button_slot.dart    ← المكان الوحيد اللي feature بتقابل فيه feature
├── route_error_screen.dart
└── routes/                      ← `part of` (الـ mixin اللي بيتولد private للـ library)
    ├── shell_route_data.dart    ← @TypedStatefulShellRoute + الـ 3 branches
    ├── home_route_data.dart
    ├── movie_details_route_data.dart
    ├── movie_list_route_data.dart
    ├── search_route_data.dart
    ├── favorites_route_data.dart
    └── settings_route_data.dart
```

```dart
// routes/movie_details_route_data.dart
@TypedGoRoute<MovieDetailsRouteData>(path: '/movie/:id')
class MovieDetailsRouteData extends GoRouteData with $MovieDetailsRouteData {
  const MovieDetailsRouteData({required this.id, this.heroTag});
  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavigatorKey;
  final int id;          // parsed by the generator
  final String? heroTag; // ?hero-tag= query parameter

  @override
  Widget build(BuildContext context, GoRouterState state) => MovieDetailsRoute(
    movieId: id,
    heroTag: heroTag,
    favoriteButton: favoriteButtonSlot,
    onBack: context.pop,
    onOpenMovie: (id, heroTag) =>
        unawaited(MovieDetailsRouteData(id: id, heroTag: heroTag).push<void>(context)),
  );
}
```

- **مفيش strings:** الـ paths والـ params typed (`int` · `MovieCategory`). `MovieCategory.slug` و`fromSlug` اتشالوا من الـ domain، والـ URL بقى `/list/top-rated` من الـ generator.
- **مفيش `state.extra`:** الـ heroTag بقى query parameter اختياري، فالـ location بقى URL عادي ويشتغل كـ deep link (من غير tag = من غير Hero).
- **الـ links الغلط** (`/movie/abc` · `/list/unknown` · path مش موجود) بتروح لـ `RouteErrorScreen`. go_router بيمسك الـ parse error لوحده، وعليه tests.
- **مفيش DI ولا `BlocProvider` في الـ navigation:** ده شغل الـ Route بتاع الـ feature.
- **`themeBoundaryKey` طلع من الراوتر:** `ThemeRevealBoundary` في `settings` (InheritedWidget + RepaintBoundary)، والـ app بيحطه في `MaterialApp.builder`. وعليه test بيثبت إن الـ animation بتعدي من خلاله.
- **حافظنا على:** `StatefulShellRoute.indexedStack` (كل tab ليه stack) · `parentNavigatorKey` للشاشات فوق الـ shell.
- **`go_router` اترفع من 14 لـ 17** عشان `go_router_builder` 4.5.

---

## 5. Findings من الكود الحالي

### 🐛 Bugs
| # | المشكلة | المكان | الحل |
|---|---|---|---|
| 1 | **Race في البحث** — `_SearchExecuted` بيشتغل concurrent؛ request قديم يرجع متأخر يكتب فوق الأحدث | `search_bloc.dart` | `restartable()` + debounce transformer بدل الـ `Timer` |
| 2 | **Interceptor بيعمل `throw`** جوه `onError` — Dio 5 بيلفها في `DioException`، فالـ `on NetworkException` مش بيلقطها والمستخدم يشوف `"Unexpected error: DioException..."` (**محتاج تأكيد بتجربة offline**) | `error_interceptor.dart` | الـ interceptor يعمل `handler.reject(...)`، والـ mapping من `DioException` → Failure في `guard()` |
| 3 | ✅ ~~`RefreshIndicator` بيقفل فوراً~~ (Phase 6) | `home` | الـ Screen بيستنى `isRefreshing` يرجع `false`. والـ refresh اللي بيفشل بقى بيسيب المحتوى ويطلّع snackbar (effect) بدل ما يقلب الشاشة كلها error |
| 4 | ✅ ~~Load-more بيضيف على `popularMovies`~~ (Phase 6) | `home` | `LoadMorePopularMovies` طلع ميت (محدش بيبعته)، فاتشال |
| 5 | `.env` (فيه TMDB key) bundled في الـ assets | `pubspec.yaml` | `--dart-define-from-file` |
| 6 | ✅ ~~أول load من `build()` بـ `addPostFrameCallback`~~ (Phase 6) | `home` | الـ Route بيبعت `started` مرة واحدة، و`EventGuard` بيرفض أي `started` تاني |

### 🏗️ Architecture
- ✅ ~~**Circular dependency** `movies` ⇄ `favorites`~~ (Phase 6): `MovieCard` في `shared/movie_ui` بـ slot اسمه `FavoriteButtonBuilder`، والـ router هو اللي بيحط فيه `FavoriteButton`. مفيش feature بتعتمد على feature.
- **`Movie` entity** مستخدمة في 4 features → مكانها `domain`.
- ✅ ~~**Domain فيها Flutter**~~ (Phase 3): `AppThemeMode` + `languageCode`، والتحويل لـ Flutter في `app_settings_flutter.dart`. الـ strings المحفوظة متغيرتش، فمش محتاجين migration (وفيه test بيثبت ده).
- ✅ ~~**`Movie.fullPosterUrl`**~~ (Phase 3 → 6): بقت `TmdbImages` / `MovieFormat` في `core_ui`. `MovieFormat.year` بيرجّع `null` والـ widget بيعرض `notAvailable` المترجمة.
- ✅ ~~**UseCases بتتخطّى**~~ (Phase 3): `GetMoviesByCategory` حل محل `GetPopularMovies` والـ `switch` اللي كان في `MovieListBloc`. ومفيش bloc بقى بيلمس الـ repository.
- ✅ ~~**منطق اختيار الـ trailer**~~ (Phase 3): `GetMovieTrailer` حل محل `GetMovieVideos` + الـ `firstWhere` المتداخلة. وبقى بيتجاهل كمان الـ videos اللي من غير key.
- ✅ ~~**`injection_container.dart`** بيعمل import لكل الـ features~~ (Phase 7): `injectable` بـ `@InjectableInit.microPackage()` في كل package، والـ app بيحدد الترتيب بس (`app/lib/core/di/injection.dart`، 53 سطر). الـ data barrel بقى بيصدّر الـ module و`NetworkConfig` بس.
- ✅ ~~Global cubits متسجلة بطرق مختلفة~~ (Phase 6): الاتنين singletons في GetIt، والـ app بيعملهم provide بـ `.value` (الـ provider مايقفلهمش). و`GenresCubit` طلع ميت (بيتحمّل ومحدش بيقراه)، فاتشال.

### 🎬 أول feature package: `movie_details` (Phase 5) — **المرجع لباقي الـ features**
```
packages/features/movie_details/lib/
├── movie_details.dart              barrel: Route · FavoriteButtonBuilder · registerMovieDetailsDependencies · l10n delegate
└── src/
    ├── movie_details_route.dart        BlocProvider + started مرة واحدة + navigation → callbacks
    ├── movie_details_navigation.dart   NavigateBack · OpenSimilarMovie
    ├── movie_details_screen.dart       BlocBuilder → Content · trailer dialog
    ├── movie_details_content.dart      UI بس (Scaffold + كل الـ states)
    ├── movie_details_contract.dart     freezed: State (initial/loading/loaded/error(Failure)) · Event
    ├── movie_details_bloc.dart         package:bloc بس + EventGuard
    ├── movie_details_dependencies.dart الـ DI بتاع الـ feature (registerFactoryParam)
    ├── widgets/                        details_app_bar · meta_row · genre_chips · cast_card · trailer_player_modal
    └── l10n/                           ARB خاص بالـ feature (en/ar)
```
**القرارات (تتطبق على باقي الـ features):**
- **feature مبتعتمدش على feature تانية.** الـ favorites دخلت كـ **slot**: `favoriteButton: (context, movie, size) => Widget`، والـ navigation layer هو اللي بيحط فيها `FavoriteHeartButton`.
- **الـ state بتشيل `Failure`** مش `String`، والـ UI بيترجمها بـ `failure.localizedMessage(context)` من `core_ui`.
- **الـ strings:** كل package ليها ARB خاص بيها، والمشترك (Try again والـ failures) في `core_ui`. والـ app بيسجّل الـ delegates.
- **الـ feature بتسجّل الـ DI بتاعها** بـ `registerXDependencies(getIt)`، وده المقابل لـ module في Koin، والـ barrel مبيصدّرش الـ bloc.
- **`EventGuard`** مستخدم فعلاً: `started` مسموح بس من `initial`، و`retried` مسموح بس من `error`. وعليه tests.
- **مفيش `EffectEmitter` في details**، لأن الشاشة دي مفيهاش effect حقيقي. اتعمل كده بقصد عشان ماناخترعش effect وهمي. أول feature يبقى فيها effect حقيقي هتستخدمه.
- **`DialogQueueState` اتأجل:** مفيش شاشة في CineVault بتعرض أكتر من sheet واحدة. هيتعمل لما شاشة تحتاجه.
- **مفيش `Navigator` في الـ features** (الـ lint بيمنعه). الـ dialogs بتتقفل بـ `close` اللي `showAppDialog` في `core_ui` بيبعتها.

**`packages/core/ui` (`core_ui`)** — من غير dependency على `domain` (الـ core مبيعتمدش على اللي فوقه):
- `AppTheme` + `AppColors` (`ThemeExtension`: brand · rating · placeholders · scrim) → `context.appColors`.
- `PosterCard` (بياخد primitives + slot اسمه `leading`)، و`RemoteImage` + `RemoteImageScope` (عشان الـ tests تشتغل من غير شبكة)، و`ErrorView`، و`CircleBackButton`، و`SectionTitle`، و`showAppDialog`، و`TmdbImages` / `MovieFormat`، و`FailureText`.

**Golden tests = الـ preview بتاع CMP:** كل state بالـ en والـ ar (RTL). لعمل regenerate:
```bash
cd packages/features/movie_details && flutter test --update-goldens
```
الـ font في الـ tests بيرسم boxes بقصد، عشان الصور تبقى ثابتة على أي جهاز. اللي الـ goldens بتحميه هو الـ layout.

**🐛 اتلقطوا:**
- **الـ genres عمرها ما ظهرت في الـ details:** TMDB بترجّع `genres: [{id, name}]` مش `genre_ids`. `MovieModel` بقى بيقرا الاتنين، وعليه regression test، واتأكدت منه على الـ API الحقيقي وعلى الـ simulator.
- **الـ golden tests من أول تشغيل لقطت overflow في `MetaRow`** (عدد الـ votes الكبير، أو لما الـ text size يكبر). اتصلح بـ `Flexible` + ellipsis.

### 🧩 باقي الـ features (Phase 6)
```
packages/
├── shared/movie_ui/        MovieCard · MovieGrid (pagination) · MovieCategory.label · FavoriteButtonBuilder
└── features/
    ├── home/               HomeBloc + EffectEmitter (refreshFailed → snackbar)
    ├── movie_list/         MovieListBloc (category param) — مفيش ARB، الـ strings من core_ui و movie_ui
    ├── search/             SearchBloc (restartable + debounce) · SearchContent stateful للـ controller بس
    ├── favorites/          FavoritesBloc (emit.forEach) + FavoriteIdsCubit و FavoriteButton على مستوى الـ app
    └── settings/           SettingsCubit على مستوى الـ app · theme reveal في الـ Screen
```
**القرارات:**
- **`shared/` طبقة جديدة** (زي Panda): widgets بتعتمد على `domain` و`core_ui`، ومستخدمة في أكتر من feature. ماتنفعش في `core_ui` لأن `core` مبيعتمدش على `domain`. الـ grid اللي فيه pagination كان متكرر 3 مرات.
- **أول `EffectEmitter` حقيقي:** `HomeEffect.refreshFailed`. الـ Route هو اللي بيسمعه وبيعرض الـ snackbar.
- **State على مستوى الـ app = Cubit من غير contract:** `FavoriteIdsCubit` و`SettingsCubit` مش view model لشاشة. بيتعملهم export من الـ feature، والـ app بيعملهم provide فوق الـ router. والـ lint بقى يعامل `*_cubit.dart` زي `*_bloc.dart` (pure Dart).
- **`FavoriteButton`** هو الملف الوحيد اللي برّه الـ anatomy: binding صغير للـ cubit (`favorite_button.dart`)، والرسم نفسه في `widgets/favorite_heart.dart` تحت الـ lint.
- **`EventGuard` في load-more بيسمح بأي loaded state بقصد:** الـ grid بيفضل يبعت scrolls لحد ما يعمل rebuild، والـ bloc بيرمي الزيادة. لو رفضناه كان الـ assert هيضرب في debug على حاجة طبيعية.
- **event داخلي في search:** `SearchEvent.requested` لازم يبقى public (الـ freezed sealed class مقفولة على الـ library)، فمكتوب عليه إنه للـ bloc بس.
- **Settings من غير `_navigation`:** الشاشة مالهاش exits، والـ Route مابيعملش provide (الـ cubit global).

**🐛 اتلقطوا واتصلحوا:** "See All" كانت hardcoded إنجليزي · الـ carousel وعنوان الـ recent searches كانوا ثابتين على الشمال في RTL · bugs 3 و4 و6 فوق · `GenresCubit` و`LoadMorePopularMovies` كود ميت.

### 💉 الـ DI بـ injectable (Phase 7)
```
app/lib/core/di/injection.dart         @InjectableInit: الترتيب بس
  before: DataPackageModule  ← بيفتح SharedPreferences والـ Hive box (@preResolve)
          DomainPackageModule ← الـ use cases (@lazySingleton)
  app:    AppModule           ← AppConfig (eager، فالـ flavor الغلط بيقع على طول) · NetworkConfig
  after:  Home · MovieList · MovieDetails · Search · Favorites · Settings
          (Settings بيعمل preResolve للـ cubit، فلازم ييجي بعد الـ storage)
```
- **كل package بتعرّف الـ module بتاعها:** `<pkg>_injection.dart` فيه `@InjectableInit.microPackage()`، والـ generator بيطلّع `<Pkg>PackageModule`. ده المقابل لـ Koin `module { }` لكل Gradle module.
- **الـ blocs:** `@injectable` (factory)، و`@factoryParam` للـ `movieId` والـ `category`. الـ Route لسه بيقول `GetIt.instance<MovieDetailsBloc>(param1: movieId)`.
- **الـ data بقت مقفولة:** الـ app مبقاش يعرف ولا impl. بيسجّل `NetworkConfig` بس، والـ data هي اللي بتعمل الـ Dio وبتفتح الـ storage.
- **`Hive.initFlutter()`** في `main` قبل `configureDependencies()`، لأنه Flutter-only والـ data package مش بتعتمد على `hive_flutter`.

### 🚦 Phase 8 — CI · app tests · الصور · tokens
- **CI (`.github/workflows/ci.yml`):** 3 jobs على كل push لـ `main` وكل PR:
  - `checks` (macOS، لأن الـ goldens اتعملت على macOS): format · analyze (`dart analyze` عشان الـ 9 قواعد) · كل الـ tests · **الـ generated code لازم يكون محدّث** (`melos run generate` + `git diff --exit-code`).
  - `build-android` (Ubuntu + JDK 17) و`build-ios` (macOS، simulator من غير signing): الـ staging flavor بيعمل build. الـ config جاي من الـ `.env.example` (الـ build مش محتاج token حقيقي).
  - ⚠ دقايق macOS بتتحسب ×10 على الـ private repos.
- **app tests (`app/test/app_test.dart`):** end-to-end على مستوى الـ widget: الـ app الحقيقي بالـ DI الحقيقي والـ routes والـ blocs والـ repositories والـ storage. اللي بيتبدل: TMDB (fake `HttpClientAdapter` جوه الـ Dio الحقيقي، فالـ interceptors و`processCall` والـ DTOs بيشتغلوا)، ومكان الـ storage (temp dir)، والصور. 5 flows: الـ token · home → details → favorite → tab المفضلة · see all · search بعد الـ debounce · التحويل للعربي.
  - عشان يبقى testable: `configureDependencies(AppConfig)`، والـ `main` هو اللي بيعمل `AppConfig.fromEnvironment()` (وبيقع على طول لو الـ flavor غلط).
  - **gotcha:** Hive بيعمل real IO، والـ fake time بتاع `testWidgets` مبيكملوش. فالـ app بيتقفل جوه الـ test نفسه (`driveStorage`: real time + pump بالتبادل)، وإلا الـ `Hive.close()` بيعلق في الـ tearDown.
- **الصور:** `RemoteImage` بقى بيعمل decode بالحجم اللي بيتعرض بيه (`memCacheWidth` من `LayoutBuilder` × الـ DPR)، ومع `sourceAspectRatio` عشان الـ cover مايعملش upscale (backdrop 16:9 في box عرضه أكبر من طوله محتاج عرض = الطول × 16/9). الـ poster على 3x بقى 420px بدل 500 (~30% ذاكرة أقل)، وعلى 2x بقى 280px (~70%). TMDB أصلاً بتبعت أحجام محدودة (w500/w1280)، فالمكسب حقيقي بس مش ×100 زي الصور الـ original.
- **Design tokens بطبقتين (من Panda):** `AppPalette` (الألوان الخام، بأسماء زي `red500` و`ink950`) ← `AppColors` و`AppTheme` (الأدوار). الـ widgets بتقرا الأدوار بس. الـ goldens متغيرتش، يعني نفس الألوان بالظبط.
- **اللي ماتنقلش من Panda، وليه:**
  - **الـ Snackbar controller:** Panda عملت `object SnackBarHost` + channel عشان Compose مفيهوش واحد مركزي (وبيضيّع رسايل لو مفيش collector). في Flutter، الـ `ScaffoldMessenger` بتاع `MaterialApp` هو أصلاً controller واحد فوق الـ Navigator وبيعمل queue للرسايل، وده اللي الـ home بيستخدمه. مفيش حاجة تتنقل.
  - **`DialogQueueState`:** لسه مفيش شاشة بتعرض أكتر من sheet، فبناؤه دلوقتي = كود من غير ما حد يستخدمه (نفس قاعدة "مفيش effect وهمي"). أول شاشة تحتاجه هتجيبه.

### 🧱 الـ Data layer (Phase 4) — زي `processCall` في Kotlin
```
DataSource  ── processCall(() => dio.get(...), decode: X.fromJson) ──▶ DTO | throws AppException
            ── storageCall('read favorites', () => box...)        ──▶ T   | throws CacheException
Repository  ── guard(() async => (await ds.x()).toEntity())        ──▶ Result<T, Failure>
```
- **`sealed AppException`:** `NoInternet` · `Server(statusCode)` · `Parsing` · `Cache` · `Unknown`. التحويل لـ `Failure` بيحصل بـ `switch` بيغطي كل الأنواع (`AppExceptionToFailure`).
- **`processCall`:**
  - بيحوّل `DioException` لـ `AppException` في مكان الـ call نفسه.
  - بيمسك الـ `TypeError` حوالين خطوة الـ `decode` بس (لما الـ JSON ييجي بشكل غير المتوقع)، عشان مايخبيش bugs تانية.
  - بيحتفظ بالـ stack trace الأصلي بـ `Error.throwWithStackTrace`. ده المقابل لـ `inline` في Kotlin.
- **`guard`:** أي حاجة مش `AppException` بتتعتبر bug، فبيعمل لها log وبيرجّع `UnknownFailure`، عشان item واحد بايظ مايوقعش الشاشة.
- **🐛 bug اتصلح:** `watchFavorites` و`watchFavoriteIds` كانوا مكتوبين `async*`. لو عملت cancel لـ stream زي ده وهو مستني جوه `await for`، الـ `cancel()` مبيخلصش غير لما يحصل تغيير جديد في الـ box، وده كان هيعلّق `close()` في الـ blocs. اتعادوا بـ `Stream.multi`، وعليهم regression test.

### ⚠️ Errors
- `Failure` معمولة `abstract` → **`sealed`** عشان الـ `switch` exhaustive.
- ✅ ~~رسايل الـ Failure عربي في الكود~~ (Phase 6): كل الـ states بتشيل `Failure`، والـ UI بيعرض `failure.localizedMessage(context)`. الـ defaults في `core_result` بقت إنجليزي وللـ logs بس.
- ✅ ~~try/catch متكرر~~ (Phase 4): `processCall` في الـ remote data sources، و`storageCall` في الـ local، و`guard` في الـ repositories، والتلاتة بيستخدموا `sealed AppException` واحدة. الـ repositories نزلت من 353 لـ 169 سطر، ومن غير ولا `try/catch`.
- ✅ ~~`NetworkInfo.isConnected`~~ (Phase 4): اتشال هو و`connectivity_plus`. انقطاع النت بقى بيتعرف من الـ `DioException` نفسها، وبيتحول لـ `NoInternetException`.

### 🧹 Readability
- ✅ ~~`Color(0xFFE50914)` متكرر 18 مرة~~ (Phase 5–6): `context.appColors.brand`. فاضل بس جوه `core_ui/theme`.
- ~~76 ملف فيهم تعليقات عربي.~~ ✅ اتشالت (2026-10-02): الكومنتات التعليمية اتمسحت، واللي بيشرح "ليه" اتحوّل لسطر إنجليزي.
- ✅ ~~`_buildX()` methods~~ (Phase 6): اتحولت لـ private widgets أو لـ `widgets/`.
- ✅ ~~Modifiers مش موحدة~~ (Phase 6): كل الـ contracts بقت `freezed`.
- `List<Movie>` في الـ states → `IList` (`fast_immutable_collections`).
- ✅ ~~`copyWith` يدوي~~ (Phase 6): `freezed`.

---

## 6. خطة التنفيذ

| Phase | الشغل | Done when |
|---|---|---|
| **0-A** | إصلاح الـ test القديم · bugs 1، 2، 5 · flavors (staging/production) + config per flavor | tests خضرا، الـ flavors بتعمل build على Android و iOS |
| **0-B** | رفع الـ SDK لـ `^3.13` · `very_good_analysis` · `dart format` · `dart fix` + إصلاح الباقي بإيدينا | ✅ `flutter analyze`: No issues |
| **1** | melos workspace · `core/result` (sealed Failure) · `core/base` (EffectEmitter, EventGuard, BlocEffectListener) + tests | ✅ 18 test في الـ packages · `melos run analyze/test` خضرا |
| **2** | `lints` package — أول 4 قواعد (content pure · bloc pure · provider only in route · no navigation in features) | ✅ 22 test للـ plugin · الـ 4 قواعد اتجرّبوا end-to-end بـ `dart analyze` على ملف مخالف · الـ workspace نضيف |
| **3** | `domain` pure Dart · نقل الـ entities · `GetMoviesByCategory` · `GetMovieTrailer` + tests | ✅ `packages/domain` (17 test) · import أي package مش متعرّفة كـ dependency = **error** |
| **4** | `data` · `processCall` / `storageCall` / `guard` · `sealed AppException` · repo tests | ✅ `packages/data` (30 test) · `ErrorInterceptor` و`NetworkInfo` اتشالوا · الـ DTOs و`AppException` داخلية في الـ package |
| **5** | **`movie_details`** كنموذج كامل بالـ 6 ملفات + bloc test + golden | ✅ `packages/features/movie_details` (12 test: bloc + 6 goldens en/ar) · `packages/core/ui` (5 test) · الـ lint plugin شغال على الكود ومفيش ولا warning |
| **6** | `home` · `movie_list` · `search` · `favorites` · `settings` على نفس النموذج | ✅ 6 feature packages + `shared/movie_ui` · `lib/features` اتشال · 164 test (bloc + 32 golden en/ar) · الـ lint plugin شغال على كل الـ features ومفيش ولا warning |
| **7** | `navigation` typed routes · `injectable` · `app` composition · باقي قواعد الـ lint | ✅ `app_router.dart` 41 سطر · 8 injectable modules · التطبيق في `app/` (iOS و Android بيعملوا build) · 9 قواعد lint (36 test) · الـ generated code بقى committed |
| **8** | CI · app end-to-end tests · decoding images at display size · design tokens (Panda) | ✅ GitHub Actions (checks + Android/iOS builds) نجحت كـ simulation على copy نضيفة · 191 test · الـ 32 golden زي ما هما |
| **9** | الرجوع للـ structure الشائع في السوق (5 خطوات، شوف تحت) | ✅ خطوة 1 (routing) · ✅ خطوة 2 (نقل الـ features) · ⏳ 3–5 |

---

### Phase 9 — الرجوع للـ structure الشائع (2026-10-03)
**ليه:** بحث (المصادر في الـ PR): الـ layering والـ freezed والـ Result والـ DI وgo_router وBloc كلهم متوافقين مع [دليل Flutter الرسمي](https://docs.flutter.dev/app-architecture/recommendations). بس الـ package لكل شاشة والـ use cases الإجبارية وinjectable وفصل الشاشة لـ 6 ملفات **أتقل من اللي معظم المشاريع بتعمله** لتطبيق 6 شاشات. والـ packages في Dart بتدّي حدود بس، مش سرعة build زي Gradle. **القرار:** نمشي على الشائع (الدليل الرسمي + Bloc/VGV): package واحدة، الـ features فولدرات، من غير use cases.

**الشكل المستهدف:**
```
lib/
├── main.dart
├── app/            app.dart · di.dart (get_it صريح) · config/
├── core/           constants/ (endpoints · storage keys · durations) · result/ · network/ · theme/ · widgets/
├── routing/        app_routes.dart (كل الـ paths والـ params constants) · app_router.dart · app_shell.dart
├── domain/models/  Movie · CastMember · Genre · Video · AppSettings
├── data/           services/ · models/ (DTOs) · repositories/ (abstract + impl)
├── features/<f>/   bloc/ (bloc + event + state، part files، freezed) · view/ (page + view + widgets/)
└── l10n/           app_en.arb · app_ar.arb
test/               نفس شكل lib/
```

**الخطوات (top-down: اللي فوق يتنقل الأول وهو لسه بيستخدم الـ packages اللي تحته). كل خطوة commit (أو كام commit) على `main` مباشرة، والـ CI بيتأكد منها:**
| PR | Branch | الشغل | النوع |
|---|---|---|---|
| 1 | `refactor/routing-in-app` | `packages/navigation` → `app/lib/routing/`. go_router عادي + `AppRoutes` / `RouteParams` بدل go_router_builder | تغيير حقيقي (صغير) |
| 2 | `refactor/move-features` | الـ 6 features + `shared/movie_ui` → `app/lib/features/` و`core/widgets/movie_ui/` **زي ما هي**: نقل ملفات وimports بس. استثناءين اتفرضوا: الـ DI micro packages بتاعة الـ features اتشالت (في package واحدة الـ root config بيلاقي الـ classes لوحده)، و`flutter_test_config.dart` واحد. الـ ARB بتاعة كل feature لسه في مكانها لحد خطوة 4 (الـ generated بتاعها committed، فمش محتاجة regenerate) | ميكانيكي بس |
| 3 | `refactor/feature-anatomy` | كل feature → `bloc/` + `view/` (page + view). `EffectEmitter` → `BlocListener`. `EventGuard` يتشال. injectable يخرج من الـ features | تغيير حقيقي |
| 4 | `refactor/flatten-layers` | `domain` و`data` و`core/*` → `lib/`. **الـ use cases كلها تتشال**. injectable يتشال خالص → `di.dart`. الـ ARB تتجمع. `core/constants/` | تغيير حقيقي (الأكبر) |
| 5 | `chore/single-package` | الـ app يرجع للـ root. melos والـ workspace والـ lint plugin و`core_testing` يتشالوا. الـ CI يبقى `flutter analyze` + `flutter test` | ميكانيكي في الأغلب |

**قواعد كل خطوة:** الـ CI أخضر · سلوك الـ app ميتغيرش · **الـ goldens زي ما هي** (أي pixel يتغير يبان) · الـ e2e tests بتعدي · الميكانيكي لوحده عشان مايدفنش الحقيقي.

**قرارات (بتاعتك):** الـ use cases كلها تتشال · `EventGuard` يتشال · مفيش strings مكتوبة بإيد (routes · params · endpoints · keys · durations كلها constants) · الخطة هنا في الـ notes.

## 7. القرارات

| القرار | الحالة |
|---|---|
| `freezed` للـ states والـ contracts | ✅ متفق (2026-10-02) |
| `go_router_builder` للـ typed routes | ✅ متفق |
| melos من Phase 1 | ✅ melos 8 فوق Dart pub workspaces (Phase 1) |
| التطبيق في root الـ workspace مؤقتاً | ✅ اتنقل لـ `app/` في Phase 7 (معاه `android/` و`ios/` و`config/`). الـ root بقى workspace + melos بس |
| DI: `injectable` ولا `registerXDependencies` اليدوي | ✅ `injectable` (قرارك، Phase 7): micro package لكل package، والترتيب في الـ app. الـ `domain` بقى بيعتمد على `injectable` (annotations بس، pure Dart) |
| الـ generated code يتعمل له commit | ✅ (قرارك، Phase 7): freezed · injectable · go_router_builder · l10n. الـ clone بيعمل build على طول، و`melos run generate` بيعيد توليده |
| `AuthFailure` · `ValidationFailure` | ❌ اتشالوا (مش مستخدمين؛ مع `sealed` كل type زيادة = case إجباري). يرجعوا لما نحتاجهم |
| رسايل الـ Failure العربي في الكود | ✅ Phase 6: الـ states بتشيل `Failure` والـ UI بيترجمها من `core_ui` |
| Flavors: `staging` · `production` | ✅ متعملة في Phase 0 |
| analyzer plugin ولا `custom_lint` | ✅ analyzer plugin (Phase 2). شغال مع `dart analyze` والـ IDE، **مش** مع `flutter analyze` |
| `EventGuard` يفضل ولا يتشال | ✅ يفضل، ويتجرّب فعلياً في `movie_details` (Phase 5) |
| إعادة تسمية الـ app id (`cine_vault_temp` → ?) | ⏳ مفتوح |

## 8. Workflow
- **مفيش commit من غير مراجعة.** كل دفعة بتتسلّم كـ diff، والـ commit بيحصل بعد الموافقة.
- التغييرات الميكانيكية (format · `dart fix`) دايماً في دفعة لوحدها عشان متدفنش التغييرات الحقيقية.
