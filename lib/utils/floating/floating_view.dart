import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FloatingView extends HookWidget {
  final Widget child;
  final Widget floatingWidget;
  final Offset initialPosition;
  final void Function(Offset localPosition)? onPositionChanged;

  const FloatingView({
    super.key,
    required this.floatingWidget,
    required this.child,
    this.onPositionChanged,
    this.initialPosition = const Offset(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    var pos = useState(initialPosition);

    void onDragEnd(Offset globalPos) {
      var box = context.findRenderObject() as RenderBox;
      var offset = box.localToGlobal(Offset.zero);
      var localPos = globalPos - offset;

      onPositionChanged?.call(localPos);
      pos.value = localPos;
    }

    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          left: pos.value.dx,
          top: pos.value.dy,
          child: Draggable(
            feedback: floatingWidget,
            onDragEnd: (details) => onDragEnd(details.offset),
            childWhenDragging: const SizedBox.shrink(),
            child: floatingWidget,
          ),
        ),
      ],
    );
  }
}
