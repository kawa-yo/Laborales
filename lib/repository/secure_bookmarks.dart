import 'dart:io';

import 'package:laborales/repository/preferences.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';

final _secureBookmarks = SecureBookmarks();

Future<Directory> ensureToOpen(
  Directory directory, {
  bool preference = false,
}) async {
  var bookmark = await _secureBookmarks.bookmark(directory);
  return directory;
  var resolvedEntity = await _secureBookmarks.resolveBookmark(bookmark);
  var resolved = Directory(resolvedEntity.path);

  await _secureBookmarks.startAccessingSecurityScopedResource(resolved);

  if (preference) {
    throw UnimplementedError();
    setPreferencesOf("laborales/bookmarks/hoge", to: bookmark);
  }
  return resolved;
}
