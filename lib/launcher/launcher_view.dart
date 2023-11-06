import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/launcher/project_builder/project_builder_view.dart';
import 'package:laborales/launcher/remove_project_dialog/remove_project_dialog_view.dart';

class LauncherView extends HookConsumerWidget {
  const LauncherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var projects =
        ref.watch(launcherProvider.select((value) => value.projects));
    var removeMode = useState(false);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 800,
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  Text("Projects",
                      style: Theme.of(context).textTheme.displayMedium),
                  const Spacer(),

                  /// toggle remove mode
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(28.0),
                        color:
                            removeMode.value ? Colors.red : Colors.grey[100]),
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      tooltip: "プロジェクトを削除",
                      color: removeMode.value ? Colors.grey[100] : Colors.red,
                      onPressed: () => removeMode.value = !removeMode.value,
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// add project button
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 2),
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: "新規プロジェクト",
                      color: Colors.black54,
                      onPressed: () => addProjectDialog(context, ref),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 3, color: Colors.black12),
              ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length,
                itemBuilder: (context, idx) {
                  var project = projects[idx];
                  return ListTile(
                    title: Row(children: [
                      Text(project.name,
                          style: Theme.of(context).textTheme.displaySmall),
                      const Spacer(),
                      Text(project.lastModified,
                          style: Theme.of(context).textTheme.labelLarge),
                    ]),
                    onTap: () {
                      if (removeMode.value == false) {
                        ref
                            .read(launcherProvider)
                            .onProjectSelected(context, project);
                      }
                    },
                    subtitle: Text(project.targetDir.path,
                        style: Theme.of(context).textTheme.labelLarge),
                    trailing: removeMode.value
                        ?

                        /// remove project button
                        Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.grey[100],
                              tooltip: "delete",
                              onPressed: () =>
                                  removeProjectDialog(context, ref, project),
                            ),
                          )

                        /// open project button
                        : IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            tooltip: "open",
                            onPressed: () => ref
                                .read(launcherProvider)
                                .onProjectSelected(context, project),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
