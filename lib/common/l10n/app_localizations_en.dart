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
  String get ribbonLoadError => 'The animation couldn’t load.';

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
      'We’re preparing your experience and loading your profile.';

  @override
  String get startupFooter => 'A moment for yourself.';

  @override
  String get startupLoadingError =>
      'We couldn’t prepare your experience. Please try again.';

  @override
  String get onboardingWelcomeUpperTitle => 'A LITTLE SPACE FOR YOU';

  @override
  String get onboardingWelcomeTitle => 'Make room to breathe.';

  @override
  String get onboardingWelcomeDescription =>
      'A guided breathing space.\nFollow the ribbon, one breath at a time.';

  @override
  String get onboardingRhythmUpperTitle => 'FIND YOUR OWN RHYTHM';

  @override
  String get onboardingRhythmTitle => 'A rhythm of your own.';

  @override
  String get onboardingRhythmDescription =>
      'Choose your breathing pace.\nSee it come to life, then explore your plan.';

  @override
  String get onboardingFinishLabel => 'Find my rhythm';

  @override
  String get onboardingSaveError =>
      'We couldn’t save your progress. Please try again.';

  @override
  String onboardingPageIndicator(int page) {
    return 'Page $page of 2';
  }

  @override
  String get breathRhythmTitle => 'Your rhythm';

  @override
  String get breathFlowTitle => 'Find your flow.';

  @override
  String get breathFlowDescription => 'Change the pace. Watch the air respond.';

  @override
  String get breathPreviewLabel => 'LIVE PREVIEW';

  @override
  String get breathPaceLabel => 'Breaths per minute';

  @override
  String breathInhaleDuration(String seconds) {
    return '$seconds sec inhale';
  }

  @override
  String breathExhaleDuration(String seconds) {
    return '$seconds sec exhale';
  }

  @override
  String get breathSeePlan => 'See my plan';

  @override
  String get breathSelectionNote => 'Your selection shapes the next screen.';

  @override
  String get breathProfileLoading => 'Loading your profile…';

  @override
  String get breathProfileError =>
      'We couldn’t load your profile. Please try again.';

  @override
  String get planAppBarTitle => 'Your breathing plan';

  @override
  String planGreeting(String name) {
    return 'Your rhythm, $name.';
  }

  @override
  String planAge(int age) {
    return '$age years old';
  }

  @override
  String get planSelectedPace => 'YOUR BREATHING PACE';

  @override
  String get planPaceUnit => 'breaths / min';

  @override
  String planCycle(String seconds) {
    return 'Breathe in for $seconds sec, out for $seconds sec.';
  }

  @override
  String get planAdjust => 'Adjust my rhythm';

  @override
  String get planNote =>
      'A preview of your selected rhythm.\nAdjust the pace whenever you like.';

  @override
  String breathPhaseOption(String seconds) {
    return '${seconds}s in / out';
  }

  @override
  String get planSlowGuidance =>
      'Take your time. Follow the ring through each long, even breath.';

  @override
  String get planMediumGuidance =>
      'Find a steady flow. Keep your inhale and exhale even.';

  @override
  String get planFasterGuidance =>
      'Follow a lighter rhythm with short, even breathing phases.';

  @override
  String get resetAppTitle => 'Reset app';

  @override
  String get resetAppQuestion =>
      'Do you want to reset onboarding and restart the app?';

  @override
  String get resetAppDescription =>
      'Your selected pace and cached profile will be cleared. You’ll see the introduction again.';

  @override
  String get resetAppConfirm => 'Reset';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get resetAppError => 'We couldn’t reset the app. Please try again.';

  @override
  String get breathPaceSaveError =>
      'We couldn’t save your pace. Please try again.';

  @override
  String get breathPacesLoadError =>
      'We couldn’t load the available breathing paces. Please try again.';
}
