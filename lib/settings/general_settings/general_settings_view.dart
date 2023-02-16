import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laborales/home/display/display_view_model.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view_model.dart';

class GeneralSettingsView extends HookConsumerWidget {
  const GeneralSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool reversed = ref.watch(displayProvider).reverseScroll;
    int numColumn = ref.watch(fileGridProvider).numColumn;
    double cacheExtent = ref.watch(fileGridProvider).cacheExtent;
    var cacheLevels = <double>[0, 500, 1000, 2000, 5000];
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          ListTile(
            title: const Text("Reverse scroll direction"),
            trailing: Switch(
              value: reversed,
              onChanged: (value) =>
                  ref.read(displayProvider).setReverseScroll(value),
            ),
          ),
          ListTile(
            title: const Text("#column of grid"),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                min: 1.0,
                max: 5.0,
                divisions: 4,
                value: numColumn.toDouble(),
                label: "$numColumn",
                onChanged: (value) =>
                    ref.read(fileGridProvider).setNumColumn(value.toInt()),
              ),
            ),
          ),
          ListTile(
            title: const Text("Cache on GridView [pixels]"),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                min: 0,
                max: cacheLevels.length - 1,
                divisions: cacheLevels.length - 1,
                value: cacheLevels.indexOf(cacheExtent).toDouble(),
                label: "${cacheExtent.toInt()}",
                onChanged: (value) {
                  int idx = value.toInt();
                  double cache = cacheLevels[idx];
                  ref.read(fileGridProvider).setCacheExtent(cache);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
