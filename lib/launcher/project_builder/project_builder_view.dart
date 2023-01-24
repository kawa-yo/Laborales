import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/launcher/project_builder/project_builder_view_model.dart';

Future<void> addProjectDialog(BuildContext context, WidgetRef ref) async {
  var viewModel = ref.watch(projectBuilderProvider);

  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("新規プロジェクト"),
          content: SizedBox(
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: viewModel.nameController,
                  validator: viewModel.nameValidator,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    label: Text("project name"),
                  ),
                  onFieldSubmitted: (_) => viewModel.onSubmitted(context),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: viewModel.dirController,
                  readOnly: true,
                  validator: viewModel.nameValidator,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                      label: const Text("images folder"),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: viewModel.onSearchIconPressed,
                      )),
                  onFieldSubmitted: (_) => viewModel.onSubmitted(context),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("キャンセル"),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
              onPressed: () => viewModel.onSubmitted(context),
              child: const Text("OK"),
            ),
          ],
        );
      });
}
