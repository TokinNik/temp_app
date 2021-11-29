
import 'package:temp_app/data/user/models/local/user_hive_dto.dart';
import 'package:temp_app/data/user/models/network/user_response.dart';
import 'package:temp_app/domain/models/user_model.dart';

class UserMapper {
  UserMapper._();

  static UserModel toDomain(UserResponse userResponse) {
    return UserModel(
      email: userResponse.email,
      firstName: userResponse.firstName,
      lastName: userResponse.lastName,
      middleName: userResponse.middleName,
    );
  }

  static UserModel fromDto(UserHiveDto? userHiveDto) {
    return UserModel(
      email: userHiveDto?.email,
      firstName: userHiveDto?.firstName,
      lastName: userHiveDto?.lastName,
      middleName: userHiveDto?.middleName,
    );
  }

  static UserHiveDto toDto(UserModel? userModel) {
    return UserHiveDto(
      email: userModel?.email,
      firstName: userModel?.firstName,
      lastName: userModel?.lastName,
      middleName: userModel?.middleName,
    );
  }
}
