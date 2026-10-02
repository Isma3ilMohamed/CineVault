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

```
lib/
├── core/                       # Shared across features
│   ├── constants/              # App & API constants
│   ├── di/                     # Dependency injection (GetIt)
│   ├── error/                  # Failures & Exceptions
│   ├── network/                # Dio, interceptors, connectivity
│   ├── router/                 # go_router setup
│   ├── theme/                  # Material 3 dark theme
│   ├── usecase/                # Base UseCase class
│   └── widgets/                # Shared UI components
│
├── features/
│   ├── movies/                 # ✅ Implemented
│   │   ├── data/
│   │   │   ├── datasources/    # Remote (Dio) & Local (Isar)
│   │   │   ├── models/         # DTOs with JSON mapping
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/       # Pure business models
│   │   │   ├── repositories/   # Abstract contracts
│   │   │   └── usecases/       # One action per class
│   │   └── presentation/
│   │       ├── bloc/           # MoviesBloc + Events + States
│   │       ├── pages/          # Full screens
│   │       └── widgets/        # Feature-specific widgets
│   │
│   ├── search/                 # 🔜 To be implemented
│   ├── favorites/              # 🔜 To be implemented
│   └── auth/                   # 🔜 To be implemented
│
├── app.dart                    # Root MaterialApp
└── main.dart                   # Entry point
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

### 4. Environment Variables

```bash
# انسخ الـ template
cp .env.example .env

# بعد كدا افتح .env وحط الـ keys:
```

```env
TMDB_API_KEY=<your_key>
TMDB_ACCESS_TOKEN=<your_token>
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p
```

### 5. Run

```bash
# Android
flutter run

# iOS
flutter run -d "iPhone 15 Pro"

# Specific device
flutter devices
flutter run -d <device_id>
```

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
