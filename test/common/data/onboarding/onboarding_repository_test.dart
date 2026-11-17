import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/onboarding/data_sources/onboarding_local_data_source.dart';
import 'package:med_rive/common/data/onboarding/onboarding_repository.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_read_exception.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_write_exception.dart';
import 'package:mocktail/mocktail.dart';

class _Source extends Mock implements OnboardingLocalDataSource {}

void main() {
  late _Source source;
  late OnboardingRepository repository;
  setUp(() {
    source = _Source();
    repository = OnboardingRepository(source);
  });

  for (final value in [true, false]) {
    test('caches $value, including a negative onboarding result', () async {
      when(source.get).thenAnswer((_) async => value);
      expect(await repository.isOnboarded(), value);
      expect(await repository.isOnboarded(), value);
      verify(source.get).called(1);
    });

    test('successful write caches $value without an additional read', () async {
      when(() => source.set(value)).thenAnswer((_) async {});
      await repository.set(value);
      expect(await repository.isOnboarded(), value);
      verify(() => source.set(value)).called(1);
      verifyNever(source.get);
    });
  }

  test('updates an already populated cache after a successful write', () async {
    when(source.get).thenAnswer((_) async => false);
    when(() => source.set(true)).thenAnswer((_) async {});
    expect(await repository.isOnboarded(), false);
    await repository.set(true);
    expect(await repository.isOnboarded(), true);
    verify(source.get).called(1);
  });

  test('does not expose an uncommitted write through the cache', () async {
    final write = Completer();
    when(source.get).thenAnswer((_) async => false);
    when(() => source.set(true)).thenAnswer((_) => write.future);
    await repository.isOnboarded();
    final pending = repository.set(true);
    expect(await repository.isOnboarded(), false);
    write.complete();
    await pending;
    expect(await repository.isOnboarded(), true);
  });

  test(
    'propagates a failed read and allows retry instead of caching it',
    () async {
      final error = LocalStorageReadException(StateError('read'));
      when(source.get).thenThrow(error);
      await expectLater(repository.isOnboarded(), throwsA(same(error)));
      when(source.get).thenAnswer((_) async => true);
      expect(await repository.isOnboarded(), true);
      expect(await repository.isOnboarded(), true);
      verify(source.get).called(2);
    },
  );

  test('propagates a failed write, preserves cache and allows retry', () async {
    final error = LocalStorageWriteException(StateError('write'));
    when(source.get).thenAnswer((_) async => false);
    await repository.isOnboarded();
    when(() => source.set(true)).thenThrow(error);
    await expectLater(repository.set(true), throwsA(same(error)));
    expect(await repository.isOnboarded(), false);
    when(() => source.set(true)).thenAnswer((_) async {});
    await repository.set(true);
    expect(await repository.isOnboarded(), true);
    verify(source.get).called(1);
  });

  test('failed write does not populate an empty cache', () async {
    final error = LocalStorageWriteException(StateError('write'));
    when(() => source.set(true)).thenThrow(error);
    await expectLater(repository.set(true), throwsA(same(error)));
    when(source.get).thenAnswer((_) async => false);
    expect(await repository.isOnboarded(), false);
    verify(source.get).called(1);
  });
}
