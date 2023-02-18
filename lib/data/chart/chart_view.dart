import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/data/chart/chart_view_model.dart';
import 'package:laborales/data/chart/filter/filter_view.dart';
import 'package:laborales/data/chart/filter/filter_view_model.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartView extends ConsumerWidget {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool includeNull = ref.watch(chartProvider).includeNull;

    var labels = ref.watch(labelerProvider).labels;
    var colors = ref.watch(labelerProvider).label2color.values.toList();
    if (includeNull) {
      labels.add("null");
      colors.add(Colors.grey[400]!);
    }
    var photos = ref.watch(galleryProvider).list;
    var labelOf = ref.watch(galleryProvider).path2label;
    var isSelectedDir = ref.watch(filterProvider).isSelected;
    var dataMap = {
      for (var label in labels)
        label: photos
            .where((photo) => (labelOf[photo.src.path] ?? "null") == label)
            .where((photo) => !isSelectedDir(photo.src.parent.path))
            .length
            .toDouble()
    };
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: const SingleChildScrollView(
              child: FilterView(),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("include null",
                style: Theme.of(context).textTheme.titleMedium),
            value: includeNull,
            onChanged: (value) {
              if (value != null) {
                ref.read(chartProvider).setIncludeNull(value);
              }
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30),
              child: PieChart(
                emptyColor: Colors.grey[50]!,
                dataMap: dataMap,
                initialAngleInDegree: 270,
                colorList: colors,
                chartValuesOptions: const ChartValuesOptions(
                  decimalPlaces: 0,
                  showChartValuesOutside: true,
                ),
                animationDuration: const Duration(seconds: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
