import 'package:hive/hive.dart';
import 'package:temp_app/core/hive.dart';
import 'package:temp_app/data/user/models/local/user_hive_dto.dart';

class UserStorage {
  static const _userKey = 'user';

  Box<UserHiveDto>? _userBox;

  Future<Box<UserHiveDto>> _getBox() async {
    return _userBox ??= await HiveConfig.openUserBox();
  }

  Future<UserHiveDto?> loadUserData() =>
      _getBox().then((box) => box.get(_userKey, defaultValue: null));

  Future<void> saveUserData(UserHiveDto userHiveDto) =>
      _getBox().then((box) => box.put(_userKey, userHiveDto));

  Future<void> clear() => _getBox().then((box) => box.clear());
}
