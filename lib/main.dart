import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fails fast if --flavor and the config file don't match
  final config = AppConfig.fromEnvironment();

  await di.initDependencies(config);

  Bloc.observer = AppBlocObserver();

  runApp(const CineVaultApp());
}

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
