import 'package:laborales/repository/preferences.dart';

const key = "laborales/general/num_column_of_grid";

Future<void> saveNumColumnOfGridToPrefs(int numColumn) async {
  await prefs.setInt(key, numColumn);
}

int? loadNumColumnOfGridFromPrefs() {
  return prefs.getInt(key);
}
