import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/user/data_sources/user_remote_data_source.dart';
import 'package:med_rive/common/data/user/dtos/user_dto.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/user_repository.dart';
import 'package:mocktail/mocktail.dart';

class _Source extends Mock implements UserRemoteDataSource {}

void main() {
  test('successful profile is reused from repository cache', () async {
    final source = _Source();
    when(source.get).thenAnswer(
      (_) async => const UserDto(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: '1994-05-12',
      ),
    );
    final repo = UserRepository(source);
    final users = [await repo.get(), await repo.get()];
    expect(users[0].fullName, 'John Doe');
    expect(identical(users[0], users[1]), isTrue);
    expect(await repo.get(), same(users[0]));
    verify(source.get).called(1);
  });
  test('failed fetch can be retried', () async {
    final source = _Source();
    when(source.get).thenAnswer((_) async => throw StateError('offline'));
    final repo = UserRepository(source);
    await expectLater(repo.get(), throwsStateError);
    when(source.get).thenAnswer(
      (_) async => const UserDto(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: '1994-05-12',
      ),
    );
    expect((await repo.get()).firstName, 'John');
    verify(source.get).called(2);
  });
  test('age respects birthday boundary', () {
    final user = User(
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1994, 5, 12),
    );
    expect(user.ageAt(DateTime(2026, 5, 11)), 31);
    expect(user.ageAt(DateTime(2026, 5, 12)), 32);
  });
}
