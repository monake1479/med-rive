import 'dart:async';

import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/rive_ribbon_playback.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/common/rive/shared/rive_asset_player.dart';
import 'package:rive/rive.dart' as rive;

class FakeRiveRibbonPlayback extends RiveRibbonPlayback {
  FakeRiveRibbonPlayback({this.autoComplete = true, this.loadFailure})
    : super(RiveAssetPlayer());

  final bool autoComplete;
  Error? loadFailure;
  final List<RibbonStage> requests = [];
  final _testBindingUpdates = StreamController<void>.broadcast(sync: true);
  @override
  Stream<void> get bindingUpdates => _testBindingUpdates.stream;
  @override
  bool isLoaded = false;
  @override
  RibbonStage visibleStage = RibbonStage.startup;
  @override
  bool isTransitioning = false;
  @override
  int activeBreathsPerMinute = 6;
  @override
  int controllerRevision = 0;
  @override
  rive.RiveWidgetController? get riveController => null;

  @override
  Future<void> load() async {
    final failure = loadFailure;
    if (failure != null) throw failure;
    isLoaded = true;
    controllerRevision++;
    _testBindingUpdates.add(null);
  }

  @override
  void requestStage(RibbonStage stage) {
    requests.add(stage);
    isTransitioning = true;
    if (autoComplete) {
      visibleStage = stage;
      isTransitioning = false;
    }
    _testBindingUpdates.add(null);
  }

  void reportContentChange(RibbonStage stage) {
    visibleStage = stage;
    _testBindingUpdates.add(null);
  }

  void finishTransition() {
    isTransitioning = false;
    _testBindingUpdates.add(null);
  }

  void reportFailure(Object error) =>
      _testBindingUpdates.addError(error, StackTrace.current);

  @override
  void setBreathingPace(int breathsPerMinute) {
    activeBreathsPerMinute = breathsPerMinute;
    _testBindingUpdates.add(null);
  }

  @override
  void restart() {
    visibleStage = RibbonStage.startup;
    isTransitioning = false;
    activeBreathsPerMinute = 6;
    controllerRevision++;
    _testBindingUpdates.add(null);
  }

  @override
  void restoreIdleStage(RibbonStage stage) {
    visibleStage = stage;
    isTransitioning = false;
    controllerRevision++;
    _testBindingUpdates.add(null);
  }

  @override
  Future<void> dispose() async {
    await _testBindingUpdates.close();
    await super.dispose();
  }
}

void registerRibbonFlowCubit() => getIt.registerFactory<RibbonFlowCubit>(
  () => RibbonFlowCubit(FakeRiveRibbonPlayback()),
);
