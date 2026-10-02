# 📦 Result&lt;T&gt; vs. Either&lt;L, R&gt;

لما تقرا كود الـ domain/data في cine_vault، هتلاقي كل method بترجع `Future<Result<T>>`. قبل كده كانت `Future<Either<Failure, T>>` (من مكتبة `dartz`). الدوكيومنت ده بيشرح:

1. ليه كان فيه `Either` أصلاً؟
2. ليه انتقلنا لـ sealed `Result<T>`؟
3. تفاصيل الـ migration والـ tradeoffs.
4. جدول مقارنة كامل.

---

## 🤔 Either — الـ context التاريخي

`Either<L, R>` جاية من **functional programming** (Haskell, Scala). الفكرة:

> "Function ممكن ترجع قيمة من نوعين (either A or B). اللي بره `Left` اصطلاحاً بيمثل الخطأ، والـ `Right` بيمثل النجاح (يمين = صح = correct)."

في Dart، `dartz` package بيوفر `Either<L, R>` كـ port من Scala's cats. الاستخدام:

```dart
// Repository method
Future<Either<Failure, List<Movie>>> getPopularMovies() async {
  if (!await networkInfo.isConnected) {
    return Left(NetworkFailure());          // error path
  }
  try {
    final movies = await fetch();
    return Right(movies);                   // happy path
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));  // error path
  }
}

// Consumer (in Bloc)
result.fold(
  (failure) => emit(Error(failure.message)),
  (movies) => emit(Loaded(movies)),
);
```

### الإيجابيات وقت ما اعتمدنا Either

1. **Failure جزء من الـ type signature** — الـ compiler بيخلّيك تتعامل مع الحالتين.
2. **Pattern منتشر** — الـ Flutter Clean Architecture community تبنى `dartz` في 2019-2022.
3. **`.fold()` ergonomic** — two-callback API واحد بدل if/else.

### السلبيات اللي ظهرت مع الوقت

1. **اسامي confusing** — لماذا `Left` = error و `Right` = success؟ عشوائي لمبرمج جديد.
2. **مش part من الـ language** — `dartz` مكتبة خارجية، وبتـ bundle Scala-isms (`Option`, `Task`, `Reader`, إلخ) اللي ما محتاجهومش.
3. **No exhaustive switch** — الـ Dart analyzer مش قادر يثبت إنك غطيت الحالتين لو استخدمت casting أو extension methods.
4. **Dart 3 offered a better primitive** — `sealed class` بتحل نفس المشكلة بشكل أنضف.

---

## ✨ Dart 3 سألت: "ليه مش sealed classes؟"

في 2023، Dart 3 أضافت:
- **Sealed classes** — closed type hierarchies (compiler بيعرف كل الـ subtypes).
- **Pattern matching** — `switch` expressions exhaustive على sealed types.
- **Records** — تجميع قيم بدون class كامل.

كلهم مع بعض بيدوّا نفس قوة `Either` — وبشكل native.

---

## 🆕 الـ Result&lt;T&gt; اللي في المشروع دلوقتي

```dart
// lib/core/result/result.dart
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) ok,
    required R Function(Failure failure) err,
  }) => switch (this) {
        Ok<T>(:final value) => ok(value),
        Err<T>(:final failure) => err(failure),
      };

  T getOrElse(T Function() fallback) => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => fallback(),
      };

  // ... valueOrNull, failureOrNull, isOk, isErr, map()
}

final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
```

### Consumer code بقى

```dart
// In bloc
switch (result) {
  case Err(:final failure):
    emit(Error(failure.message));
  case Ok(:final value):
    emit(Loaded(value));
}

// Or using .when() for one-liners
result.when(
  ok: (movies) => emit(Loaded(movies)),
  err: (failure) => emit(Error(failure.message)),
);
```

### Repository bodies

```dart
Future<Result<List<Movie>>> getPopularMovies({required int page}) async {
  if (!await networkInfo.isConnected) return const Err(NetworkFailure());
  try {
    final response = await remote.getPopularMovies(page: page);
    return Ok(response.results.map((m) => m.toEntity()).toList());
  } on ServerException catch (e) {
    return Err(ServerFailure(message: e.message));
  }
}
```

---

## 🔄 الـ migration mapping

| قبل (Either) | بعد (Result) |
|---|---|
| `Either<Failure, T>` | `Result<T>` |
| `Right(value)` | `Ok(value)` |
| `Left(failure)` | `Err(failure)` |
| `result.fold(onLeft, onRight)` | `switch (result)` أو `result.when(err:, ok:)` |
| `result.getOrElse(() => default)` | `result.getOrElse(() => default)` *(نفسها)* |
| `result.isLeft()` | `result.isErr` (getter) |
| `result.isRight()` | `result.isOk` (getter) |
| `result.swap()` | مفيش — مش محتاجينه بعد sealed switch |
| `import 'package:dartz/dartz.dart';` | `import '...core/result/result.dart';` |

### Files touched في الـ migration

- `lib/core/result/result.dart` (جديد)
- `lib/core/usecase/usecase.dart` — base class signature
- **5 domain repositories** — `movies`, `search`, `favorites`, `settings`
- **14 domain use cases** — كل `UseCase<T, Params>`
- **4 data repositories** — كل `*_repository_impl.dart`
- **5 presentation blocs/cubits** — كل `.fold(...)` و `.isLeft()` تم تحويلها
- **1 test file** — `movies_bloc_test.dart`
- `pubspec.yaml` — `dartz` removed

---

## ⚖️ Side-by-side feature comparison

| Feature | `Either<L, R>` (dartz) | `Result<T>` (ours) |
|---|---|---|
| **Type safety of failure** | ✅ | ✅ |
| **Exhaustive pattern matching** | ⚠️ only with extension methods | ✅ native `switch` |
| **Part of language** | ❌ external lib | ✅ sealed class + pattern matching |
| **Naming clarity** | ❌ Left/Right arbitrary | ✅ Ok/Err explicit |
| **Compile-time exhaustiveness** | ❌ | ✅ |
| **Ergonomic `.fold()` / `.when()`** | ✅ `.fold()` | ✅ `.when()` (same shape) |
| **Can be const** | ❌ | ✅ `const Ok(...)` / `const Err(...)` |
| **Bundle size impact** | adds dartz (~50KB source) | zero — pure Dart |
| **Learning curve for newcomers** | high (FP background needed) | low (switch + class = Dart basics) |
| **Map / FlatMap / bind** | ✅ full functor suite | ✅ `map()` provided, more can be added if needed |
| **Handles success/failure symmetrically** | ✅ swap works both ways | ❌ one-directional (we consciously chose this — errors ≠ values) |

### لو كنت شاغل على Kotlin — hint

Kotlin 1.5+ قدّم `kotlin.Result<T>`. التصميم بتاعنا مطابق تقريباً:

```kotlin
// Kotlin's built-in
public class Result<out T> {
  val value: Any? // internal
  fun getOrNull(): T?
  fun exceptionOrNull(): Throwable?
}

// Dart equivalent (ours)
sealed class Result<T> {
  final T? valueOrNull;
  final Failure? failureOrNull;
}
```

الفرق الوحيد: Kotlin's `Result` بتحمل `Throwable`، بينما بتاعنا بتحمل `Failure` (domain-specific type) — وده الصح في Clean Architecture لأن الـ domain مش محتاج يعرف عن exceptions.

---

## 🧠 متى تستخدم كل واحد؟

### استخدم `Result<T>` (اللي عندنا) لما:

- عندك error type محدد في الـ domain (`Failure`)
- عايز pattern matching بـ Dart 3
- عايز تقلل dependencies
- الـ team بيشتغل بـ modern Dart

### استخدم `Either<L, R>` (dartz) لما:

- شغال على codebase موجود بـ dartz بالفعل
- محتاج multiple error types (L) مش bundle واحد
- محتاج الـ FP suite كامل (Option, Task, Reader, IO, إلخ) — rare في Flutter apps
- الـ team له خلفية Scala/Haskell

---

## 📚 مراجع للقراءة

- [Dart 3 sealed classes](https://dart.dev/language/class-modifiers#sealed) — الـ language feature الأساسي
- [Dart pattern matching](https://dart.dev/language/patterns) — الـ switch expressions exhaustiveness
- [Kotlin Result](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-result/) — الـ equivalent بتاعنا في Kotlin stdlib
- [Rust Result](https://doc.rust-lang.org/std/result/) — الـ original inspiration (Rust's ADT-based error handling)

---

**آخر تحديث:** بعد المigration من dartz → sealed Result. النية: نستخدم modern Dart patterns بدل الـ FP port القديم.
