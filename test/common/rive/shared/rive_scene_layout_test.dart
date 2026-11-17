import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/scenes/ribbon_scenes.dart';

void main() {
  test('each ribbon stage has one scene with a unique exported value', () {
    expect(
      ribbonScenes.map((scene) => scene.stage).toSet(),
      RibbonStage.values.toSet(),
    );
    expect(
      ribbonScenes.map((scene) => scene.stage).toList(),
      hasLength(RibbonStage.values.length),
    );
    expect(
      ribbonScenes.map((scene) => scene.inputValue).toSet(),
      hasLength(ribbonScenes.length),
    );
    for (final scene in ribbonScenes) {
      expect(ribbonStageFromContentStep(scene.inputValue), scene.stage);
    }
  });

  test(
    'each scene stays centered in its slot and preserves artboard proportions',
    () {
      const targetRect = Rect.fromLTWH(24, 180, 327, 184);
      for (final scene in ribbonScenes) {
        final layout = scene.layout;
        final canvasRect = layout.fitInto(targetRect);
        final scale = canvasRect.width / layout.artboardSize.width;
        final contentCenter = canvasRect.topLeft + layout.contentCenter * scale;
        expect((contentCenter - targetRect.center).distance, lessThan(.001));
        expect(
          canvasRect.width / canvasRect.height,
          closeTo(layout.artboardSize.aspectRatio, .001),
        );
        expect(
          layout.contentSize.height * scale,
          lessThanOrEqualTo(targetRect.height + .001),
        );
        expect(
          layout.contentSize.width * scale,
          lessThanOrEqualTo(targetRect.width + .001),
        );
      }
    },
  );
}
