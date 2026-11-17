import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/onboarding_repository.dart';

@injectable
class SetOnboardingStatusUseCase {
  const SetOnboardingStatusUseCase(this._onboardingRepository);

  final OnboardingRepository _onboardingRepository;

  Future<void> call(bool onboarded) async =>
      await _onboardingRepository.set(onboarded);
}
