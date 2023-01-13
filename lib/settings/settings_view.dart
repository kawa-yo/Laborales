import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/settings/label_settings/label_settings_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text("labels",
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const VerticalDivider(thickness: 3),
                  const LabelSettingsView(),
                ],
              ),
            ),
          ],
        ));
  }
}
