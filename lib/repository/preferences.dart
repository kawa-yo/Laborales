import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _preferences;
SharedPreferences get prefs => _preferences;

bool _initialized = false;

Future<void> loadPreferences() async {
  _preferences = await SharedPreferences.getInstance();
  _initialized = true;
}
