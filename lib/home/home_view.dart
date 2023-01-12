import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/display/display_view.dart';
import 'package:laborales/home/gallery/gallery_view.dart';
import 'package:laborales/home/home_view_model.dart';
import 'package:laborales/home/labeler/labeler_view.dart';
import 'package:laborales/themes/split_view_theme.dart';
import 'package:laborales/themes/theme.dart';
import 'package:laborales/utils/floating/floating_view.dart';
import 'package:split_view/split_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusableActionDetector(
      shortcuts: ref.read(homeViewProvider).shortcuts,
      actions: ref.read(homeViewProvider).actions,
      autofocus: true,
      child: FloatingView(
        initialPosition: ref.read(homeViewProvider).savedLabelerPosition,
        onPositionChanged: ref.read(homeViewProvider).onLabelerPositionChanged,
        floatingWidget: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Card(
            elevation: 10,
            color: primaryColor.shade50,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                side: BorderSide(color: primaryColor.shade700, width: 2)),
            child: const LabelerView(),
          ),
        ),
        child: SplitView(
          viewMode: SplitViewMode.Horizontal,
          gripSize: splitViewGripSize,
          gripColor: splitViewGripColor,
          gripColorActive: splitViewGripColorActivate,
          controller: SplitViewController(weights: [.3, .7]),
          children: const [
            GalleryView(),
            DisplayView(),
          ],
        ),
      ),
    );
  }
}
