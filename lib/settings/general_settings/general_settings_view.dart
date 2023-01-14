import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/display/display_view_model.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view_model.dart';

class GeneralSettingsView extends ConsumerWidget {
  const GeneralSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var reversed = ref.watch(displayProvider).reverseScroll;
    var numColumn = ref.watch(fileGridProvider).numColumn;
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          ListTile(
            title: const Text("reverse scroll direction"),
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
        ],
      ),
    );
  }
}
