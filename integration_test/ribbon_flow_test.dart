import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/features/breath_session/pages/breath_plan_page.dart';
import 'package:med_rive/features/breath_session/pages/breath_session_page.dart';
import 'package:med_rive/features/onboarding/pages/onboarding_page.dart';
import 'package:med_rive/main.dart' as app;
import 'package:rive/rive.dart' as rive;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> waitFor(WidgetTester tester, bool Function() ready) async {
  for (var frame = 0; frame < 250; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (ready()) {
      // Rive publishes binding changes after painting; let the dependent UI
      // rebuild before tapping a button enabled by that notification.
      await tester.pump();
      return;
    }
  }
  fail('Timed out waiting for the Rive/UI handoff.');
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('real Rive survives onboarding, summary, return and reset', (
    tester,
  ) async {
    // This end-to-end scenario starts from a clean account on its test device.
    await SharedPreferencesAsync().clear();
    await app.main();
    await waitFor(
      tester,
      () => find.byType(OnboardingPage).evaluate().isNotEmpty,
    );
    final ribbonFlowCubit = tester
        .element(find.byType(OnboardingPage))
        .read<RibbonFlowCubit>();
    await waitFor(tester, () => !ribbonFlowCubit.state.isTransitioning);
    final renderer = ribbonFlowCubit.riveController;
    expect(renderer, isNotNull);
    await binding.takeScreenshot('onboarding');
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await waitFor(
      tester,
      () =>
          find.text('A rhythm of your own.').evaluate().isNotEmpty &&
          !ribbonFlowCubit.state.isTransitioning,
    );
    await tester.tap(find.byType(BackButton));
    await waitFor(
      tester,
      () =>
          find.text('Make room to breathe.').evaluate().isNotEmpty &&
          !ribbonFlowCubit.state.isTransitioning,
    );
    // Back restores the authored welcome idle; forward choreography is replayed.
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await waitFor(
      tester,
      () =>
          find.text('A rhythm of your own.').evaluate().isNotEmpty &&
          !ribbonFlowCubit.state.isTransitioning,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Find my rhythm'));
    await waitFor(
      tester,
      () =>
          find.byType(SegmentedButton<int>).evaluate().isNotEmpty &&
          !ribbonFlowCubit.state.isTransitioning,
    );
    expect(find.byType(BreathSessionPage), findsOneWidget);
    await binding.takeScreenshot('pace');
    final planRenderer = ribbonFlowCubit.riveController;
    expect(planRenderer, isNotNull);
    expect(
      tester.element(find.byType(BreathSessionPage)).read<RibbonFlowCubit>(),
      same(ribbonFlowCubit),
    );
    await tester.tap(find.text('8'));
    await waitFor(
      tester,
      () => ribbonFlowCubit.state.activeBreathsPerMinute == 8,
    );
    await tester.ensureVisible(find.text('See my plan'));
    await tester.tap(find.text('See my plan'));
    await waitFor(
      tester,
      () => find.byType(BreathPlanPage).evaluate().isNotEmpty,
    );
    expect(ribbonFlowCubit.riveController, same(planRenderer));
    expect(find.text('Your rhythm, John.'), findsOneWidget);
    await waitFor(tester, () {
      final canvas = tester.getRect(find.byType(rive.RiveWidget));
      final artworkCenter =
          canvas.topLeft + Offset(195, 333) * (canvas.width / 390);
      final slotCenter = tester.getCenter(
        find.byKey(const ValueKey('plan-rive-slot')),
      );
      return (artworkCenter - slotCenter).distance < 2;
    });
    await binding.takeScreenshot('summary');
    await tester.ensureVisible(find.text('Adjust my rhythm'));
    await tester.tap(find.text('Adjust my rhythm'));
    await waitFor(
      tester,
      () => find.byType(BreathSessionPage).evaluate().isNotEmpty,
    );
    expect(ribbonFlowCubit.riveController, same(planRenderer));
    expect(
      tester
          .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
          .selected,
      {8},
    );
    // Wait for the background account write before testing an account reset.
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
    await waitFor(
      tester,
      () =>
          find.byType(OnboardingPage).evaluate().isNotEmpty &&
          !ribbonFlowCubit.state.isTransitioning,
    );
    expect(
      tester.element(find.byType(OnboardingPage)).read<RibbonFlowCubit>(),
      same(ribbonFlowCubit),
    );
    expect(ribbonFlowCubit.riveController, isNot(same(planRenderer)));
    expect(tester.takeException(), isNull);
  });
}
