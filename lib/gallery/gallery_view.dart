import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/file_grid/file_grid_view.dart';
import 'package:laborales/gallery/file_tree/file_tree_view.dart';
import 'package:laborales/themes/theme.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: secondaryColor,
      //     width: 2.0,
      //   ),
      //   borderRadius: const BorderRadius.all(
      //     Radius.circular(10),
      //   ),
      // ),
      child: Padding(
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
                    Text("semi grid"),
                    FileGridView(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
