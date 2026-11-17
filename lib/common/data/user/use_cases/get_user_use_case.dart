import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/user_repository.dart';

@injectable
class GetUserUseCase {
  const GetUserUseCase(this._repository);
  final UserRepository _repository;
  Future<User> call() async => await _repository.get();
}
