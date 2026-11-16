import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/onboarding/data_sources/onboarding_local_data_source.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_read_exception.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_write_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Preferences extends Mock implements SharedPreferencesAsync {}

void main() {
  late _Preferences preferences;
  late OnboardingLocalDataSource source;

  setUp(() {
    preferences = _Preferences();
    source = OnboardingLocalDataSource(preferences);
  });

  for (final stored in <bool?>[null, false, true]) {
    test('reads $stored as ${stored ?? false}', () {
      fakeAsync((clock) {
        when(() => preferences.getBool('user_onboarded'))
            .thenAnswer((_) async => stored);
        bool? result;
        unawaited(source.get().then((value) => result = value));
        clock.elapse(const Duration(seconds: 2));
        clock.flushMicrotasks();
        verify(() => preferences.getBool('user_onboarded')).called(1);
        expect(result, stored ?? false);
      });
    });
  }

  for (final value in [true, false]) {
    test('persists $value under the onboarding key', () {
      fakeAsync((clock) {
        when(() => preferences.setBool('user_onboarded', value))
            .thenAnswer((_) async {});
        var completed = false;
        unawaited(source.set(value).then((_) => completed = true));
        clock.elapse(const Duration(seconds: 2));
        clock.flushMicrotasks();
        verify(() => preferences.setBool('user_onboarded', value)).called(1);
        expect(completed, isTrue);
      });
    });
  }

  test('wraps a read failure and preserves its cause and stack trace', () {
    fakeAsync((clock) {
      final cause = PlatformException(code: 'read_failed');
      final trace = StackTrace.fromString('platform read stack');
      when(() => preferences.getBool('user_onboarded'))
          .thenAnswer((_) => Future<bool?>.error(cause, trace));
      Object? caught;
      StackTrace? caughtTrace;
      source.get().then(
        (_) => fail('Expected a read failure'),
        onError: (Object error, StackTrace stack) {
          caught = error;
          caughtTrace = stack;
        },
      );
      clock.elapse(const Duration(seconds: 2));
      clock.flushMicrotasks();
      expect(
        caught,
        isA<LocalStorageReadException>().having(
          (e) => e.error,
          'cause',
          same(cause),
        ),
      );
      expect(caughtTrace.toString(), trace.toString());
    });
  });

  test('wraps a write failure and preserves its cause and stack trace', () {
    fakeAsync((clock) {
      final cause = PlatformException(code: 'write_failed');
      final trace = StackTrace.fromString('platform write stack');
      when(() => preferences.setBool('user_onboarded', true))
          .thenAnswer((_) => Future.error(cause, trace));
      Object? caught;
      StackTrace? caughtTrace;
      source
          .set(true)
          .then(
            (_) => fail('Expected a write failure'),
            onError: (Object error, StackTrace stack) {
              caught = error;
              caughtTrace = stack;
            },
          );
      clock.elapse(const Duration(seconds: 2));
      clock.flushMicrotasks();
      expect(
        caught,
        isA<LocalStorageWriteException>().having(
          (e) => e.error,
          'cause',
          same(cause),
        ),
      );
      expect(caughtTrace.toString(), trace.toString());
    });
  });
}
