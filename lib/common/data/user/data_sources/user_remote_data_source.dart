import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/user/dtos/user_dto.dart';
import 'package:med_rive/common/error_handling/user_exceptions/user_fetch_exception.dart';
import 'package:med_rive/common/error_handling/user_exceptions/user_update_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class UserRemoteDataSource {
  UserRemoteDataSource(this._preferences);
  final SharedPreferencesAsync _preferences;
  static const _profileKey = 'mock_backend_user_profile';
  static const _initialUser = UserDto(
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '1994-05-12',
  );

  Future<UserDto> _readUser() async {
    final json = await _preferences.getString(_profileKey);
    if (json != null) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return UserDto.fromJson(data);
    }
    await _preferences.setString(
      _profileKey,
      jsonEncode(_initialUser.toJson()),
    );
    return _initialUser;
  }

  Future<UserDto> get() async {
    try {
      // This Future.delayed is provided only to imitate backend connection delay.
      await Future.delayed(const Duration(seconds: 2));
      return await _readUser();
    } catch (e, s) {
      Error.throwWithStackTrace(
        UserFetchException(e, 'Failed to fetch user profile.'),
        s,
      );
    }
  }

  Future<UserDto> updatePace(int? pace) async {
    try {
      // This Future.delayed is provided only to imitate backend connection delay.
      await Future.delayed(const Duration(seconds: 2));
      final currentUser = await _readUser();
      final user = UserDto(
        firstName: currentUser.firstName,
        lastName: currentUser.lastName,
        dateOfBirth: currentUser.dateOfBirth,
        breathsPerMinute: pace,
      );
      await _preferences.setString(_profileKey, jsonEncode(user.toJson()));
      return user;
    } catch (e, s) {
      Error.throwWithStackTrace(
        UserUpdateException(e, 'Failed to update user profile.'),
        s,
      );
    }
  }
}
