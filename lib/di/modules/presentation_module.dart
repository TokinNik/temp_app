import 'package:get_it/get_it.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/ui/pages/temp_logout_page/bloc/temp_logout_cubit.dart';
import 'package:temp_app/ui/router/login_router.dart';

import '../../ui/pages/home/bloc/home_cubit.dart';
import '../../ui/router/logout_router.dart';

void registerPresentationModule(GetIt container) {
  container.registerFactory<GlobalBloc>(
    () => GlobalBloc(
      container.get(instanceName: LogoutRouter.instanceName),
      container.get(instanceName: LoginRouter.instanceName),
    ),
  );
  container.registerFactory<TempLogoutCubit>(
    () => TempLogoutCubit(
      container.get(),
    ),
  );
  container.registerFactory<HomeCubit>(
    () => HomeCubit(
      container.get(),
    ),
  );
  //TODO: registerPresentationModule
}
