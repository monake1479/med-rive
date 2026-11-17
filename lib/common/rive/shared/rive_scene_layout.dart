import 'dart:math' as math;
import 'dart:ui';

class RiveSceneLayout {
  const RiveSceneLayout({
    required this.artboardSize,
    required this.contentCenter,
    required this.contentSize,
  });

  final Size artboardSize;
  final Offset contentCenter;
  final Size contentSize;

  Rect fitInto(Rect targetRect) {
    final scale = math
        .min(
          targetRect.width / contentSize.width,
          targetRect.height / contentSize.height,
        )
        .clamp(.1, 1.3);
    return Rect.fromLTWH(
      targetRect.center.dx - contentCenter.dx * scale,
      targetRect.center.dy - contentCenter.dy * scale,
      artboardSize.width * scale,
      artboardSize.height * scale,
    );
  }
}
