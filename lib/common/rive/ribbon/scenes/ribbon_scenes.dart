import 'dart:ui';

import 'package:med_rive/common/rive/ribbon/ribbon_asset.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/scenes/ribbon_scene_definition.dart';
import 'package:med_rive/common/rive/shared/rive_scene_layout.dart';

const ribbonScenes = [
  startupRibbonScene,
  welcomeRibbonScene,
  rhythmRibbonScene,
  planRibbonScene,
];

extension RibbonSceneConfiguration on RibbonStage {
  RibbonSceneDefinition get configuration =>
      ribbonScenes.singleWhere((scene) => scene.stage == this);
}

RibbonStage ribbonStageFromContentStep(int value) =>
    ribbonScenes.singleWhere((scene) => scene.inputValue == value).stage;

const startupRibbonScene = RibbonSceneDefinition(
  stage: RibbonStage.startup,
  inputValue: 0,
  layout: RiveSceneLayout(
    artboardSize: ribbonArtboardSize,
    contentCenter: Offset(195, 385),
    contentSize: Size(330, 190),
  ),
);
const welcomeRibbonScene = RibbonSceneDefinition(
  stage: RibbonStage.welcome,
  inputValue: 1,
  layout: RiveSceneLayout(
    artboardSize: ribbonArtboardSize,
    contentCenter: Offset(195, 277),
    contentSize: Size(330, 190),
  ),
);
const rhythmRibbonScene = RibbonSceneDefinition(
  stage: RibbonStage.rhythm,
  inputValue: 2,
  layout: RiveSceneLayout(
    artboardSize: ribbonArtboardSize,
    contentCenter: Offset(195, 285),
    contentSize: Size(330, 190),
  ),
);
const planRibbonScene = RibbonSceneDefinition(
  stage: RibbonStage.plan,
  inputValue: 3,
  layout: RiveSceneLayout(
    artboardSize: ribbonArtboardSize,
    contentCenter: Offset(195, 333),
    contentSize: Size(240, 240),
  ),
);
