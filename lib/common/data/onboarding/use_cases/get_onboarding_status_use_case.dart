import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/onboarding_repository.dart';

@injectable
class GetOnboardingStatusUseCase {
  const GetOnboardingStatusUseCase(this._onboardingRepository);

  final OnboardingRepository _onboardingRepository;

  Future<bool> call() async => await _onboardingRepository.isOnboarded();
}
