import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/launcher/project_builder/project_builder_view.dart';
import 'package:laborales/root/root_view.dart';
import 'package:window_size/window_size.dart';

class LauncherView extends ConsumerWidget {
  const LauncherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcherViewModel = ref.watch(launcherProvider);
    return FutureBuilder(
      future: launcherViewModel.initialize(),
      builder: (context, snapshot) => snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done
          ? const Center(child: FlutterLogo(size: 300))
          : Scaffold(
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
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black45, width: 2),
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
                        itemCount: launcherViewModel.projects.length,
                        itemBuilder: (context, idx) {
                          var project = launcherViewModel.projects[idx];
                          return ListTile(
                            title: Row(children: [
                              Text(project.name,
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                              const Spacer(),
                              Text(project.lastModified,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                            ]),
                            subtitle: Text(project.targetDir.path,
                                style: Theme.of(context).textTheme.labelLarge),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              tooltip: "open",
                              onPressed: () =>
                                  onProjectSelected(context, ref, project),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

void onProjectSelected(
    BuildContext context, WidgetRef ref, Project project) async {
  debugPrint("$project selected.");
  ref.read(launcherProvider).selectProject(project);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const RootView(),
    ),
  );
  setWindowTitle("laborales   [ ${project.name} ]");
  Future.delayed(const Duration(milliseconds: 100))
      .then((_) => ref.read(galleryProvider).initialize());
}
