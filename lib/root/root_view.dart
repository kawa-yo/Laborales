import 'package:flutter/material.dart';
import 'package:laborales/display/display_view.dart';
import 'package:laborales/file_tree/file_tree_view.dart';
import 'package:laborales/gallery/gallery_view.dart';
import 'package:laborales/themes/split_view_theme.dart';
import 'package:split_view/split_view.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        gripSize: splitViewGripSize,
        gripColor: splitViewGripColor,
        gripColorActive: splitViewGripColorActivate,
        controller: SplitViewController(weights: [.2, .5, .3]),
        children: [
          FileTreeView(),
          DisplayView(),
          GalleryView(),
        ],
      ),
    );
  }
}
