import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/settings/label_settings/add_label_dialog/add_label_dialog_view_model.dart';

Future<void> addLabelDialog(BuildContext context, WidgetRef ref) async {
  var viewModel = ref.watch(addLabelDialogProvider);
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("新しいラベル"),
          content: SizedBox(
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: viewModel.controller,
                  validator: viewModel.validator,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    label: Text("label"),
                  ),
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
