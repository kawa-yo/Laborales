import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:laborales/file_tree/file_tree_model.dart';

typedef FSE = FileSystemEntity;

extension NodeExt on Node {
  static Node fromFSE(
    FSE fse, {
    bool expanded = false,
  }) {
    var name = fse.path.split("/").last;
    var icon = fse is File ? Icons.image : null;
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

  void onExpansion(String key, bool expanded) {
    var node = controller.getNode(key);
    if (node == null) return;
    controller =
        controller.withUpdateNode(key, node.copyWith(expanded: expanded));
    notifyListeners();
  }

  Iterable<File> get dfsOnTree sync* {
    var stack = <Node>[root];
    while (stack.isNotEmpty) {
      var node = stack.removeLast();
      if (FSE.isFileSync(node.key)) {
        yield File(node.key);
      } else {
        stack.addAll(node.children.reversed);
      }
    }
  }

  Future<void> _loadFiles(Directory rootDir) async {
    final files = bfsOnFileSystem(rootDir);
    final nodes = files.map((fse) => NodeExt.fromFSE(fse));
    await _addNodes(nodes);
  }

  void _makeParents(Node node) {
    var parent = Directory(node.key).parent;
    var parentNode = NodeExt.fromFSE(parent);

    if (controller.getNode(parentNode.key) != null) {
      return;
    }
    _makeParents(parentNode);
    controller = controller.withAddNode(parent.parent.path, parentNode);
  }

  Future<void> _addNodes(Stream<Node> nodes, {int updateCount = 1000}) async {
    int cnt = 0;
    await for (var node in nodes) {
      int last = node.key.lastIndexOf("/");
      var parentKey = node.key.substring(0, last);
      _makeParents(node);
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
