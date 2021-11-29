import 'package:hive/hive.dart';
import 'package:temp_app/core/hive.dart';

import 'models/hive/token_hive_dto.dart';

class TokenStorage {
  static const _authKey = 'auth';
  static const _refreshKey = 'refresh';

  Box<TokenHiveDto>? _tokenBox;

  Future<Box<TokenHiveDto>> _getBox() async {
    return _tokenBox ??= await HiveConfig.openTokenBox();
  }

  Future<TokenHiveDto?> loadAuthToken() =>
      _getBox().then((box) => box.get(_authKey, defaultValue: null));

  Future<void> saveAuthToken(TokenHiveDto authToken) =>
      _getBox().then((box) => box.put(_authKey, authToken));

  Future<TokenHiveDto?> loadRefreshToken() =>
      _getBox().then((box) => box.get(_refreshKey, defaultValue: null));

  Future<void> saveRefreshToken(TokenHiveDto refreshToken) =>
      _getBox().then((box) => box.put(_refreshKey, refreshToken));

  Future<void> clear() => _getBox().then((box) => box.clear());
}
