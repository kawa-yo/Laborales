import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _preferences;
bool _initialized = false;

Future<void> loadPreferences() async {
  _preferences = await SharedPreferences.getInstance();
  _initialized = true;
}

T? getPreferencesOf<T>(String key) {
  assert(_initialized);
  var value = _preferences.get(key);

  if (value == null) return null;
  return value as T;
}

Future<bool> setPreferencesOf<T>(String key, {required T to}) {
  assert(_initialized);
  switch (T.runtimeType) {
    case int:
      return _preferences.setInt(key, to as int);
    case bool:
      return _preferences.setBool(key, to as bool);
    case String:
      return _preferences.setString(key, to as String);
    case List<String>:
      return _preferences.setStringList(key, to as List<String>);
  }
  throw AssertionError(
      "to.runtimeType: ${to.runtimeType} was not match to int, bool, String or List<String>");
}
