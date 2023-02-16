import 'package:laborales/repository/preferences.dart';

const key = "laborales/general/reverse_scroll";

Future<void> saveReverseScrollToPrefs(bool reverse) async {
  await prefs.setBool(key, reverse);
}

bool? loadReverseScrollFromPrefs() {
  return prefs.getBool(key);
}
