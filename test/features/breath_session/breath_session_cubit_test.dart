import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/use_cases/get_user_use_case.dart';
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/user_preferences.dart';

class _GetUser extends Mock implements GetUserUseCase {}

void main() {
  for (final storedPace in <int?>[null, 10]) {
    test(
      'profile load preserves explicit selection; stored pace=$storedPace',
      () async {
        final get = _GetUser();
        final pending = Completer<User>();
        when(get.call).thenAnswer((_) => pending.future);
        final cubit = BreathSessionCubit(get, MockSetPace(), availablePaces());
        await cubit.stream.firstWhere(
          (state) => state.pacesStatus == BreathingPacesStatus.ready,
        );
        cubit.setPace(8);
        final selectedPace = storedPace == null ? 8 : 6;
        cubit.setPace(selectedPace);
        pending.complete(
          User(
            firstName: 'John',
            lastName: 'Doe',
            dateOfBirth: DateTime(1994, 5, 12),
            breathsPerMinute: storedPace,
          ),
        );
        await cubit.stream.firstWhere(
          (state) => state.status == ProfileStatus.ready,
        );
        expect(cubit.state.pace, selectedPace);
        expect(cubit.state.user!.breathsPerMinute, storedPace);
        await cubit.close();
      },
    );
  }
  test(
    'selection is local and only confirmation saves; failed save can retry',
    () async {
      final get = _GetUser();
      final set = MockSetPace();
      final user = User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
        breathsPerMinute: 10,
      );
      when(get.call).thenAnswer((_) async => user);
      final cubit = BreathSessionCubit(get, set, availablePaces());
      await cubit.stream.firstWhere(
        (state) =>
            state.status == ProfileStatus.ready &&
            state.pacesStatus == BreathingPacesStatus.ready,
      );
      expect(cubit.state.pace, 10);
      final saving = Completer<User>();
      when(() => set(8)).thenAnswer((_) => saving.future);
      cubit.setPace(8);
      verifyNever(() => set(8));
      final request = cubit.savePace();
      expect(cubit.state.isSavingPace, isTrue);
      cubit.setPace(6);
      verifyNever(() => set(6));
      saving.completeError(StateError('disk'));
      await request;
      expect(cubit.state.pace, 8);
      expect(cubit.state.user, same(user));
      expect(cubit.state.paceSaveFailed, isTrue);
      when(() => set(8))
          .thenAnswer((_) async => user.copyWith(breathsPerMinute: 8));
      await cubit.savePace();
      expect(cubit.state.user!.breathsPerMinute, 8);
      expect(cubit.state.pace, 8);
      expect(cubit.state.paceSaveFailed, isFalse);
      await cubit.close();
    },
  );

  test(
    'selection survives pending profile load and a failure can be retried',
    () async {
      final get = _GetUser();
      final pending = Completer<User>();
      when(get.call).thenAnswer((_) => pending.future);
      final bloc = BreathSessionCubit(
        get,
        successfulPaceWriter(),
        availablePaces(),
      );
      await Future.delayed(Duration.zero);
      final loading = bloc.stream.firstWhere(
        (state) => state.status == ProfileStatus.failure,
      );
      bloc.setPace(8);
      pending.completeError(StateError('offline'));
      await loading;
      expect(bloc.state.status, ProfileStatus.failure);
      expect(bloc.state.pace, 8);
      final user = User(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1994, 5, 12),
        breathsPerMinute: 10,
      );
      when(get.call).thenAnswer((_) async => user);
      await bloc.loadUser();
      expect(bloc.state.user, same(user));
      expect(bloc.state.pace, 8);
      bloc.setPace(100);
      expect(bloc.state.pace, 8);
      await bloc.close();
    },
  );
}
