import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart';
import 'package:med_rive/features/startup/state/startup_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _Flag extends Mock implements GetOnboardingStatusUseCase {}

void main() {
  for (final onboarded in [false, true]) {
    test('startup checks onboarding; onboarded=$onboarded', () async {
      final flag = _Flag();
      final result = Completer<bool>();
      when(flag.call).thenAnswer((_) => result.future);
      final cubit = StartupCubit(flag);
      final starting = cubit.start();
      expect(cubit.state, StartupStatus.loading);
      verify(flag.call).called(1);
      result.complete(onboarded);
      await starting;
      expect(
        cubit.state,
        onboarded ? StartupStatus.ready : StartupStatus.onboarding,
      );
      await cubit.close();
    });
  }
  test('onboarding read failure allows retry', () async {
    final flag = _Flag();
    when(flag.call).thenThrow(StateError('read failed'));
    final cubit = StartupCubit(flag);
    await cubit.start();
    expect(cubit.state, StartupStatus.failure);
    when(flag.call).thenAnswer((_) async => true);
    await cubit.start();
    expect(cubit.state, StartupStatus.ready);
    await cubit.close();
  });
}
