import 'package:flutter/foundation.dart';
import 'package:nyxx_self/nyxx.dart';
import 'package:nyxx_self/src/models/user/user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static FlutterSecureStorage secureStorage = FlutterSecureStorage();
  static SharedPreferences? preferences;

  static bool initialized = false;
  static bool loggedIn = false;
  static String? token;
  static NyxxGateway? client;
  static User? user;

  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();

    bool? isFinishedSetup = preferences?.getBool("isFinishedSetup");
    if (isFinishedSetup == null) {
      await secureStorage.deleteAll();
    }
    preferences?.setBool("isFinishedSetup", true);

    token = await secureStorage.read(key: "token");
    if (token != null) {
      loggedIn = true;
      await loadUserData();
    } else {
      debugPrint("a");
    }

    initialized = true;
    return;
  }

  static Future<void> setToken(String newToken) async {
    await secureStorage.write(key: "token", value: newToken);
    await StorageService.initialize();
  }

  static Future<void> loadUserData() async {
    client =
        await Nyxx.connectGateway('${token}', GatewayIntents.allUnprivileged);
    user = await client?.users.fetchCurrentUser();
    debugPrint(user?.username);
  }
}
