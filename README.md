# 🎬 CineVault

تطبيق أفلام مبني بـ **Flutter + Clean Architecture + Bloc** — مشروع تعليمي احترافي.

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (Pages, Widgets, Bloc/Cubit, States)   │
└───────────────┬─────────────────────────┘
                │ depends on
                ▼
┌─────────────────────────────────────────┐
│            Domain Layer                 │
│    (Entities, UseCases, Repositories)   │
│         ← Pure Dart, no Flutter →       │
└───────────────▲─────────────────────────┘
                │ implements
                │
┌───────────────┴─────────────────────────┐
│             Data Layer                  │
│  (Models, DataSources, Repository Impl) │
└─────────────────────────────────────────┘
```

### الفكرة الأساسية
**Dependencies point inward.** الـ Domain في النص، ما يعرفش حاجة عن Flutter أو Dio أو Firebase. الـ Data بتقدمله implementations. الـ Presentation بتستخدمه.

## 📁 Folder Structure

The project is mid-migration to a melos workspace (target layout and plan:
[ARCHITECTURE_NOTES.md](ARCHITECTURE_NOTES.md)).

```
cine_vault/                     # Workspace root, and (for now) the app itself
├── lib/                        # App: features not yet moved into packages
├── test/                       # App tests
├── packages/
│   ├── core/
│   │   ├── result/             # core_result: Result, sealed Failure (pure Dart)
│   │   └── base/               # core_base: EffectEmitter, EventGuard (pure Dart)
│   │                           #            + BlocEffectListener (widgets.dart)
│   └── lints/                  # cine_vault_lints: analyzer plugin (not a workspace member)
├── config/                     # Per-flavor build config (*.env git-ignored)
└── pubspec.yaml                # App deps + `workspace:` list + melos scripts
```

## 🚀 Getting Started

### 1. Prerequisites

- Flutter SDK ≥ 3.5.0
- Dart ≥ 3.5.0
- Android Studio / VS Code with Flutter plugin
- iOS: Xcode 15+ (للـ iOS build)

### 2. Clone & Setup

```bash
# بعد ما تاخد المشروع
flutter pub get
```

### 3. TMDB API Key

1. روح لـ https://www.themoviedb.org/signup
2. بعد ما تعمل حساب: **Settings → API → Create**
3. اختار **Developer** → املى الفورم
4. هتاخد **API Key (v3)** و **API Read Access Token (v4)**

### 4. Flavors & Config

Two flavors: **staging** and **production**. Both hit TMDB; staging installs side by side
(`.staging` app id suffix, "CineVault Stg" name) and has network logging on.

Each flavor reads its config from `config/<flavor>.env` (git-ignored) at build time:

```bash
cp config/staging.env.example config/staging.env
cp config/production.env.example config/production.env
# then put your TMDB v4 read access token in both files
```

The app refuses to start if `--flavor` and the config file don't match.

| | staging | production |
|---|---|---|
| Android app id | `com.ismail.cine_vault_temp.staging` | `com.ismail.cine_vault_temp` |
| iOS bundle id | `com.ismail.cineVaultTemp.staging` | `com.ismail.cineVaultTemp` |
| Network logs | ✅ | ❌ |

Flavor wiring lives in `android/app/build.gradle.kts`, `ios/Flutter/Flavors/` and
`lib/core/config/app_config.dart` — keep them in sync.

### 5. Run

A flavor is required (there is no default build any more).

```bash
flutter run --flavor staging --dart-define-from-file=config/staging.env
flutter run --flavor production --dart-define-from-file=config/production.env
```

Android Studio: pick the **staging** / **production** run configuration (from `.run/`).

```bash
# Release builds
flutter build apk --flavor production --dart-define-from-file=config/production.env
flutter build ipa --flavor production --dart-define-from-file=config/production.env
```

## 🛠️ Development

The workspace is driven by [melos](https://melos.invertase.dev) (a dev dependency):

```bash
dart run melos run format    # fails if anything is unformatted
dart run melos run analyze   # dart analyze --fatal-infos, whole workspace (+ feature anatomy rules)
dart run melos run test      # every package's tests + the app's tests + the lint plugin's tests
```

**Feature anatomy rules.** `packages/lints` is an analyzer plugin (enabled under `plugins:` in
`analysis_options.yaml`) that enforces the file split described in `ARCHITECTURE_NOTES.md` for
code under `packages/features/`. Its warnings show up in the IDE and in `dart analyze`, **not** in
`flutter analyze`, and only when analysing from the repo root. Restart the analysis server after
changing the plugin.

Adding a package: create it under `packages/`, give its pubspec
`resolution: workspace`, and list it under `workspace:` in the root `pubspec.yaml`.

## 🧩 الـ Stack

| الجانب | الـ Tool | ليه |
|--------|---------|-----|
| State Management | `flutter_bloc` | الأشهر، testable، MVI-friendly |
| Networking | `dio` + interceptors | أقوى HTTP client |
| DI | `get_it` | simple service locator |
| Functional | `dartz` (Either) | error handling بطريقة Kotlin-esque |
| Navigation | `go_router` | declarative + deep linking |
| Local DB | `isar` | أسرع NoSQL DB لـ Flutter |
| Images | `cached_network_image` | caching جاهز |
| Equatable | `equatable` | easy value equality |

## 🎯 Clean Architecture Rules

1. **Domain ماتعرفش عن Data أو Presentation**
   - لو حاجة في Domain بتستخدم `package:flutter` → غلط
   - لو Entity بتستخدم `fromJson` → غلط (ده DTO)

2. **Data Layer يـ implements Domain contracts**
   - `MovieRepositoryImpl implements MovieRepository`
   - بيترجم Exceptions لـ Failures

3. **Presentation ياخد من Domain بس**
   - Bloc بيستخدم UseCases
   - UseCases بترجع `Either<Failure, T>`
   - Bloc بيترجمها لـ State

4. **Single Responsibility**
   - كل UseCase = action واحد
   - `GetPopularMovies`, مش `MoviesManager`

## 🧪 Testing Strategy

```
test/
├── features/
│   └── movies/
│       ├── data/
│       │   ├── repositories/   # Mock data sources
│       │   └── datasources/    # Mock Dio responses
│       ├── domain/
│       │   └── usecases/       # Mock repository
│       └── presentation/
│           └── bloc/           # bloc_test package
```

مثال:
```dart
blocTest<MoviesBloc, MoviesState>(
  'emits [Loading, Loaded] when LoadHomeMovies succeeds',
  build: () => MoviesBloc(getPopularMovies: mockUseCase, ...),
  act: (bloc) => bloc.add(const LoadHomeMovies()),
  expect: () => [
    const MoviesLoading(),
    isA<MoviesLoaded>(),
  ],
);
```

## 📈 Roadmap

- [x] Phase 1: Project setup + Clean Architecture scaffold
- [x] Phase 2: Movies feature (data + domain + presentation)
- [ ] Phase 3: Movie Details screen + Hero animation
- [ ] Phase 4: Search feature (with debouncing)
- [ ] Phase 5: Favorites (local DB with Isar)
- [ ] Phase 6: Firebase Auth + Firestore sync
- [ ] Phase 7: Unit + Widget + Bloc tests
- [ ] Phase 8: CI/CD with GitHub Actions

## 📚 Learning Resources

- [Bloc Library Docs](https://bloclibrary.dev/)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Examples](https://resocoder.com/flutter-clean-architecture-tdd/)

## 🛠️ Author

**Ismail** — Senior Android Engineer learning Flutter the right way 🚀
