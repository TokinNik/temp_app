import 'package:get_it/get_it.dart';
import 'package:temp_app/ui/pages/temp_logout_page/bloc/temp_logout_cubit.dart';

void registerPresentationModule(GetIt container) {
  container.registerFactory<TempLogoutCubit>(
    () => TempLogoutCubit(
      container.get(),
    ),
  );
  //TODO: registerPresentationModule
}
