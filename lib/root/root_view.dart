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
    var selectedIdx = useState(0);

    void onDestinationSelected(int idx) {
      selectedIdx.value = idx;
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
              labelType: NavigationRailLabelType.selected,
              destinations: destinations,
              selectedIndex: selectedIdx.value,
              onDestinationSelected: onDestinationSelected,
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey[50],
                            minimumSize: const Size(60, 60),
                            shape: const CircleBorder()),
                        child: const Tooltip(
                          message: "go back",
                          child: Icon(Icons.keyboard_arrow_left_sharp),
                        ),
                        onPressed: () {
                          setWindowTitle("laborales");
                          Navigator.of(context, rootNavigator: true).pop();
                        }),
                  ),
                ),
              )),
          Expanded(child: widgets[selectedIdx.value]),
        ],
      ),
    );
  }
}
