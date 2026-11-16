import 'package:equatable/equatable.dart';
import 'package:med_rive/common/data/user/dtos/user_dto.dart';

final class User extends Equatable {
  const User({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.breathsPerMinute,
  });
  factory User.fromDto(UserDto dto) {
    return User(
      firstName: dto.firstName,
      lastName: dto.lastName,
      dateOfBirth: DateTime.parse(dto.dateOfBirth),
      breathsPerMinute: dto.breathsPerMinute,
    );
  }
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final int? breathsPerMinute;

  User copyWith({int? breathsPerMinute}) => User(
    firstName: firstName,
    lastName: lastName,
    dateOfBirth: dateOfBirth,
    breathsPerMinute: breathsPerMinute ?? this.breathsPerMinute,
  );

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    dateOfBirth,
    breathsPerMinute,
  ];

  String get fullName => '$firstName $lastName';
  int ageAt(DateTime currentDate) {
    final birthdayPending =
        currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day);
    return currentDate.year - dateOfBirth.year - (birthdayPending ? 1 : 0);
  }
}
