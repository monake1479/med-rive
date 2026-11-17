import 'package:med_rive/common/error_handling/med_rive_exception.dart';

final class LocalStorageReadException extends MedRiveException {
  LocalStorageReadException(this.error, [super.message]);

  final Object error;

  @override
  String toString() {
    return 'LocalStorageReadException: $message';
  }
}
