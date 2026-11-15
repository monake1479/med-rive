// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Med Rive';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonRetry => 'Try again';

  @override
  String get onboardingPageTitle => 'Onboarding';

  @override
  String get onboardButtonLabel => 'Continue';

  @override
  String get breathSessionPageTitle => 'Breath Session';

  @override
  String get startBreathingLabel => 'Finish session';

  @override
  String get startupLoadingMessage =>
      'We’re loading your profile and checking whether this is your first visit.';

  @override
  String get startupFooter => 'A moment for yourself.';

  @override
  String get startupLoadingError =>
      'We couldn’t load your preferences. Please try again.';

  @override
  String get onboardingWelcomeUpperTitle => 'A LITTLE SPACE FOR YOU';

  @override
  String get onboardingWelcomeTitle => 'Make room to breathe.';

  @override
  String get onboardingWelcomeDescription =>
      'A moment of stillness.\nA rhythm that feels like yours.';

  @override
  String get onboardingRhythmUpperTitle => 'FIND YOUR OWN RHYTHM';

  @override
  String get onboardingRhythmTitle => 'A rhythm of your own.';

  @override
  String get onboardingRhythmDescription =>
      'Choose a pace. Watch the air respond.\nMake this moment yours.';

  @override
  String get onboardingFinishLabel => 'Find my rhythm';

  @override
  String get onboardingSaveError =>
      'We couldn’t save your progress. Please try again.';

  @override
  String onboardingPageIndicator(int page) {
    return 'Page $page of 2';
  }
}
