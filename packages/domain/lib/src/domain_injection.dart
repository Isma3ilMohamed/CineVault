import 'package:injectable/injectable.dart';

/// Entry point of this package's injectable module: every `@lazySingleton`
/// use case. The app's root injector includes the generated module.
@InjectableInit.microPackage()
void initDomainPackage() {}
