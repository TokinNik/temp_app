import 'package:get_it/get_it.dart';
import 'package:temp_app/domain/login/login_usecase.dart';

void registerDomainModule(GetIt container) {
  container.registerFactory<LoginUseCase>(
    () => LoginUseCase(
      container.get(),
    ),
  );
  //TODO: registerDomainModule
}
