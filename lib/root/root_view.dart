import 'package:flutter/material.dart';
import 'package:laborales/display/display_view.dart';
import 'package:laborales/gallery/file_grid/file_grid_view.dart';
import 'package:laborales/gallery/file_tree/file_tree_view.dart';
import 'package:laborales/gallery/gallery_view.dart';
import 'package:laborales/themes/split_view_theme.dart';
import 'package:split_view/split_view.dart';

class RootView extends StatelessWidget {
  final destinations = [
    const NavigationRailDestination(
      icon: Tooltip(
        message: "Back",
        child: Icon(Icons.keyboard_arrow_left_sharp),
      ),
      label: Text("go back"),
    ),
    const NavigationRailDestination(
      icon: Tooltip(
        message: "home",
        child: Icon(Icons.home_outlined),
      ),
      selectedIcon: Icon(Icons.home),
      label: Text("home"),
    ),
    const NavigationRailDestination(
      icon: Tooltip(
        message: "table",
        child: Icon(Icons.table_chart_outlined),
      ),
      selectedIcon: Icon(Icons.table_chart),
      label: Text("table"),
    ),
    const NavigationRailDestination(
      icon: Tooltip(
        message: "settings",
        child: Icon(Icons.settings_outlined),
      ),
      selectedIcon: Icon(Icons.settings),
      label: Text("settings"),
    ),
  ];

  RootView({super.key});

  void onDestinationSelected(BuildContext context, int idx) {
    if (idx == 0) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            destinations: destinations,
            selectedIndex: 1,
            onDestinationSelected: (idx) => onDestinationSelected(context, idx),
          ),
          Expanded(
            child: SplitView(
              viewMode: SplitViewMode.Horizontal,
              gripSize: splitViewGripSize,
              gripColor: splitViewGripColor,
              gripColorActive: splitViewGripColorActivate,
              controller: SplitViewController(weights: [.3, .7]),
              children: const [
                GalleryView(),
                DisplayView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
