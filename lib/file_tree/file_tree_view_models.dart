import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:laborales/file_tree/file_tree_model.dart';

typedef FSE = FileSystemEntity;

extension NodeExt on Node {
  static Node fromFSE(
    FSE fse, {
    IconData? icon,
    bool expanded = false,
  }) {
    var name = fse.path.split("/").last;
    return Node(
      key: fse.path,
      label: name,
      icon: icon,
      expanded: expanded,
    );
  }
}

final fileTreeProvider = ChangeNotifierProvider((ref) => FileTreeViewModel());

class FileTreeViewModel extends ChangeNotifier {
  TreeViewController controller;
  final bool autoLoading = true;

  Node get root => controller.children.first;
  Node? get selectedNode => controller.selectedNode;

  FileTreeViewModel() : controller = TreeViewController();

  Iterable<File> get dfsOnTree sync* {
    var stack = <Node>[root];
    while (stack.isNotEmpty) {
      var node = stack.removeLast();
      if (FSE.isFileSync(node.key)) {
        yield File(node.key);
      } else {
        stack.addAll(node.children);
      }
    }
  }

  Future<void> _loadFiles(Directory rootDir) async {
    final files = dfsOnFileSystem(rootDir);
    final nodes = files.map((fse) => NodeExt.fromFSE(
          fse,
          icon: fse is File ? Icons.image : null,
        ));
    await _addNodes(nodes);
  }

  Future<void> _addNodes(Stream<Node> nodes, {int updateCount = 1000}) async {
    int cnt = 0;
    await for (var node in nodes) {
      int last = node.key.lastIndexOf("/");
      var parentKey = node.key.substring(0, last);
      controller = controller.withAddNode(parentKey, node);

      if (++cnt % updateCount == 0) {
        debugPrint("#node: $cnt");
        notifyListeners();
      }
    }
    notifyListeners();
    debugPrint("done");
  }

  Future<void> setNewRoot() async {
    var dir = await pickDirectory();
    if (dir != null) {
      var root = NodeExt.fromFSE(dir, expanded: true);
      controller = TreeViewController(
        children: [root],
        selectedKey: dir.path,
      );
      notifyListeners();
      if (autoLoading) {
        await _loadFiles(dir);
      }
      debugPrint("set new root to $dir");
    }
  }
}
