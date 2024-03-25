import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveShared(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<bool> loadShared(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool info = prefs.getBool(key) ?? false;
  return info;
}
