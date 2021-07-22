import 'package:get_it/get_it.dart';
import 'package:temp_app/core/dio/dio.dart';
import 'package:temp_app/core/servises/impl/session_service_impl.dart';
import 'package:temp_app/core/servises/session_service.dart';

GetIt getIt = GetIt.instance;

void initDependencies() {
  getIt.registerSingleton<Dio>(
    DioFactory.buildAuthClient(),
    instanceName: "AuthClient",
  );
  getIt.registerSingleton<SessionService>(
    SessionServiceImpl(
      getIt.get(
        instanceName: "AuthClient",
      ),
    ),
  );
  getIt.registerSingleton<Dio>(DioFactory.buildMainClient(getIt.get()));


}
