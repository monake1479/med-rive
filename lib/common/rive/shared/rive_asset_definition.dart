import 'package:rive/rive.dart' as rive;

class RiveAssetDefinition {
  const RiveAssetDefinition({
    required this.assetPath,
    required this.artboardName,
    required this.stateMachineName,
    this.riveFactory,
  });

  final String assetPath;
  final String artboardName;
  final String stateMachineName;

  final rive.Factory? riveFactory;
}
