import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlideWidget extends StatelessWidget {
  final Key slideKey;
  final SlidableActionCallback? onSlidePressed;
  final Widget child;
  const SlideWidget({
    super.key,
    required this.slideKey,
    this.onSlidePressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: slideKey,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onSlidePressed,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Hapus',
          ),
        ],
      ),
      child: child,
    );
  }
}
