import 'package:injectable/injectable.dart';

/// Entry point of this package's injectable module: the favorites bloc and the app-wide FavoriteIdsCubit. The app's root
/// injector includes the generated module; the use cases come from `domain`.
@InjectableInit.microPackage()
void initFavoritesPackage() {}
