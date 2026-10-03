# CineVault

[![CI](https://github.com/Isma3ilMohamed/CineVault/actions/workflows/ci.yml/badge.svg)](https://github.com/Isma3ilMohamed/CineVault/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.13-0175C2?logo=dart)

A movie app for Android and iOS built on [TMDB](https://www.themoviedb.org/), in English and
Arabic (RTL), light and dark.

The app is small on purpose; the point is the structure around it: a modular Flutter workspace
where package boundaries are enforced by the compiler, every screen follows the same file
anatomy (enforced by a custom lint plugin), and the whole thing is covered by unit, golden and
end-to-end tests that run on every push.

<p align="center">
  <img src="docs/screenshots/home.png" width="16%" alt="Home" />
  <img src="docs/screenshots/details.png" width="16%" alt="Movie details" />
  <img src="docs/screenshots/search.png" width="16%" alt="Search" />
  <img src="docs/screenshots/favorites.png" width="16%" alt="Favorites" />
  <img src="docs/screenshots/settings.png" width="16%" alt="Settings" />
  <img src="docs/screenshots/home_ar_light.png" width="16%" alt="Home in Arabic, light theme" />
</p>

## Features

- **Home**: featured carousel and five categories (trending, popular, top rated, now playing,
  upcoming), pull to refresh.
- **See all**: the full list of a category with infinite scroll.
- **Details**: backdrop, rating, genres, cast, similar movies, and the trailer in-app.
- **Search**: debounced, cancels stale requests, remembers recent searches.
- **Favorites**: stored on the device; the heart stays in sync on every screen.
- **Settings**: light/dark theme with a circular reveal animation, English/Arabic.

## Architecture

```
cine_vault/
├── app/                    main, DI order, MaterialApp, routing (go_router), android/, ios/
└── packages/
    ├── core/
    │   ├── result/         Result, sealed Failure                    (pure Dart)
    │   ├── base/           EffectEmitter, EventGuard, BlocEffectListener
    │   └── ui/             design tokens, theme, shared widgets      (no domain types)
    ├── domain/             entities, repository interfaces, use cases (pure Dart)
    ├── data/               repository implementations, DTOs, Dio, local storage
    ├── shared/movie_ui/    movie card, paginated grid, category labels
    ├── features/           home, movie_list, movie_details, search, favorites, settings
    └── lints/              cine_vault_lints, a custom analyzer plugin
```

**Dependencies point inward.** `domain` knows nothing about Flutter or the network. Features
depend on `domain` and `core`, never on `data` and never on each other; the app's router is the
only place where features meet, through callbacks. These rules are not conventions: each
layer is a package, and importing something a package does not declare is an analyzer error.

**Every screen has the same files**, so you know what a file does from its name:

| File | Responsibility |
|---|---|
| `*_route.dart` | Entry and exit: gets the bloc from DI, starts it once, maps navigation to callbacks |
| `*_navigation.dart` | The screen's exits (sealed) |
| `*_screen.dart` | Binds bloc state to the content |
| `*_content.dart` | Pure UI, golden-tested |
| `*_contract.dart` | State, Event and Effect (freezed, sealed) |
| `*_bloc.dart` | The logic, in pure Dart |

### Highlights

- **Errors as values.** Repositories return a sealed `Result`; the UI shows a localized message
  per `Failure` type. Network and storage calls go through one wrapper each (`processCall`,
  `storageCall`), so there is no `try/catch` in the repositories.
- **No hand-written paths.** Every location and parameter name is a constant in `AppRoutes` /
  `RouteParams`; invalid deep links land on an error screen. Hero tags travel as query
  parameters, so every location is a plain URL.
- **DI per package.** Each package registers its own classes as an `injectable` micro package;
  the app only decides the order.
- **Images decoded at display size** (`memCacheWidth` from the layout and device pixel ratio),
  aware of the source aspect ratio so cover-fit images never upscale.
- **Lint rules for the architecture** (`packages/lints`): content and widgets stay pure, blocs
  stay Flutter-free, providers only in routes, no navigation inside features, no hardcoded
  colors, no build-helper methods, files under 250 lines, English comments.

The full rationale, decisions and trade-offs are in
[ARCHITECTURE_NOTES.md](ARCHITECTURE_NOTES.md) (written in Arabic).

## Tech stack

| | |
|---|---|
| State | `flutter_bloc`, `freezed` |
| Navigation | `go_router` |
| DI | `get_it`, `injectable` |
| Networking | `dio` |
| Storage | `hive`, `shared_preferences` |
| Images | `cached_network_image` |
| Workspace | Dart pub workspaces, `melos` |
| Lint | `very_good_analysis`, custom analyzer plugin |
| Tests | `flutter_test`, `bloc_test`, `mocktail`, golden files |

## Getting started

**Requirements:** Flutter 3.47 (Dart 3.13), Xcode for iOS, JDK 17 for Android.

1. **Resolve the workspace** (from the repository root):
   ```bash
   flutter pub get
   ```
2. **Add your TMDB token.** Create an account on [TMDB](https://www.themoviedb.org/signup), then
   copy the *API Read Access Token* from Settings → API. Put it in both config files:
   ```bash
   cp app/config/staging.env.example app/config/staging.env
   cp app/config/production.env.example app/config/production.env
   ```
   These files are git-ignored. The app refuses to start if the flavor and the config don't match.
3. **Run** (from `app/`, a flavor is required):
   ```bash
   cd app
   flutter run --flavor staging --dart-define-from-file=config/staging.env
   ```

| Flavor | Android app id | iOS bundle id | Network logs |
|---|---|---|---|
| staging | `com.ismail.cine_vault_temp.staging` | `com.ismail.cineVaultTemp.staging` | ✅ |
| production | `com.ismail.cine_vault_temp` | `com.ismail.cineVaultTemp` | ❌ |

Android Studio users can pick the **staging** / **production** run configurations in `.run/`.

## Development

The workspace is driven by [melos](https://melos.invertase.dev):

```bash
dart run melos run format    # fails if anything is unformatted
dart run melos run analyze   # dart analyze --fatal-infos, with the custom lint rules
dart run melos run test      # every test in the workspace
dart run melos run generate  # freezed, injectable (+ format)
```

- The lint rules show up in the IDE and in `dart analyze`, **not** in `flutter analyze`, and only
  when analyzing from the repository root.
- Generated code is committed, so a fresh clone builds without running `build_runner`. After
  changing a contract, an annotated class or a route, run `generate`; after changing an `.arb`
  file, run `flutter gen-l10n` in that package.
- New package: create it under `packages/` with `resolution: workspace`, list it under
  `workspace:` in the root `pubspec.yaml`, and if it registers anything in DI, add its module to
  `app/lib/core/di/injection.dart`.

## Testing

- **Bloc tests** for every bloc, including the race conditions (a slow old search never
  overwrites newer results) and the event guards.
- **Golden tests** for every screen state, in English and Arabic. Regenerate after an intended UI
  change with `flutter test --update-goldens` in the package.
- **End-to-end tests** in `app/test/`: the real app with the real DI graph, routes and storage,
  against a fake TMDB HTTP adapter, so the main flows run without a device or network.
- **Lint plugin tests** in `packages/lints`.

## CI/CD

| Workflow | When | What |
|---|---|---|
| [CI](.github/workflows/ci.yml) | every push to `main` and every pull request | format, analyze, all tests, generated code up to date; builds the staging flavor for Android and iOS |
| [Release](.github/workflows/release.yml) | a pushed `v*` tag | builds the production APK and publishes it as a GitHub Release |

The release workflow needs the `TMDB_ACCESS_TOKEN` repository secret. Builds are signed with the
debug key until a release keystore is configured.

## Credits

Movie data and images from [TMDB](https://www.themoviedb.org/). This product uses the TMDB API
but is not endorsed or certified by TMDB.
