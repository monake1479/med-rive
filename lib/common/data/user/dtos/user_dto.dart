class UserDto {
  const UserDto({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.breathsPerMinute,
  });
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    dateOfBirth: json['date_of_birth'] as String,
    breathsPerMinute: (json['breaths_per_minute'] as num?)?.toInt(),
  );
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final int? breathsPerMinute;
  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'date_of_birth': dateOfBirth,
    'breaths_per_minute': breathsPerMinute,
  };
  UserDto copyWith({int? breathsPerMinute}) => UserDto(
    firstName: firstName,
    lastName: lastName,
    dateOfBirth: dateOfBirth,
    breathsPerMinute: breathsPerMinute ?? this.breathsPerMinute,
  );
}
