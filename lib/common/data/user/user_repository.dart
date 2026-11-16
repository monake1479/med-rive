import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/user/data_sources/user_remote_data_source.dart';
import 'package:med_rive/common/data/user/models/user.dart';

@lazySingleton
class UserRepository {
  UserRepository(this._userRemoteDataSource);
  final UserRemoteDataSource _userRemoteDataSource;
  User? _cachedUser;

  void clearCache() => _cachedUser = null;

  Future<User> get() async {
    final cached = _cachedUser;
    if (cached != null) {
      return cached;
    }

    final dto = await _userRemoteDataSource.get();
    final user = User.fromDto(dto);
    _cachedUser = user;
    return user;
  }

  Future<void> reset() async {
    await _userRemoteDataSource.updatePace(null);
    clearCache();
  }

  Future<User> setPace(int pace) async {
    final response = await _userRemoteDataSource.updatePace(pace);
    final updated = User.fromDto(response);
    _cachedUser = updated;
    return updated;
  }
}
