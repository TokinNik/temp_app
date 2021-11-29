import 'package:hive/hive.dart';

import '../../core/hive.dart';
import 'models/local/auth_hive_dto.dart';

class AuthStorage {
  static const _authKey = 'auth';

  Box<AuthHiveDto>? _authBox;

  Future<Box<AuthHiveDto>> _getBox() async {
    return _authBox ??= await HiveConfig.openAuthBox();
  }

  Future<AuthHiveDto?> loadAuthData() =>
      _getBox().then((box) => box.get(_authKey, defaultValue: null));

  Future<void> saveAuthData(AuthHiveDto authToken) =>
      _getBox().then((box) => box.put(_authKey, authToken));

  Future<void> clear() => _getBox().then((box) => box.clear());
}
