import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/user_repository.dart';

@injectable
class SetUserPaceUseCase {
  const SetUserPaceUseCase(this._repository);
  final UserRepository _repository;
  Future<User> call(int pace) => _repository.setPace(pace);
}
