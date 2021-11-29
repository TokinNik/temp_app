import 'package:get_it/get_it.dart';
import 'package:temp_app/di/modules/data_module.dart';
import 'package:temp_app/di/modules/domain_module.dart';
import 'package:temp_app/di/modules/presentation_module.dart';

GetIt getIt = GetIt.instance;

void initDependencies() {
  registerDataModule(getIt);
  registerDomainModule(getIt);
  registerPresentationModule(getIt);
}
