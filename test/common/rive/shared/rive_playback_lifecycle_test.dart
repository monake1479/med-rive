import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/rive/shared/widgets/rive_playback_lifecycle.dart';

void main() {
  testWidgets(
    'a newly attached playback callback receives the inactive state',
    (tester) async {
      final initialChanges = <bool>[];
      final loadedControllerChanges = <bool>[];
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      addTearDown(
        () => tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        ),
      );
      await tester.pumpWidget(
        RivePlaybackLifecycle(
          onActivityChanged: initialChanges.add,
          child: const SizedBox(),
        ),
      );
      expect(initialChanges, [false]);
      await tester.pumpWidget(
        RivePlaybackLifecycle(
          onActivityChanged: loadedControllerChanges.add,
          child: const SizedBox(),
        ),
      );
      expect(loadedControllerChanges, [false]);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(loadedControllerChanges, [false, true]);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
