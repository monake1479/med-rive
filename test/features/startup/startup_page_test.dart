import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_read_exception.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_write_exception.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/breath_session/pages/breath_session_page.dart';
import 'package:med_rive/features/onboarding/pages/onboarding_page.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:med_rive/features/startup/pages/startup_page.dart';
import 'package:mocktail/mocktail.dart';

class _OnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  late _OnboardingBloc bloc;
  late StreamController<OnboardingState> states;
  late MedRiveRouter router;

  Future<void> mount(WidgetTester tester) async {
    bloc = _OnboardingBloc();
    states = StreamController<OnboardingState>.broadcast(sync: true);
    whenListen(bloc, states.stream, initialState: const OnboardingState());
    router = MedRiveRouter();
    await tester.pumpWidget(
      BlocProvider<OnboardingBloc>.value(
        value: bloc,
        child: MaterialApp.router(
          routerConfig: router.router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> emitState(WidgetTester tester, OnboardingState state) async {
    states.add(state);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
  }

  void flowTest(String name, Future<void> Function(WidgetTester) body) {
    testWidgets(name, (tester) async {
      await mount(tester);
      try {
        await body(tester);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await states.close();
        router.router.dispose();
      }
    });
  }

  flowTest('startup waits without building onboarding or session', (
    tester,
  ) async {
    expect(find.byType(StartupPage), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('startup-rive-slot'))).height,
      280,
    );
    expect(find.text('med rive'), findsOneWidget);
    expect(find.text('A moment for yourself.'), findsOneWidget);
    await emitState(
      tester,
      const OnboardingState(status: OnboardingStatus.loading),
    );
    await tester.pump(const Duration(seconds: 5));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(OnboardingPage), findsNothing);
    expect(find.byType(BreathSessionPage), findsNothing);
    expect(router.router.routeInformationProvider.value.uri.path, '/');
  });

  for (final onboarded in [true, false]) {
    flowTest('result $onboarded selects the route and replaces startup', (
      tester,
    ) async {
      await emitState(
        tester,
        OnboardingState(
          status: onboarded
              ? OnboardingStatus.completed
              : OnboardingStatus.inProgress,
        ),
      );
      expect(find.byType(StartupPage), findsNothing);
      expect(
        find.byType(OnboardingPage),
        onboarded ? findsNothing : findsOneWidget,
      );
      expect(
        find.byType(BreathSessionPage),
        onboarded ? findsOneWidget : findsNothing,
      );
      expect(
        router.router.routeInformationProvider.value.uri.path,
        onboarded ? '/breath-session' : '/onboarding',
      );
      expect(router.router.canPop(), isFalse);
      await tester.binding.handlePopRoute();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(StartupPage), findsNothing);
    });
  }

  flowTest('read failure shows an error and stays on startup', (tester) async {
    final error = LocalStorageReadException(
      StateError('read'),
      'Unable to read',
    );
    await emitState(
      tester,
      OnboardingState(status: OnboardingStatus.failure, exception: error),
    );
    expect(find.byType(StartupPage), findsOneWidget);
    expect(
      find.text('We couldn’t load your preferences. Please try again.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
    verify(() => bloc.add(const OnboardingStarted())).called(1);
    expect(find.byType(OnboardingPage), findsNothing);
    expect(find.byType(BreathSessionPage), findsNothing);
    expect(router.router.routeInformationProvider.value.uri.path, '/');
  });

  flowTest('finishing onboarding sends an event and waits for save success', (
    tester,
  ) async {
    await emitState(
      tester,
      const OnboardingState(status: OnboardingStatus.inProgress),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    verify(() => bloc.add(const SetOnboarding(true))).called(1);
    await emitState(
      tester,
      const OnboardingState(status: OnboardingStatus.loading),
    );
    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.byType(BreathSessionPage), findsNothing);
    expect(find.text('Loading...'), findsOneWidget);
    await emitState(
      tester,
      const OnboardingState(status: OnboardingStatus.completed),
    );
    expect(find.byType(BreathSessionPage), findsOneWidget);
    expect(find.byType(OnboardingPage), findsNothing);
    expect(router.router.canPop(), isFalse);
  });

  flowTest('failed persistence does not navigate to the session', (
    tester,
  ) async {
    await emitState(
      tester,
      const OnboardingState(status: OnboardingStatus.inProgress),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await emitState(
      tester,
      const OnboardingState(status: OnboardingStatus.loading),
    );
    await emitState(
      tester,
      OnboardingState(
        status: OnboardingStatus.failure,
        exception: LocalStorageWriteException(StateError('write')),
      ),
    );
    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.byType(BreathSessionPage), findsNothing);
    expect(
      router.router.routeInformationProvider.value.uri.path,
      '/onboarding',
    );
  });
}
