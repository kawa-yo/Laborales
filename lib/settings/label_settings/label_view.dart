import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';
import 'package:laborales/settings/label_settings/remove_label_dialog/remove_label_dialog_view.dart';

class LabelView extends HookConsumerWidget {
  final String label;
  final Color? color;
  const LabelView({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var onHover = useState(false);
    return MouseRegion(
      child: ListTile(
          dense: true,
          leading: Icon(Icons.circle, color: color),
          title: Text(label, style: Theme.of(context).textTheme.titleLarge),
          trailing: IconButton(
            color: onHover.value ? Colors.red : Colors.grey[300],
            icon: const Icon(Icons.delete),
            onPressed: () => removeLabelDialog(context, ref, label),
          )),
      onEnter: (event) => onHover.value = true,
      onExit: (event) => onHover.value = false,
    );
  }
}
