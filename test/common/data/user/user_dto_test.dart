import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/data/user/dtos/user_dto.dart';

void main() {
  const profile = {
    'first_name': 'John',
    'last_name': 'Doe',
    'date_of_birth': '1994-05-12',
  };
  test('new account has no selected pace', () {
    const dto = UserDto(
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '1994-05-12',
    );
    expect(dto.breathsPerMinute, isNull);
    expect(dto.toJson()['breaths_per_minute'], isNull);
  });
  test('missing and null pace deserialize without a default', () {
    expect(UserDto.fromJson(profile).breathsPerMinute, isNull);
    expect(
      UserDto.fromJson({...profile, 'breaths_per_minute': null}).breathsPerMinute,
      isNull,
    );
  });
  test('selected pace survives JSON roundtrip and copyWith preserves it', () {
    final selected = UserDto.fromJson({...profile, 'breaths_per_minute': 8});
    expect(UserDto.fromJson(selected.toJson()).breathsPerMinute, 8);
    expect(selected.copyWith().breathsPerMinute, 8);
  });
}
