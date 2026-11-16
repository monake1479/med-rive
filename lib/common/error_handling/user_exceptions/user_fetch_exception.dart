import 'package:med_rive/common/error_handling/med_rive_exception.dart';

final class UserFetchException extends MedRiveException {
  UserFetchException(this.error, [super.message]);

  final Object error;

  @override
  String toString() => 'UserFetchException: $message';
}
