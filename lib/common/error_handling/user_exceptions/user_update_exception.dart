import 'package:med_rive/common/error_handling/med_rive_exception.dart';

final class UserUpdateException extends MedRiveException {
  UserUpdateException(this.error, [super.message]);
  final Object error;
  @override
  String toString() => 'UserUpdateException: $message';
}
