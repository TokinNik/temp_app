import 'package:get_it/get_it.dart';
import 'package:temp_app/di/modules/data_module.dart';
import 'package:temp_app/di/modules/domain_module.dart';
import 'package:temp_app/di/modules/presentation_module.dart';
import 'package:temp_app/ui/router/login_router.dart';

import '../ui/router/logout_router.dart';

GetIt getIt = GetIt.instance;

void initDependencies() {
  getIt.registerLazySingleton<LogoutRouter>(
    () => LogoutRouter(),
    instanceName: LogoutRouter.instanceName,
  );

  getIt.registerLazySingleton<LoginRouter>(
    () => LoginRouter(),
    instanceName: LoginRouter.instanceName,
  );

  registerDataModule(getIt);
  registerDomainModule(getIt);
  registerPresentationModule(getIt);
}
