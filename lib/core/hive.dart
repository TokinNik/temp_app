import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path_helper;
import 'package:path_provider/path_provider.dart';
import 'package:temp_app/data/token/models/hive/token_hive_dto.dart';
import 'package:temp_app/data/user/models/local/user_hive_dto.dart';

import '../data/auth/models/local/auth_hive_dto.dart';

abstract class HiveConfig {
  static Future<void> init() async {
    await _initFlutter();
    _registerAdapters();
  }

  static void _registerAdapters() {
    Hive.registerAdapter(TokenHiveDtoAdapter());
    Hive.registerAdapter(AuthHiveDtoAdapter());
    Hive.registerAdapter(UserHiveDtoAdapter());
  }

  static Future<Box<TokenHiveDto>> openTokenBox() =>
      Hive.openBox<TokenHiveDto>('token');

  static Future<Box<AuthHiveDto>> openAuthBox() =>
      Hive.openBox<AuthHiveDto>('auth');

  static Future<Box<UserHiveDto>> openUserBox() =>
      Hive.openBox<UserHiveDto>('user');

  static Future<Box<dynamic>> openAppConfigBox() =>
      Hive.openBox<dynamic>('appConfig');
}

/// Hive Types IDs
/// Make sure to use typeIds consistently. Your changes have to be compatible to previous versions of the box.
/// [Hive doc](https://docs.hivedb.dev/#/custom-objects/type_adapters)
abstract class HiveTypeId {
  static const int token = 1;
  static const int auth = 2;
  static const int user = 3;
}

/// From flutter_hive
Future _initFlutter([String? subDir]) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    var appDir = await getApplicationDocumentsDirectory();
    var path = appDir.path;
    if (subDir != null) {
      path = path_helper.join(path, subDir);
    }
    Hive.init(path);
  }
}
