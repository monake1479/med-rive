import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:med_rive/common/error_handling/breathing_pace_exceptions/breathing_pace_fetch_exception.dart';

@lazySingleton
class BreathingPaceDataSource {
  Future<List<int>> get() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const [6, 8, 10];
    } catch (e, s) {
      log(
        'Failed to fetch breathing paces.',
        name: 'BreathingPaceDataSource',
        error: e,
        stackTrace: s,
      );
      Error.throwWithStackTrace(BreathingPaceFetchException(e), s);
    }
  }
}
