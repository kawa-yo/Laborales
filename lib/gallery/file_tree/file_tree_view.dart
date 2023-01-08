import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:laborales/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/gallery/file_tree/file_tree_view_models.dart';
import 'package:laborales/gallery/photo/photo_view_model.dart';
import 'package:laborales/themes/tree_view_theme.dart';

class FileTreeView extends ConsumerWidget {
  const FileTreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewModel = ref.watch(fileTreeProvider);
    return TreeView(
      controller: viewModel.controller,
      theme: treeViewTheme,
      onNodeTap: (key) => ref.read(photosProvider).selectByPath(key),
      onExpansionChanged: viewModel.onExpansion,
    );
  }
}
