import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/shared/rive_scene_layout.dart';

class RibbonSceneDefinition {
  const RibbonSceneDefinition({
    required this.stage,
    required this.inputValue,
    required this.layout,
  });

  final RibbonStage stage;
  final int inputValue;
  final RiveSceneLayout layout;
}
