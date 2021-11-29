
import 'package:temp_app/data/user/mapper/user_mapper.dart';
import 'package:temp_app/data/user/user_storage.dart';
import 'package:temp_app/domain/models/user_model.dart';

abstract class UserRepository {
  Future<void> saveUserData(UserModel? userModel);
  Future<UserModel?> loadUserData();
}

class UserRepositoryImpl extends UserRepository {
  final UserStorage _userStorage;

  UserRepositoryImpl(this._userStorage);

  @override
  Future<void> saveUserData(UserModel? userModel) async {
    return await _userStorage.saveUserData(UserMapper.toDto(userModel));
  }

  @override
  Future<UserModel?> loadUserData() async{
    var result = await _userStorage.loadUserData();
    return UserMapper.fromDto(result);
  }
}
