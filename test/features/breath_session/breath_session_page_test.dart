import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/use_cases/get_user_use_case.dart';
import 'package:med_rive/common/data/user/user_repository.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/fake_rive_ribbon_playback.dart';
import '../../utils/user_preferences.dart';

class _GetUser extends Mock implements GetUserUseCase {}

void main() {
  setUp(registerRibbonFlowCubit);
  tearDown(getIt.reset);
  for (final viewport in [const Size(448, 998), const Size(412, 915)]) {
    testWidgets('plan action stays at the bottom on $viewport', (tester) async {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      getIt.registerFactory<BreathSessionCubit>(
        () => BreathSessionCubit(
          GetUserUseCase(UserRepository(MemoryUserRemoteDataSource())),
          successfulPaceWriter(),
          availablePaces(),
        ),
      );
      final router = MedRiveRouter();
      addTearDown(router.router.dispose);
      router.router.go('/breath-session');
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router.router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();
      final footer = tester.getRect(
        find.text('Your selection shapes the next screen.'),
      );
      expect(footer.bottom, closeTo(viewport.height - 24, 1));
      expect(
        find.widgetWithText(FilledButton, 'See my plan').hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('picker waits for profile and first shows saved pace', (
    tester,
  ) async {
    final getUser = _GetUser();
    final profile = Completer<User>();
    when(getUser.call).thenAnswer((_) => profile.future);
    getIt.registerFactory<BreathSessionCubit>(
      () =>
          BreathSessionCubit(getUser, successfulPaceWriter(), availablePaces()),
    );
    addTearDown(getIt.reset);
    final router = MedRiveRouter();
    addTearDown(router.router.dispose);
    router.router.go('/breath-session');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pump();
    expect(find.byType(SegmentedButton<int>), findsNothing);
    final loadingHeight = tester
        .getSize(find.byType(LinearProgressIndicator))
        .height;
    expect(loadingHeight, greaterThan(0));
    profile.complete(
      User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
        breathsPerMinute: 10,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
          .selected,
      {10},
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('failed profile fetch can be retried without leaving the page', (
    tester,
  ) async {
    final getUser = _GetUser();
    when(getUser.call).thenAnswer((_) async => throw StateError('offline'));
    getIt.registerFactory<BreathSessionCubit>(
      () =>
          BreathSessionCubit(getUser, successfulPaceWriter(), availablePaces()),
    );
    addTearDown(getIt.reset);
    final router = MedRiveRouter();
    addTearDown(router.router.dispose);
    router.router.go('/breath-session');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('We couldn’t load your profile. Please try again.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'See my plan'),
          )
          .onPressed,
      isNull,
    );
    final retry = Completer<User>();
    when(getUser.call).thenAnswer((_) => retry.future);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(find.text('Try again'), findsNothing);
    retry.complete(
      User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
      ),
    );
    await tester.pumpAndSettle();
    verify(getUser.call).called(2);
    expect(
      find.text('We couldn’t load your profile. Please try again.'),
      findsNothing,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'See my plan'),
          )
          .onPressed,
      isNotNull,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('pace updates phases and opens summary before saving completes', (
    tester,
  ) async {
    final writer = MockSetPace();
    final pendingSave = Completer<User>();
    when(() => writer(10)).thenAnswer((_) => pendingSave.future);
    when(() => writer(6)).thenAnswer(
      (_) async => User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
        breathsPerMinute: 6,
      ),
    );
    getIt.registerFactory<BreathSessionCubit>(
      () => BreathSessionCubit(
        GetUserUseCase(UserRepository(MemoryUserRemoteDataSource())),
        writer,
        availablePaces(),
      ),
    );
    addTearDown(getIt.reset);
    final router = MedRiveRouter();
    addTearDown(router.router.dispose);
    router.router.go('/breath-session');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('5 sec inhale'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('breathing-rive-slot'))).height,
      inInclusiveRange(100, 248),
    );
    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();
    expect(find.text('3.75 sec inhale'), findsOneWidget);
    expect(find.text('3.75 sec exhale'), findsOneWidget);
    await tester.tap(find.text('10'));
    await tester.pumpAndSettle();
    expect(find.text('3 sec inhale'), findsOneWidget);
    await tester.ensureVisible(find.text('See my plan'));
    await tester.tap(find.text('See my plan'));
    await tester.pumpAndSettle();
    expect(find.text('Breathe in for 3 sec, out for 3 sec.'), findsOneWidget);
    verify(() => writer(10)).called(1);
    expect(pendingSave.isCompleted, isFalse);
    pendingSave.complete(
      User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
        breathsPerMinute: 10,
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Adjust my rhythm'));
    await tester.tap(find.text('Adjust my rhythm'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('6'));
    await tester.tap(find.text('6'));
    await tester.pumpAndSettle();
    expect(find.text('5 sec exhale'), findsOneWidget);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('See my plan'));
    await tester.tap(find.text('See my plan'));
    await tester.pumpAndSettle();
    expect(find.text('Breathe in for 5 sec, out for 5 sec.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('typed summary route preserves pace and profile on return', (
    tester,
  ) async {
    getIt.registerFactory<BreathSessionCubit>(
      () => BreathSessionCubit(
        GetUserUseCase(UserRepository(MemoryUserRemoteDataSource())),
        successfulPaceWriter(),
        availablePaces(),
      ),
    );
    addTearDown(getIt.reset);
    final router = MedRiveRouter();
    router.router.go('/breath-session');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('See my plan'));
    await tester.tap(find.text('See my plan'));
    await tester.pumpAndSettle();
    expect(find.text('Your rhythm, John.'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(
      find.text('Breathe in for 3.75 sec, out for 3.75 sec.'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Adjust my rhythm'));
    await tester.tap(find.text('Adjust my rhythm'));
    await tester.pumpAndSettle();
    expect(find.text('3.75 sec inhale'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    router.router.dispose();
  });
}
