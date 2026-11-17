import 'package:med_rive/common/error_handling/med_rive_exception.dart';

final class LocalStorageWriteException extends MedRiveException {
  LocalStorageWriteException(this.error, [super.message]);

  final Object error;

  @override
  String toString() {
    return 'LocalStorageWriteException: $message';
  }
}
