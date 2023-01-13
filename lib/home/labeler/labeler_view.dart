import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';

class LabelerView extends ConsumerWidget {
  const LabelerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewModel = ref.watch(labelerProvider);
    var galleryViewModel = ref.watch(galleryProvider);
    var selectedPhoto = galleryViewModel.selectedPhoto;
    var selectedLabel = galleryViewModel.labelOf(selectedPhoto);
    var labels = viewModel.labels;
    var colorOf = viewModel.label2color;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: labels.length,
      itemBuilder: ((context, idx) {
        var label = labels[idx];
        var color = colorOf[label] ?? Colors.grey;
        return CheckboxListTile(
          title:
              Text(labels[idx], style: Theme.of(context).textTheme.titleLarge),
          tileColor: selectedLabel == label ? color.withOpacity(.1) : null,
          side: BorderSide(color: color, width: 3),
          activeColor: color,
          controlAffinity: ListTileControlAffinity.leading,
          value: selectedLabel == labels[idx],
          onChanged: (value) {
            debugPrint("${labels[idx]}: $value");
            if (value == true && selectedPhoto != null) {
              // viewModel.setSelectedPhotoLabel(labels[idx]);
              viewModel.onLabelSelected(labels[idx]);
            }
          },
        );
      }),
    );
  }
}
