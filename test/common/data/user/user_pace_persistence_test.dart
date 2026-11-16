import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/user/data_sources/user_remote_data_source.dart';
import 'package:med_rive/common/data/user/user_repository.dart';
import 'package:med_rive/common/error_handling/user_exceptions/user_update_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Prefs extends Mock implements SharedPreferencesAsync {}

T complete<T>(Future<T> Function() action) {
  late T result;
  Object? failure;
  fakeAsync((clock) {
    action().then(
      (value) => result = value,
      onError: (Object error, StackTrace stack) {
        failure = error;
      },
    );
    clock.elapse(const Duration(seconds: 3));
    clock.flushMicrotasks();
  });
  if (failure != null) Error.throwWithStackTrace(failure!, StackTrace.current);
  return result;
}

void main() {
  for (final pace in [6, 8, 10]) {
    test(
      'backend persists entire profile at $pace across new repositories and reset',
      () {
        final prefs = _Prefs();
        String? account;
        when(() => prefs.getString('mock_backend_user_profile'))
            .thenAnswer((_) async => account);
        when(() => prefs.setString('mock_backend_user_profile', any()))
            .thenAnswer((call) async {
              account = call.positionalArguments[1] as String;
            });
        final repository = UserRepository(UserRemoteDataSource(prefs));
        final initial = complete(repository.get);
        expect(initial.fullName, 'John Doe');
        expect(initial.breathsPerMinute, isNull);
        final saved = complete(() => repository.setPace(pace));
        expect(saved.breathsPerMinute, pace);
        final json = jsonDecode(account!) as Map<String, dynamic>;
        expect(json, containsPair('first_name', 'John'));
        expect(json, containsPair('last_name', 'Doe'));
        expect(json, containsPair('date_of_birth', '1994-05-12'));
        expect(json, containsPair('breaths_per_minute', pace));
        final restarted = UserRepository(UserRemoteDataSource(prefs));
        expect(complete(restarted.get).breathsPerMinute, pace);
        complete(restarted.reset);
        final afterReset = complete(
          UserRepository(UserRemoteDataSource(prefs)).get,
        );
        expect(afterReset.breathsPerMinute, isNull);
        expect(afterReset.fullName, initial.fullName);
      },
    );
  }
  test('backend failure leaves cached profile unchanged', () {
    final prefs = _Prefs();
    final json = jsonEncode({
      'first_name': 'John',
      'last_name': 'Doe',
      'date_of_birth': '1994-05-12',
      'breaths_per_minute': 8,
    });
    when(() => prefs.getString(any())).thenAnswer((_) async => json);
    when(() => prefs.setString(any(), any()))
        .thenAnswer((_) async => throw StateError('server write failed'));
    final repo = UserRepository(UserRemoteDataSource(prefs));
    final original = complete(repo.get);
    expect(
      () => complete(() => repo.setPace(10)),
      throwsA(isA<UserUpdateException>()),
    );
    expect(complete(repo.get), same(original));
    expect(original.breathsPerMinute, 8);
  });
}
