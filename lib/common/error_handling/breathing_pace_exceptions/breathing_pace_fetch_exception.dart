import 'package:med_rive/common/error_handling/med_rive_exception.dart';

final class BreathingPaceFetchException extends MedRiveException {
  BreathingPaceFetchException(this.error, [super.message]);
  final Object error;
  @override
  String toString() => 'BreathingPaceFetchException: $message';
}
