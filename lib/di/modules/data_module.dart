import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:temp_app/core/network/dio_utils/dio_factory.dart';
import 'package:temp_app/data/login/login_repository.dart';
import 'package:temp_app/data/login/service/login_service.dart';
import 'package:temp_app/data/token/service/token_service.dart';
import 'package:temp_app/data/token/token_holder.dart';
import 'package:temp_app/data/user/user_repository.dart';
import 'package:temp_app/data/user/user_storage.dart';

const String _tokenClientInstanceName = 'token_client';

void registerDataModule(GetIt container) {
  _registerDioClient(container);
  _registerLogin(container);
  _registerToken(container);
  _registerUser(container);
  //TODO: registerDataModule
}

void _registerDioClient(GetIt container) {
  container.registerLazySingleton<Dio>(
    () => DioFactory.buildAuthorizedClient(
      container.get(),
    ),
  );
}

void _registerToken(GetIt container) {
  container.registerLazySingleton<Dio>(
    () => DioFactory.buildClient(),
    instanceName: _tokenClientInstanceName,
  );

  container.registerLazySingleton<TokenHolder>(
    () => TokenHolder(
      container.get(),
    ),
  );

  container.registerFactory<TokenService>(
    () => TokenServiceImpl(
      container.get(instanceName: _tokenClientInstanceName),
    ),
  );
}

void _registerLogin(GetIt container) {
  container.registerFactory<LoginService>(
    () => LoginServiceImpl(
      container.get(instanceName: _tokenClientInstanceName),
    ),
  );

  container.registerFactory<LoginRepository>(
    () => LoginRepositoryImpl(container.get()),
  );
}

void _registerUser(GetIt container) {
  container.registerFactory<UserRepository>(
    () => UserRepositoryImpl(container.get()),
  );
  container.registerFactory<UserStorage>(
    () => UserStorage(),
  );
}
