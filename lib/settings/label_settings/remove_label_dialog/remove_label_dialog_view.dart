import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';

Future<void> removeLabelDialog(
    BuildContext context, WidgetRef ref, String label) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Warning'),
        content: Text("Are you sure to remove `$label`?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[50],
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
            onPressed: () {
              ref.read(labelerProvider).removeLabel(label);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
