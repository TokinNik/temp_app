import 'package:temp_app/data/auth/auth_holder.dart';
import 'package:temp_app/data/auth/mapper/auth_mapper.dart';
import 'package:temp_app/data/user/user_storage.dart';

import 'auth_storage.dart';
import 'models/auth.dart';

abstract class AuthRepository {
  Future<String?> init();

  Future<void> saveAuthCreds(Auth auth);

  Future<void> clearSession();
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthStorage _authStorage;
  final AuthHolder _authHolder;
  final UserStorage _userStorage;

  AuthRepositoryImpl(this._authStorage, this._authHolder, this._userStorage);

  @override
  Future<String?> init() async {
    var authData = await _authStorage.loadAuthData();
    _authHolder.init(AuthMapper.toDomain(authData));
    return authData?.accessToken;
  }

  @override
  Future<void> saveAuthCreds(Auth auth) async {
    _authHolder.init(auth);
    await _authStorage.saveAuthData(AuthMapper.toDto(auth));
  }

  @override
  Future<void> clearSession() async {
    _authHolder.dispose();
    await _userStorage.clear();
    return await _authStorage.clear();
  }
}
