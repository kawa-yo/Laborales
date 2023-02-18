import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/data/chart/filter/filter_view_model.dart';
import 'package:laborales/data/chart/filter/tag_view.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

class FilterView extends ConsumerWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dirs = ref.watch(fileSemiGridProvider).dirs;
    var root_ =
        ref.watch(launcherProvider).project!.targetDir.path.split("/").last;
    var start_ = dirs.first.indexOf(root_);
    var prefix = dirs.first.substring(0, start_);
    dirs = dirs.map((e) => e.substring(start_ + root_.length)).toList();

    var viewModel = ref.watch(filterProvider);
    var isSelected = viewModel.isSelected;
    var isAllDeselected = viewModel.isAllDeselected();

    return Wrap(
      spacing: 3.0,
      runSpacing: 3.0,
      children: [
        TagView(
          tag: root_,
          isSelected: isAllDeselected,
          onTap: () => viewModel.toggleAll(),
        ),
        for (var dir in dirs)
          TagView(
            tag: dir,
            isSelected: !isSelected(prefix + root_ + dir),
            onTap: () => viewModel.toggle(prefix + root_ + dir),
          ),
      ],
    );
  }
}
