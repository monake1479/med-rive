import 'package:injectable/injectable.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_asset.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_bindings.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/shared/rive_asset_player.dart';
import 'package:med_rive/common/rive/shared/rive_binding_updates.dart';
import 'package:rive/rive.dart' as rive;

@injectable
class RiveRibbonPlayback {
  RiveRibbonPlayback(this._assetPlayer);

  static const _simulationFramesPerSecond = 60;
  static const _maximumIdleRestoreSeconds = 14;

  final RiveAssetPlayer _assetPlayer;
  final _bindingUpdates = RiveBindingUpdates();
  RibbonBindings? _bindings;
  RibbonStage _requestedStage = RibbonStage.startup;
  int _requestedBreathsPerMinute = 6;

  Stream<void> get bindingUpdates => _bindingUpdates.stream;
  bool get isLoaded => _bindings != null;
  RibbonStage get visibleStage =>
      _bindings?.visibleStage ?? RibbonStage.startup;
  bool get isTransitioning => _bindings?.isTransitioning ?? true;
  int get activeBreathsPerMinute => _bindings?.activeBreathsPerMinute ?? 0;
  int get controllerRevision => _assetPlayer.controllerRevision;
  rive.RiveWidgetController? get riveController => _assetPlayer.controller;

  Future<void> load() async {
    try {
      await _assetPlayer.load(ribbonAsset);
      if (_assetPlayer.controller != null && _bindings == null) {
        _attachBindings();
      }
    } catch (_) {
      _bindings?.dispose();
      _bindings = null;
      _assetPlayer.unload();
      rethrow;
    }
  }

  void _attachBindings() {
    _bindings = RibbonBindings(
      _assetPlayer.controller!,
      onChanged: _bindingUpdates.schedule,
    );
    _bindings!
      ..requestStage(_requestedStage)
      ..setBreathingPace(_requestedBreathsPerMinute);
  }

  void requestStage(RibbonStage stage) {
    _requestedStage = stage;
    _bindings?.requestStage(stage);
  }

  void setBreathingPace(int breathsPerMinute) {
    _requestedBreathsPerMinute = breathsPerMinute;
    _bindings?.setBreathingPace(breathsPerMinute);
  }

  void restart() {
    _requestedStage = RibbonStage.startup;
    _requestedBreathsPerMinute = 6;
    _bindings?.dispose();
    _bindings = null;
    _assetPlayer.restart();
    if (_assetPlayer.controller != null) _attachBindings();
    _bindingUpdates.schedule();
  }

  void restoreIdleStage(RibbonStage stage) {
    restart();
    requestStage(stage);
    final controller = riveController;
    if (controller == null) return;
    for (
      var frame = 0;
      frame < _maximumIdleRestoreSeconds * _simulationFramesPerSecond;
      frame++
    ) {
      controller.advance(1 / _simulationFramesPerSecond);
      if (visibleStage == stage && !isTransitioning) break;
    }
    _bindingUpdates.schedule();
  }

  Future<void> dispose() async {
    _bindings?.dispose();
    _bindings = null;
    _assetPlayer.dispose();
    await _bindingUpdates.close();
  }
}
