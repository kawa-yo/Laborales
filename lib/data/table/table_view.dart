import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/data/table/table_view_model.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/themes/theme.dart';

class TableView extends ConsumerWidget {
  const TableView({super.key});

  Widget tableRow(
    String cell1,
    String cell2,
    String cell3, {
    TextStyle? style,
    Color? tileColor,
  }) {
    return ListTile(
      tileColor: tileColor,
      title: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(cell1, style: style),
          ),
          const VerticalDivider(thickness: 2),
          Expanded(
            flex: 2,
            child: Text(cell2, style: style),
          ),
          Expanded(
            flex: 1,
            child: Text(cell3, style: style),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var galleryViewModel = ref.watch(galleryProvider);
    var photos = galleryViewModel.list;
    var labelOf = galleryViewModel.labelOf;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        title: tableRow(
          "idx",
          "path",
          "label",
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: ListView.builder(
        cacheExtent: 1000,
        itemCount: photos.length,
        itemBuilder: (context, idx) {
          var photo = photos[idx];
          return tableRow(
            "$idx",
            photo.src.path,
            labelOf(photo),
            tileColor: idx % 2 == 0 ? Colors.grey[50] : primaryColor.shade50,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "download",
        child: const Icon(Icons.download),
        onPressed: () {
          ref.read(tableProvider).saveToFile().then((saveFile) {
            ScaffoldMessenger.of(context).showSnackBar(
              saveFile == null
                  ? SnackBar(
                      content: const Text("Failed to save."),
                      backgroundColor: Colors.red[300],
                    )
                  : SnackBar(
                      content: Text("Succeeded in saving to ${saveFile.path}."),
                      backgroundColor: Colors.green[300],
                    ),
            );
          });
        },
      ),
    );
  }
}
