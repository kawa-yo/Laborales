import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/data/chart/chart_view.dart';
import 'package:laborales/data/table/table_view.dart';
import 'package:split_view/split_view.dart';

class DataView extends ConsumerWidget {
  const DataView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SplitView(
      viewMode: SplitViewMode.Horizontal,
      controller: SplitViewController(weights: [.7, .3]),
      children: const [
        TableView(),
        ChartView(),
      ],
    );
  }
}
