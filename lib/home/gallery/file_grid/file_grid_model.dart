import 'package:laborales/repository/preferences.dart';

const numColumnKey = "laborales/general/num_column_of_grid";
const cacheExtentKey = "laborales/general/num_column_of_grid";

Future<void> saveNumColumnOfGridToPrefs(int numColumn) async {
  await prefs.setInt(numColumnKey, numColumn);
}

int? loadNumColumnOfGridFromPrefs() {
  return prefs.getInt(numColumnKey);
}

Future<void> saveCacheExtentOfGridToPrefs(double cacheExtent) async {
  await prefs.setDouble(cacheExtentKey, cacheExtent);
}

double? loadCacheExtentOfGridFromPrefs() {
  return prefs.getDouble(cacheExtentKey);
}
