import 'dart:io';

import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';

typedef FSE = FileSystemEntity;

Future<T> ensureToOpen<T extends FSE>(T fse) async {
  var bookmark = await SecureBookmarks().bookmark(fse);

  return fse;
}

Future<String> getBookmarkOf(FSE fse) async {
  return await SecureBookmarks().bookmark(fse);
}

Future<File> resolveFileFrom(String bookmark) async {
  var resolvedEntity = await SecureBookmarks().resolveBookmark(bookmark);
  var resolved = File(resolvedEntity.path);
  await SecureBookmarks().startAccessingSecurityScopedResource(resolved);
  return resolved;
}

Future<Directory> resolveDirectoryFrom(String bookmark) async {
  var resolvedEntity = await SecureBookmarks().resolveBookmark(bookmark);
  var resolved = Directory(resolvedEntity.path);
  await SecureBookmarks().startAccessingSecurityScopedResource(resolved);
  return resolved;
}
