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
}
