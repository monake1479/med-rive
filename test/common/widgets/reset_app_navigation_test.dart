import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/onboarding/use_cases/reset_app_use_case.dart';
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/use_cases/get_user_use_case.dart';
import 'package:med_rive/common/data/user/user_repository.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:med_rive/features/reset_app/state/reset_app_cubit.dart';
import 'package:med_rive/features/startup/state/startup_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/user_preferences.dart';

class _Flag extends Mock implements GetOnboardingStatusUseCase {}

class _Set extends Mock implements SetOnboardingStatusUseCase {}

class _Get extends Mock implements GetUserUseCase {}

class _Repo extends Mock implements UserRepository {}

class _Onboarding extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  for (final path in ['/breath-session', '/breath-plan?pace=8']) {
    testWidgets('confirmed reset from $path replaces routes with onboarding', (
      t,
    ) async {
      final flag = _Flag(),
          set = _Set(),
          get = _Get(),
          repo = _Repo(),
          onboarding = _Onboarding();
      var onboarded = true;
      when(repo.reset).thenAnswer((_) async {});
      final user = User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
      );
      when(flag.call).thenAnswer((_) async => onboarded);
      when(() => set(false)).thenAnswer((_) async {
        onboarded = false;
      });
      when(get.call).thenAnswer((_) async => user);
      whenListen(
        onboarding,
        const Stream<OnboardingState>.empty(),
        initialState: const OnboardingState(
          status: OnboardingStatus.inProgress,
        ),
      );
      final startup = StartupCubit(flag);
      getIt.registerSingleton(startup);
      getIt.registerSingleton<OnboardingBloc>(onboarding);
      getIt.registerFactory(
        () => BreathSessionCubit(get, successfulPaceWriter(), availablePaces()),
      );
      getIt.registerSingleton(ResetAppUseCase(set, repo));
      getIt.registerFactory(() => ResetAppCubit(getIt<ResetAppUseCase>()));
      final router = MedRiveRouter();
      router.router.go(path, extra: user);
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
      await t.pumpAndSettle();
      await t.tap(find.byIcon(Icons.refresh));
      await t.pumpAndSettle();
      await t.tap(find.widgetWithText(FilledButton, 'Reset'));
      await t.pumpAndSettle();
      expect(
        router.router.routeInformationProvider.value.uri.path,
        '/onboarding',
      );
      expect(router.router.canPop(), isFalse);
      expect(find.byType(AlertDialog), findsNothing);
      verify(() => set(false)).called(1);
      verify(repo.reset).called(1);

      await t.pumpWidget(const SizedBox());
      router.router.dispose();
      await startup.close();
      await onboarding.close();
      await getIt.reset();
    });
  }
}
