import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FloatingView extends HookWidget {
  final Widget child;
  final Widget floatingWidget;
  final Offset initialPosition;

  const FloatingView({
    super.key,
    required this.floatingWidget,
    required this.child,
    this.initialPosition = const Offset(100, 100),
  });

  @override
  Widget build(BuildContext context) {
    var pos = useState(initialPosition);

    void setPosition(Offset position) {
      var box = context.findRenderObject() as RenderBox;
      var offset = box.localToGlobal(Offset.zero);
      pos.value = position - offset;
    }

    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          left: pos.value.dx,
          top: pos.value.dy,
          child: Draggable(
            feedback: floatingWidget,
            onDragEnd: (details) => setPosition(details.offset),
            childWhenDragging: const SizedBox.shrink(),
            child: floatingWidget,
          ),
        ),
      ],
    );
  }
}
