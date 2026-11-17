import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_flow_shell.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/features/onboarding/pages/onboarding_page.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/fake_rive_ribbon_playback.dart';

class _Bloc extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  setUp(registerRibbonFlowCubit);
  tearDown(getIt.reset);
  testWidgets(
    'slides advance only by button; final action saves and failure allows retry',
    (tester) async {
      final bloc = _Bloc();
      final states = StreamController<OnboardingState>();
      whenListen(
        bloc,
        states.stream,
        initialState: const OnboardingState(
          status: OnboardingStatus.inProgress,
        ),
      );
      await tester.pumpWidget(
        BlocProvider<OnboardingBloc>.value(
          value: bloc,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const RibbonFlowShell(
              entryStage: RibbonStage.welcome,
              child: OnboardingPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Make room to breathe.'), findsOneWidget);
      await tester.drag(find.byType(PageView), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(find.text('Make room to breathe.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();
      verifyNever(() => bloc.add(const SetOnboarding(true)));
      expect(find.text('A rhythm of your own.'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Make room to breathe.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Find my rhythm'));
      verify(() => bloc.add(const SetOnboarding(true))).called(1);
      states.add(const OnboardingState(status: OnboardingStatus.loading));
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      states.add(const OnboardingState(status: OnboardingStatus.failure));
      await tester.pumpAndSettle();
      expect(
        find.text('We couldn’t save your progress. Please try again.'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Find my rhythm'));
      verify(() => bloc.add(const SetOnboarding(true))).called(1);
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await tester.pumpWidget(const SizedBox());
      await states.close();
      await bloc.close();
    },
  );
}
