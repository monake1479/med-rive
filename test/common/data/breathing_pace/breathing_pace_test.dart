import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/breathing_pace/breathing_pace_repository.dart';
import 'package:med_rive/common/data/breathing_pace/data_sources/breathing_pace_data_source.dart';
import 'package:med_rive/common/error_handling/breathing_pace_exceptions/breathing_pace_fetch_exception.dart';
import 'package:mocktail/mocktail.dart';

class _Source extends Mock implements BreathingPaceDataSource {}

void main() {
  test('mock response arrives after 500ms', () {
    fakeAsync((clock) {
      List<int>? result;
      unawaited(
        BreathingPaceDataSource().get().then((value) {
          result = value;
        }),
      );
      clock.elapse(const Duration(milliseconds: 499));
      expect(result, isNull);
      clock.elapse(const Duration(milliseconds: 1));
      expect(result, [6, 8, 10]);
    });
  });
  test('data source wraps failure with original cause and stack', () async {
    final cause = StateError('mock transport failed');
    final future = runZoned(
      () => BreathingPaceDataSource().get(),
      zoneSpecification: ZoneSpecification(
        createTimer: (self, parent, zone, duration, callback) {
          throw cause;
        },
      ),
    );
    await expectLater(
      future,
      throwsA(
        isA<BreathingPaceFetchException>().having(
          (e) => e.error,
          'cause',
          same(cause),
        ),
      ),
    );
  });
  test('repository caches successes and allows retry after failure', () async {
    final source = _Source();
    final repo = BreathingPaceRepository(source);
    when(source.get).thenAnswer((_) async => throw StateError('offline'));
    await expectLater(repo.get(), throwsStateError);
    when(source.get).thenAnswer((_) async => const [6, 8, 10]);
    expect(await repo.get(), [6, 8, 10]);
    expect(await repo.get(), [6, 8, 10]);
    verify(source.get).called(2);
  });
}
