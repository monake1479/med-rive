import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/onboarding/use_cases/reset_app_use_case.dart';
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/user/user_repository.dart';
import 'package:mocktail/mocktail.dart';

class _Set extends Mock implements SetOnboardingStatusUseCase {}

class _Users extends Mock implements UserRepository {}

void main() {
  test('reset saves false before clearing profile', () async {
    final set = _Set(), users = _Users();
    when(users.reset).thenAnswer((_) async {});
    when(() => set(false)).thenAnswer((_) async {});
    await ResetAppUseCase(set, users)();
    verifyInOrder([() => set(false), users.reset]);
  });
  test('failed persistence leaves profile cache intact', () async {
    final set = _Set(), users = _Users();
    when(users.reset).thenAnswer((_) async {});
    when(() => set(false)).thenAnswer((_) async => throw StateError('disk'));
    await expectLater(ResetAppUseCase(set, users)(), throwsStateError);
    verifyNever(users.reset);
  });
}
