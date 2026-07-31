import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String userKey = "username";

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, name);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userKey) ?? "User";
  }
}
