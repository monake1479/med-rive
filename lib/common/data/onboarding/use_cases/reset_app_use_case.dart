import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/user/user_repository.dart';

@injectable
class ResetAppUseCase {
  const ResetAppUseCase(this._setOnboardingStatusUseCase, this._userRepository);
  final SetOnboardingStatusUseCase _setOnboardingStatusUseCase;
  final UserRepository _userRepository;

  Future<void> call() async {
    await Future.wait([
      _setOnboardingStatusUseCase(false),
      _userRepository.reset(),
    ]);
  }
}
