import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;

/// ببساطة كدا: ده entry point التطبيق
/// main() بتتنادى أول حاجة لما التطبيق يفتح
///
/// الترتيب مهم:
///   1. ensureInitialized() - Flutter لازم يتهيأ قبل أي async
///   2. dotenv.load() - نحمل الـ environment variables
///   3. initDependencies() - نسجل الـ DI
///   4. runApp() - نشغل التطبيق
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (API keys)
  await dotenv.load(fileName: '.env');

  // Initialize dependency injection
  await di.initDependencies();

  // Optional: Bloc observer للـ debugging
  Bloc.observer = AppBlocObserver();

  runApp(const CineVaultApp());
}

/// بيسجل كل الـ events و states في الـ Bloc
/// مفيد جداً للـ debugging
/// Kotlin equivalent: aspect-oriented logging
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('📨 Event in ${bloc.runtimeType}: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('🔄 ${bloc.runtimeType} state changed');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('❌ Error in ${bloc.runtimeType}: $error');
  }
}
