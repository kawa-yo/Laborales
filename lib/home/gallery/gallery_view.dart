import 'package:flutter/material.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view.dart';
import 'package:laborales/home/gallery/file_tree/file_tree_view.dart';
import 'package:laborales/themes/theme.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DefaultTabController(
        length: 3,
        child: Builder(
          builder: (context) {
            var controller = DefaultTabController.of(context)!;
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: lastColor,
                title: TabBar(
                  controller: controller,
                  labelColor: primaryColor,
                  unselectedLabelColor: secondaryColor,
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
                children: const [
                  FileTreeView(),
                  FileSemiGridView(),
                  FileGridView(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
