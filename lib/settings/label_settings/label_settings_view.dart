import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';
import 'package:laborales/settings/label_settings/add_label_dialog/add_label_dialog_view.dart';
import 'package:laborales/settings/label_settings/label_view.dart';
import 'package:laborales/themes/theme.dart';

class LabelSettingsView extends ConsumerWidget {
  const LabelSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var labelerViewModel = ref.watch(labelerProvider);
    var label2color = labelerViewModel.label2color;
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (MapEntry<String, Color> e in label2color.entries)
            LabelView(label: e.key, color: e.value),
          ListTile(
            trailing: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: primaryColor),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: "add label",
                icon: const Icon(Icons.add),
                color: primaryColor,
                onPressed: () => addLabelDialog(context, ref),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
