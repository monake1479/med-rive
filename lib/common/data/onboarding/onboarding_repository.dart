import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/data_sources/onboarding_local_data_source.dart';

@lazySingleton
class OnboardingRepository {
  OnboardingRepository(this._onboardingLocalDataSource);

  final OnboardingLocalDataSource _onboardingLocalDataSource;

  bool? _cachedOnboarded;

  Future<bool> isOnboarded() async {
    final cached = _cachedOnboarded;

    if (cached != null) {
      return cached;
    }

    final onboarded = await _onboardingLocalDataSource.get();
    _cachedOnboarded = onboarded;

    return onboarded;
  }

  Future<void> set(bool onboarded) async {
    await _onboardingLocalDataSource.set(onboarded);
    _cachedOnboarded = onboarded;
  }
}
