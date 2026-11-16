import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/use_cases/get_user_use_case.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:med_rive/features/startup/state/startup_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/user_preferences.dart';

class _Status extends Mock implements GetOnboardingStatusUseCase {}

class _User extends Mock implements GetUserUseCase {}

class _Onboarding extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  for (final onboarded in [false, true]) {
    testWidgets(
      'startup navigates without waiting for profile; onboarded=$onboarded',
      (t) async {
        final flag = _Status(), getUser = _User(), onboarding = _Onboarding();
        final profile = Completer<User>();
        when(flag.call).thenAnswer((_) async => onboarded);
        when(getUser.call).thenAnswer((_) => profile.future);
        whenListen(
          onboarding,
          const Stream<OnboardingState>.empty(),
          initialState: const OnboardingState(
            status: OnboardingStatus.inProgress,
          ),
        );
        final startups = <StartupCubit>[];
        getIt.registerFactory<StartupCubit>(() {
          final cubit = StartupCubit(flag);
          startups.add(cubit);
          return cubit;
        });
        getIt.registerFactory(
          () => BreathSessionCubit(
            getUser,
            successfulPaceWriter(),
            availablePaces(),
          ),
        );
        final router = MedRiveRouter();
        await t.pumpWidget(
          BlocProvider<OnboardingBloc>.value(
            value: onboarding,
            child: MaterialApp.router(
              routerConfig: router.router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await t.pump();
        await t.pump(const Duration(seconds: 1));
        await t.pump(const Duration(seconds: 1));
        expect(
          router.router.routeInformationProvider.value.uri.path,
          onboarded ? '/breath-session' : '/onboarding',
        );
        if (onboarded) {
          verify(getUser.call).called(1);
        } else {
          verifyNever(getUser.call);
        }
        profile.complete(
          User(
            firstName: 'John',
            lastName: 'Doe',
            dateOfBirth: DateTime(1994, 5, 12),
          ),
        );
        await t.pump();
        await t.pump(const Duration(seconds: 1));
        await t.pump(const Duration(seconds: 1));
        expect(
          router.router.routeInformationProvider.value.uri.path,
          onboarded ? '/breath-session' : '/onboarding',
        );
        if (onboarded) {
          expect(find.text('Find your flow.'), findsOneWidget);
          expect(find.text('Loading your profile…'), findsNothing);
        }
        expect(startups.single.isClosed, isTrue);
        when(flag.call).thenAnswer((_) async => false);
        const StartupRoute().go(t.element(find.byType(Scaffold).first));
        await t.pumpAndSettle();
        expect(startups, hasLength(2));
        expect(
          router.router.routeInformationProvider.value.uri.path,
          '/onboarding',
        );
        expect(t.takeException(), isNull);
        await t.pumpWidget(const SizedBox());
        router.router.dispose();

        await onboarding.close();
        await getIt.reset();
      },
    );
  }
}
