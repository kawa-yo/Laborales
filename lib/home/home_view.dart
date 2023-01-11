import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/display/display_view.dart';
import 'package:laborales/home/gallery/gallery_view.dart';
import 'package:laborales/home/home_view_model.dart';
import 'package:laborales/home/labeler/labeler_view.dart';
import 'package:laborales/themes/split_view_theme.dart';
import 'package:laborales/themes/theme.dart';
import 'package:laborales/utils/floating/floating_view.dart';
import 'package:split_view/split_view.dart';

class HomeView extends ConsumerWidget {
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

  HomeView({super.key});

  void onDestinationSelected(BuildContext context, int idx) {
    if (idx == 0) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FocusableActionDetector(
        shortcuts: ref.read(homeViewProvider).shortcuts,
        actions: ref.read(homeViewProvider).actions,
        autofocus: true,
        child: FloatingView(
          floatingWidget: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Card(
              elevation: 10,
              color: primaryColor.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: primaryColor.shade700, width: 2)),
              child: const LabelerView(),
            ),
          ),
          child: Row(
            children: [
              NavigationRail(
                labelType: NavigationRailLabelType.selected,
                destinations: destinations,
                selectedIndex: 1,
                onDestinationSelected: (idx) =>
                    onDestinationSelected(context, idx),
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
        ),
      ),
    );
  }
}
