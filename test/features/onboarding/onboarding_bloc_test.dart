import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_read_exception.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_write_exception.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOnboardingStatusUseCase extends Mock
    implements GetOnboardingStatusUseCase {}

class MockSetOnboardingStatusUseCase extends Mock
    implements SetOnboardingStatusUseCase {}

void main() {
  late MockGetOnboardingStatusUseCase getStatus;
  late MockSetOnboardingStatusUseCase setStatus;

  OnboardingBloc buildBloc() => OnboardingBloc(
    getOnboardingStatusUseCase: getStatus,
    setOnboardingStatusUseCase: setStatus,
  );

  setUp(() {
    getStatus = MockGetOnboardingStatusUseCase();
    setStatus = MockSetOnboardingStatusUseCase();
  });

  for (final value in [true, false]) {
    final expected = value
        ? OnboardingStatus.completed
        : OnboardingStatus.inProgress;
    blocTest<OnboardingBloc, OnboardingState>(
      'read $value emits loading then $expected',
      build: () {
        when(getStatus.call).thenAnswer((_) async => value);
        return buildBloc();
      },
      act: (bloc) => bloc.add(const OnboardingStarted()),
      expect: () => [
        const OnboardingState(status: OnboardingStatus.loading),
        OnboardingState(status: expected),
      ],
      verify: (_) => verify(getStatus.call).called(1),
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'write $value emits loading then $expected',
      build: () {
        when(() => setStatus(value)).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(SetOnboarding(value)),
      expect: () => [
        const OnboardingState(status: OnboardingStatus.loading),
        OnboardingState(status: expected),
      ],
      verify: (_) => verify(() => setStatus(value)).called(1),
    );
  }

  final readError = LocalStorageReadException(StateError('read'));
  final writeError = LocalStorageWriteException(StateError('write'));

  blocTest<OnboardingBloc, OnboardingState>(
    'read failure retains the specific exception and does not emit success',
    build: () {
      when(getStatus.call).thenThrow(readError);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const OnboardingStarted()),
    expect: () => [
      const OnboardingState(status: OnboardingStatus.loading),
      OnboardingState(status: OnboardingStatus.failure, exception: readError),
    ],
    errors: () => [same(readError)],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'write failure retains the specific exception and does not emit success',
    build: () {
      when(() => setStatus(true)).thenThrow(writeError);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SetOnboarding(true)),
    expect: () => [
      const OnboardingState(status: OnboardingStatus.loading),
      OnboardingState(status: OnboardingStatus.failure, exception: writeError),
    ],
    errors: () => [same(writeError)],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'retrying a failed read clears the exception during loading and success',
    build: () {
      when(getStatus.call).thenThrow(readError);
      return buildBloc();
    },
    act: (bloc) async {
      final failure = bloc.stream.firstWhere(
        (state) => state.status == OnboardingStatus.failure,
      );
      bloc.add(const OnboardingStarted());
      await failure;
      when(getStatus.call).thenAnswer((_) async => false);
      bloc.add(const OnboardingStarted());
    },
    expect: () => [
      const OnboardingState(status: OnboardingStatus.loading),
      OnboardingState(status: OnboardingStatus.failure, exception: readError),
      const OnboardingState(status: OnboardingStatus.loading),
      const OnboardingState(status: OnboardingStatus.inProgress),
    ],
    errors: () => [same(readError)],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'retrying a failed write clears the exception during loading and success',
    build: () {
      when(() => setStatus(true)).thenThrow(writeError);
      return buildBloc();
    },
    act: (bloc) async {
      final failure = bloc.stream.firstWhere(
        (state) => state.status == OnboardingStatus.failure,
      );
      bloc.add(const SetOnboarding(true));
      await failure;
      when(() => setStatus(true)).thenAnswer((_) async {});
      bloc.add(const SetOnboarding(true));
    },
    expect: () => [
      const OnboardingState(status: OnboardingStatus.loading),
      OnboardingState(status: OnboardingStatus.failure, exception: writeError),
      const OnboardingState(status: OnboardingStatus.loading),
      const OnboardingState(status: OnboardingStatus.completed),
    ],
    errors: () => [same(writeError)],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'write waits for an earlier read across different event types',
    build: buildBloc,
    act: (bloc) async {
      final read = Completer<bool>();
      final writeStarted = Completer();
      final write = Completer();
      when(getStatus.call).thenAnswer((_) => read.future);
      when(() => setStatus(true)).thenAnswer((_) {
        writeStarted.complete();
        return write.future;
      });
      final loading = bloc.stream.firstWhere((s) => s.status.isLoading);
      bloc
        ..add(const OnboardingStarted())
        ..add(const SetOnboarding(true));
      await loading;
      verifyNever(() => setStatus(true));
      read.complete(false);
      await writeStarted.future;
      write.complete();
    },
    expect: () => [
      const OnboardingState(status: OnboardingStatus.loading),
      const OnboardingState(status: OnboardingStatus.inProgress),
      const OnboardingState(status: OnboardingStatus.loading),
      const OnboardingState(status: OnboardingStatus.completed),
    ],
  );
}
