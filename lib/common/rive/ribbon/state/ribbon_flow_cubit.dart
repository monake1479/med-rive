import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/rive_ribbon_playback.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_state.dart';
import 'package:rive/rive.dart' as rive;

@injectable
class RibbonFlowCubit extends Cubit<RibbonFlowState> {
  RibbonFlowCubit(this._playback) : super(const RibbonFlowState()) {
    _bindingUpdatesSubscription = _playback.bindingUpdates.listen(
      (_) => _synchronizePlaybackState(),
      onError: _handlePlaybackError,
    );
  }

  final RiveRibbonPlayback _playback;
  late final StreamSubscription<void> _bindingUpdatesSubscription;
  Completer<void>? _contentChangeCompleter;

  rive.RiveWidgetController? get riveController => _playback.riveController;

  Future<void> initialize() async {
    if (isClosed ||
        state.loadStatus == RibbonLoadStatus.loading ||
        state.loadStatus == RibbonLoadStatus.ready) {
      return;
    }
    emit(
      state.copyWith(
        loadStatus: RibbonLoadStatus.loading,
        isTransitioning: true,
      ),
    );
    try {
      await _playback.load();
      _synchronizePlaybackState();
    } catch (error, stackTrace) {
      _handlePlaybackError(error, stackTrace);
    }
  }

  Future<void> showStage(RibbonStage stage) {
    if (isClosed) return Future.value();
    if (state.requestedStage == stage && _contentChangeCompleter != null) {
      return _contentChangeCompleter!.future;
    }
    _completeContentChange();
    emit(
      state.copyWith(
        requestedStage: stage,
        isTransitioning:
            state.loadStatus != RibbonLoadStatus.failure &&
            (state.isTransitioning || stage != state.visibleStage),
      ),
    );
    if (state.loadStatus == RibbonLoadStatus.failure) return Future.value();
    if (_playback.isLoaded && state.visibleStage == stage) {
      return Future.value();
    }
    final contentChangeCompleter = _contentChangeCompleter = Completer<void>();
    if (stage.index < state.visibleStage.index) {
      _playback.restoreIdleStage(stage);
      _synchronizePlaybackState();
    } else {
      _playback.requestStage(stage);
    }
    return contentChangeCompleter.future;
  }

  void setBreathingPace(int breathsPerMinute) =>
      _playback.setBreathingPace(breathsPerMinute);

  void restart() {
    if (isClosed) return;
    _completeContentChange();
    emit(state.copyWith(requestedStage: RibbonStage.startup));
    _playback.restart();
    _synchronizePlaybackState();
  }

  void _synchronizePlaybackState() {
    if (isClosed || !_playback.isLoaded) return;
    emit(
      state.copyWith(
        loadStatus: RibbonLoadStatus.ready,
        visibleStage: _playback.visibleStage,
        isTransitioning:
            _playback.isTransitioning ||
            _playback.visibleStage != state.requestedStage,
        activeBreathsPerMinute: _playback.activeBreathsPerMinute,
        controllerRevision: _playback.controllerRevision,
      ),
    );
    if (state.visibleStage == state.requestedStage) _completeContentChange();
  }

  void _handlePlaybackError(Object error, StackTrace stackTrace) {
    if (isClosed) return;
    addError(error, stackTrace);
    emit(
      state.copyWith(
        loadStatus: RibbonLoadStatus.failure,
        isTransitioning: false,
      ),
    );
    _completeContentChange();
  }

  void _completeContentChange() {
    _contentChangeCompleter?.complete();
    _contentChangeCompleter = null;
  }

  @override
  Future<void> close() async {
    final closeStateStream = super.close();
    _completeContentChange();
    await _bindingUpdatesSubscription.cancel();
    await _playback.dispose();
    await closeStateStream;
  }
}
