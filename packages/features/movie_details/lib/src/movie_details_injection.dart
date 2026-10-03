import 'package:injectable/injectable.dart';

/// Entry point of this package's injectable module: its bloc. The app's root
/// injector includes the generated module; the use cases come from `domain`.
@InjectableInit.microPackage()
void initMovieDetailsPackage() {}
