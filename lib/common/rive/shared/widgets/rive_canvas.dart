import 'package:flutter/widgets.dart';
import 'package:med_rive/common/rive/shared/rive_scene_layout.dart';
import 'package:rive/rive.dart' as rive;

class RiveCanvas extends StatelessWidget {
  const RiveCanvas({
    required this.controller,
    required this.layout,
    required this.targetRect,
    required this.layoutAnimationDuration,
    super.key,
  });

  final rive.RiveWidgetController controller;
  final RiveSceneLayout layout;
  final Rect targetRect;
  final Duration layoutAnimationDuration;

  @override
  Widget build(BuildContext context) {
    final canvasRect = layout.fitInto(targetRect);
    return ClipRect(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
            duration: layoutAnimationDuration,
            curve: Curves.easeInOutCubic,
            left: canvasRect.left,
            top: canvasRect.top,
            width: canvasRect.width,
            height: canvasRect.height,
            child: rive.RiveWidget(
              key: ObjectKey(controller),
              controller: controller,
              fit: rive.Fit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
