import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

Future<void> removeProjectDialog(
    BuildContext context, WidgetRef ref, Project project) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Warning'),
        content: Text("Are you sure to remove the project `${project.name}`?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[50],
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
            onPressed: () {
              ref.read(launcherProvider).removeProject(project);
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
