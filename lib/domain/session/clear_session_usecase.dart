import 'package:temp_app/data/auth/auth_repository.dart';

import '../use_case.dart';

class ClearSessionUseCase implements UseCase<void, NoParams> {
  ClearSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> call(_) async {
    await _authRepository.clearSession();
    return;
  }
}
