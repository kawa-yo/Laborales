import 'dart:io';

import 'package:laborales/file_tree/file_tree_view_models.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';

final _secureBookmarks = SecureBookmarks();

Future<T> ensureToOpen<T extends FSE>(T fse) async {
  var bookmark = await _secureBookmarks.bookmark(fse);
  return fse;
}

Future<String> getBookmarkOf(FSE fse) async {
  return await _secureBookmarks.bookmark(fse);
}

Future<File> resolveFileFrom(String bookmark) async {
  var resolvedEntity = await _secureBookmarks.resolveBookmark(bookmark);
  var resolved = File(resolvedEntity.path);
  await _secureBookmarks.startAccessingSecurityScopedResource(resolved);
  return resolved;
}

Future<Directory> resolveDirectoryFrom(String bookmark) async {
  var resolvedEntity = await _secureBookmarks.resolveBookmark(bookmark);
  var resolved = Directory(resolvedEntity.path);
  await _secureBookmarks.startAccessingSecurityScopedResource(resolved);
  return resolved;
}
