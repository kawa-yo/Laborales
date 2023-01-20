import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TagView extends HookWidget {
  final String tag;
  final bool isSelected;
  final void Function()? onTap;
  const TagView({
    super.key,
    required this.tag,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var onHover = useState(false);
    return MouseRegion(
      onEnter: (_) => onHover.value = true,
      onExit: (_) => onHover.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            onHover.value ? Colors.grey.withAlpha(50) : Colors.transparent,
            BlendMode.plus,
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green[100] : Colors.grey[100],
              border: Border.all(
                width: 2,
                color: isSelected ? Colors.green[300]! : Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Text(tag, style: Theme.of(context).textTheme.titleSmall),
          ),
        ),
      ),
    );
  }
}
