import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_state.dart';

import '../../utils/fake_rive_ribbon_playback.dart';

void main() {
  test(
    'navigation completes at content change while transition continues',
    () async {
      final playback = FakeRiveRibbonPlayback(autoComplete: false);
      final cubit = RibbonFlowCubit(playback);
      addTearDown(cubit.close);
      await cubit.initialize();
      var contentChanged = false;
      final transition = cubit.showStage(RibbonStage.welcome);
      unawaited(transition.then((_) => contentChanged = true));
      await Future<void>.delayed(Duration.zero);
      expect(contentChanged, false);
      expect(cubit.state.isTransitioning, true);
      playback.reportContentChange(RibbonStage.welcome);
      await transition;
      expect(contentChanged, true);
      expect(cubit.state.isTransitioning, true);
      playback.finishTransition();
      expect(cubit.state.isTransitioning, false);
    },
  );

  test(
    'duplicate request shares a future; back restores the authored idle',
    () async {
      final playback = FakeRiveRibbonPlayback(autoComplete: false);
      final cubit = RibbonFlowCubit(playback);
      addTearDown(cubit.close);
      await cubit.initialize();
      final first = cubit.showStage(RibbonStage.rhythm);
      final duplicate = cubit.showStage(RibbonStage.rhythm);
      expect(identical(first, duplicate), true);
      expect(playback.requests, [RibbonStage.rhythm]);
      playback.reportContentChange(RibbonStage.rhythm);
      playback.finishTransition();
      await first;
      await cubit.showStage(RibbonStage.welcome);
      expect(cubit.state.visibleStage, RibbonStage.welcome);
    },
  );

  test('failure releases navigation and loading can be retried', () async {
    final playback = FakeRiveRibbonPlayback(
      loadFailure: StateError('missing file'),
    );
    final cubit = RibbonFlowCubit(playback);
    addTearDown(cubit.close);
    final pending = cubit.showStage(RibbonStage.plan);
    await cubit.initialize();
    await pending;
    expect(cubit.state.loadStatus, RibbonLoadStatus.failure);
    expect(cubit.state.isTransitioning, false);
    playback.loadFailure = null;
    await cubit.initialize();
    expect(cubit.state.loadStatus, RibbonLoadStatus.ready);
    await cubit.showStage(RibbonStage.plan);
    expect(cubit.state.visibleStage, RibbonStage.plan);
  });

  test('a playback stream error releases pending navigation', () async {
    final playback = FakeRiveRibbonPlayback(autoComplete: false);
    final cubit = RibbonFlowCubit(playback);
    addTearDown(cubit.close);
    await cubit.initialize();
    final pending = cubit.showStage(RibbonStage.plan);
    playback.reportFailure(StateError('binding stream failed'));
    await pending;
    expect(cubit.state.loadStatus, RibbonLoadStatus.failure);
    expect(cubit.state.isTransitioning, false);
  });

  test(
    'restart restores defaults and publishes controller replacement',
    () async {
      final playback = FakeRiveRibbonPlayback();
      final cubit = RibbonFlowCubit(playback);
      addTearDown(cubit.close);
      await cubit.initialize();
      await cubit.showStage(RibbonStage.plan);
      cubit.setBreathingPace(10);
      expect(cubit.state.activeBreathsPerMinute, 10);
      final previousRevision = cubit.state.controllerRevision;
      cubit.restart();
      expect(cubit.state.visibleStage, RibbonStage.startup);
      expect(cubit.state.activeBreathsPerMinute, 6);
      expect(cubit.state.controllerRevision, greaterThan(previousRevision));
    },
  );

  test(
    'closing releases a pending transition and cancels the subscription',
    () async {
      final playback = FakeRiveRibbonPlayback(autoComplete: false);
      final cubit = RibbonFlowCubit(playback);
      await cubit.initialize();
      final pending = cubit.showStage(RibbonStage.plan);
      await cubit.close();
      await pending;
      expect(cubit.isClosed, true);
    },
  );
}
