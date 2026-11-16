import 'package:med_rive/common/data/breathing_pace/breathing_pace_repository.dart';
import 'package:med_rive/common/data/breathing_pace/data_sources/breathing_pace_data_source.dart';
import 'package:med_rive/common/data/breathing_pace/use_cases/get_breathing_paces_use_case.dart';
import 'package:med_rive/common/data/user/data_sources/user_remote_data_source.dart';
import 'package:med_rive/common/data/user/dtos/user_dto.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/use_cases/set_user_pace_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Preferences extends Mock implements SharedPreferencesAsync {}

class MemoryUserRemoteDataSource extends UserRemoteDataSource {
  MemoryUserRemoteDataSource() : super(_Preferences());
  UserDto user = const UserDto(
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '1994-05-12',
  );
  @override
  Future<UserDto> get() async => user;
  @override
  Future<UserDto> updatePace(int? pace) async => user = UserDto(
    firstName: user.firstName,
    lastName: user.lastName,
    dateOfBirth: user.dateOfBirth,
    breathsPerMinute: pace,
  );
}

GetBreathingPacesUseCase availablePaces() => GetBreathingPacesUseCase(
  BreathingPaceRepository(MemoryBreathingPaceDataSource()),
);

class MockSetPace extends Mock implements SetUserPaceUseCase {}

SetUserPaceUseCase successfulPaceWriter() {
  final useCase = MockSetPace();
  when(() => useCase(any())).thenAnswer(
    (call) async => User(
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1994, 5, 12),
      breathsPerMinute: call.positionalArguments.single as int,
    ),
  );
  return useCase;
}

class MemoryBreathingPaceDataSource extends BreathingPaceDataSource {
  @override
  Future<List<int>> get() async => const [6, 8, 10];
}
