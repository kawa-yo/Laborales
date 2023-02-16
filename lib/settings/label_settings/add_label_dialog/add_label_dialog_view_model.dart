import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';

final addLabelDialogProvider = Provider((ref) => AddLabelDialogViewModel(ref));

class AddLabelDialogViewModel {
  final Ref ref;
  final TextEditingController controller;

  AddLabelDialogViewModel(this.ref) : controller = TextEditingController();

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Fill the blank.";
    }
    var existingLabels = ref.read(labelerProvider).labels;
    if (existingLabels.contains(value)) {
      return "This label already exists.";
    }
    return null;
  }

  void onSubmitted(BuildContext context) {
    var label = controller.text;
    if (validator(label) == null) {
      ref.read(labelerProvider).addLabel(label);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
