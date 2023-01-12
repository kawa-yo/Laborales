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
    var colors = viewModel.colors;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: labels.length,
      itemBuilder: ((context, idx) {
        return CheckboxListTile(
          title: Text(labels[idx]),
          side: BorderSide(color: colors[idx], width: 3),
          activeColor: colors[idx],
          controlAffinity: ListTileControlAffinity.leading,
          value: selectedLabel == labels[idx],
          onChanged: (value) {
            debugPrint("${labels[idx]}: $value");
            if (value == true && selectedPhoto != null) {
              viewModel.setSelectedPhotoLabel(labels[idx]);
            }
          },
        );
      }),
    );
  }
}
