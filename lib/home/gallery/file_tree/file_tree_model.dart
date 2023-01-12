import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:laborales/home/gallery/file_tree/file_tree_view_models.dart';

// Stream<TreeViewController> withAddNodesOnStream(
//   TreeViewController controller,
//   StreamController<List<Node>> streamController,
// ) async* {
//   var receivePort = ReceivePort();
//   var isolate = await Isolate.spawn(_withAddNodesOnStream,
//       [receivePort.sendPort, controller, streamController]);
//   await for (var message in receivePort) {
//     if (message == null) {
//       break;
//     }
//     yield message as TreeViewController;
//   }
// }
//
// Future<void> _withAddNodesOnStream(List<dynamic> args) async {
//   SendPort p = args[0];
//   TreeViewController controller = args[1];
//   StreamController<List<Node>> streamController = args[2];
//
//   await for (var nodes in streamController.stream) {
//     for (var node in nodes) {
//       int last = node.key.lastIndexOf("/");
//       var parentKey = node.key.substring(0, last);
//
//       controller = _makeParents(controller, node);
//       controller = controller.withAddNode(parentKey, node);
//     }
//     p.send(controller);
//   }
//   Isolate.exit(p);
// }

/// use isolate to prevent from busy-wait
Future<TreeViewController> withAddNodes(
  TreeViewController controller,
  List<Node> nodes,
) async {
  var receivePort = ReceivePort();
  var isolate = await Isolate.spawn(
      _withAddNodes, [receivePort.sendPort, controller, nodes]);
  return await receivePort.first as TreeViewController;
}

void _withAddNodes(List<dynamic> args) {
  SendPort p = args[0];
  TreeViewController controller = args[1];
  List<Node> nodes = args[2];

  for (var node in nodes) {
    int last = node.key.lastIndexOf("/");
    var parentKey = node.key.substring(0, last);

    controller = _makeParents(controller, node);
    controller = controller.withAddNode(parentKey, node);
  }
  Isolate.exit(p, controller);
}

TreeViewController _makeParents(TreeViewController controller, Node node) {
  var parent = Directory(node.key).parent;
  var parentNode = NodeExt.fromFSE(parent);

  if (controller.getNode(parentNode.key) != null) {
    return controller;
  }
  controller = _makeParents(controller, parentNode);
  return controller.withAddNode(parent.parent.path, parentNode);
}
