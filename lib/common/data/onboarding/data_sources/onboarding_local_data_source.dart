import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_read_exception.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_write_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OnboardingLocalDataSource {
  OnboardingLocalDataSource(this._preferences);

  final SharedPreferencesAsync _preferences;

  static const _onboardedKey = 'user_onboarded';

  Future<bool> get() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      return await _preferences.getBool(_onboardedKey) ?? false;
    } catch (e, s) {
      log(
        'get method returned error during reading!',
        name: 'OnboardingLocalDataSource',
        stackTrace: s,
        error: e,
      );
      Error.throwWithStackTrace(LocalStorageReadException(e, e.toString()), s);
    }
  }

  Future<void> set(bool onboarding) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      await _preferences.setBool(_onboardedKey, onboarding);
    } catch (e, s) {
      log(
        'set method returned error during saving!',
        name: 'OnboardingLocalDataSource',
        stackTrace: s,
        error: e,
      );
      Error.throwWithStackTrace(LocalStorageWriteException(e, e.toString()), s);
    }
  }
}
