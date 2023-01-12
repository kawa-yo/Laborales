import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:laborales/home/gallery/file_tree/file_tree_model.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

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

  /// listening to event synchronously
  final StreamController<List<Node>> streamController;

  Node? get selectedNode => controller.selectedNode;

  FileTreeViewModel()
      : controller = TreeViewController(),
        streamController = StreamController() {
    // streamController.stream.listen(addNodes);
  }

  void onExpansion(String key, bool expanded) {
    var node = controller.getNode(key);
    if (node == null) return;
    controller =
        controller.withUpdateNode(key, node.copyWith(expanded: expanded));
    notifyListeners();
  }

  // Future<void> startStream() async {
  //   await for (var treeViewController
  //       in withAddNodesOnStream(controller, streamController)) {
  //     controller = treeViewController;
  //     notifyListeners();
  //   }
  // }

  // Future<void> endStream() async {
  //   await streamController.done;
  // }

  // void addNodesOnStream(Iterable<FSE> files) {
  //   var nodes = files.map((file) => NodeExt.fromFSE(file)).toList();
  //   streamController.add(nodes);
  // }

  Future<void> addNodes(Iterable<FSE> files) async {
    debugPrint("addNode: start");
    var nodes = files.map((file) => NodeExt.fromFSE(file)).toList();
    controller = await withAddNodes(controller, nodes);
    debugPrint("addNode: end");
    notifyListeners();
  }

  void setRoot(Directory rootDir) {
    var rootNode = NodeExt.fromFSE(rootDir, expanded: true);
    controller = TreeViewController(
      children: [rootNode],
    );
    notifyListeners();
    debugPrint("set new root to $rootDir");
  }
}
