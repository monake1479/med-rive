import 'package:injectable/injectable.dart';
import 'package:med_rive/common/rive/shared/rive_asset_definition.dart';
import 'package:rive/rive.dart' as rive;

@injectable
class RiveAssetPlayer {
  rive.File? _riveFile;
  rive.RiveWidgetController? _riveController;
  RiveAssetDefinition? _definition;
  int _controllerRevision = 0;
  bool _isDisposed = false;

  rive.RiveWidgetController? get controller => _riveController;
  bool get isLoaded => _riveController != null;
  int get controllerRevision => _controllerRevision;

  Future<void> load(RiveAssetDefinition definition) async {
    if (_isDisposed || isLoaded) return;
    try {
      await rive.RiveNative.init();
      final decodedFile = await rive.File.asset(
        definition.assetPath,
        riveFactory: definition.riveFactory ?? rive.Factory.flutter,
      );
      if (decodedFile == null) {
        throw StateError('Could not decode ${definition.assetPath}.');
      }
      if (_isDisposed) {
        decodedFile.dispose();
        return;
      }
      _definition = definition;
      _riveFile = decodedFile;
      _createController();
    } catch (_) {
      unload();
      rethrow;
    }
  }

  void _createController() {
    final definition = _definition!;
    _riveController = rive.RiveWidgetController(
      _riveFile!,
      artboardSelector: rive.ArtboardNamed(definition.artboardName),
      stateMachineSelector: rive.StateMachineNamed(definition.stateMachineName),
    );
    _controllerRevision++;
  }

  void restart() {
    if (_isDisposed || _riveFile == null) return;
    _riveController?.dispose();
    _riveController = null;
    _createController();
  }

  void unload() {
    _riveController?.dispose();
    _riveController = null;
    _riveFile?.dispose();
    _riveFile = null;
    _definition = null;
  }

  void dispose() {
    _isDisposed = true;
    unload();
  }
}
