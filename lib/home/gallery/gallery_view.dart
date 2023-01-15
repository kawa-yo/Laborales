import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view.dart';
import 'package:laborales/home/gallery/file_tree/file_tree_view.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/themes/theme.dart';

class GalleryView extends ConsumerWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Photo> photos =
        ref.watch(galleryProvider.select((value) => value.list));
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DefaultTabController(
        length: 3,
        initialIndex: ref.read(galleryProvider).defaultTabIndex,
        child: Builder(
          builder: (context) {
            var controller = DefaultTabController.of(context);
            controller.addListener(() {
              int idx = controller.index;
              ref.read(galleryProvider).onTabChanged(idx);
            });
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: lastColor,
                title: TabBar(
                  controller: controller,
                  labelColor: primaryColor,
                  unselectedLabelColor: primaryColor.shade200,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.account_tree),
                      text: "tree",
                    ),
                    Tab(
                      icon: Icon(Icons.list_alt),
                      text: "semi grid",
                    ),
                    Tab(
                      icon: Icon(Icons.grid_on),
                      text: "grid",
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: controller,
                children: [
                  const FileTreeView(),
                  FileSemiGridView(),
                  FileGridView(photos: photos),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
