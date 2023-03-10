import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laborales/data/data_view.dart';
import 'package:laborales/home/home_view.dart';
import 'package:laborales/settings/settings_view.dart';
import 'package:window_size/window_size.dart';

class RootView extends HookConsumerWidget {
  static const destinations = [
    NavigationRailDestination(
      icon: Tooltip(
        message: "Back",
        child: Icon(Icons.keyboard_arrow_left_sharp),
      ),
      label: Text("go back"),
    ),
    NavigationRailDestination(
      icon: Tooltip(
        message: "home",
        child: Icon(Icons.home_outlined),
      ),
      selectedIcon: Icon(Icons.home),
      label: Text("home"),
    ),
    NavigationRailDestination(
      icon: Tooltip(
        message: "table",
        child: Icon(Icons.table_chart_outlined),
      ),
      selectedIcon: Icon(Icons.table_chart),
      label: Text("table"),
    ),
    NavigationRailDestination(
      icon: Tooltip(
        message: "settings",
        child: Icon(Icons.settings_outlined),
      ),
      selectedIcon: Icon(Icons.settings),
      label: Text("settings"),
    ),
  ];

  static const widgets = [
    HomeView(),
    DataView(),
    SettingsView(),
  ];

  const RootView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIdx = useState(1);

    void onDestinationSelected(int idx) {
      if (idx == 0) {
        setWindowTitle("laborales");
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        selectedIdx.value = idx;
      }
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            destinations: destinations,
            selectedIndex: selectedIdx.value,
            onDestinationSelected: (idx) => onDestinationSelected(idx),
          ),
          Expanded(child: widgets[selectedIdx.value - 1]),
        ],
      ),
    );
  }
}
