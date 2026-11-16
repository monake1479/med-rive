import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Med Rive'**
  String get appName;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @onboardingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboardingPageTitle;

  /// No description provided for @onboardButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardButtonLabel;

  /// No description provided for @breathSessionPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Breath Session'**
  String get breathSessionPageTitle;

  /// No description provided for @startBreathingLabel.
  ///
  /// In en, this message translates to:
  /// **'Finish session'**
  String get startBreathingLabel;

  /// No description provided for @startupLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'We’re preparing your experience and loading your profile.'**
  String get startupLoadingMessage;

  /// No description provided for @startupFooter.
  ///
  /// In en, this message translates to:
  /// **'A moment for yourself.'**
  String get startupFooter;

  /// No description provided for @startupLoadingError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t prepare your experience. Please try again.'**
  String get startupLoadingError;

  /// No description provided for @onboardingWelcomeUpperTitle.
  ///
  /// In en, this message translates to:
  /// **'A LITTLE SPACE FOR YOU'**
  String get onboardingWelcomeUpperTitle;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Make room to breathe.'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'A guided breathing space.\nFollow the ribbon, one breath at a time.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingRhythmUpperTitle.
  ///
  /// In en, this message translates to:
  /// **'FIND YOUR OWN RHYTHM'**
  String get onboardingRhythmUpperTitle;

  /// No description provided for @onboardingRhythmTitle.
  ///
  /// In en, this message translates to:
  /// **'A rhythm of your own.'**
  String get onboardingRhythmTitle;

  /// No description provided for @onboardingRhythmDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your breathing pace.\nSee it come to life, then explore your plan.'**
  String get onboardingRhythmDescription;

  /// No description provided for @onboardingFinishLabel.
  ///
  /// In en, this message translates to:
  /// **'Find my rhythm'**
  String get onboardingFinishLabel;

  /// No description provided for @onboardingSaveError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t save your progress. Please try again.'**
  String get onboardingSaveError;

  /// No description provided for @onboardingPageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of 2'**
  String onboardingPageIndicator(int page);

  /// No description provided for @breathRhythmTitle.
  ///
  /// In en, this message translates to:
  /// **'Your rhythm'**
  String get breathRhythmTitle;

  /// No description provided for @breathFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your flow.'**
  String get breathFlowTitle;

  /// No description provided for @breathFlowDescription.
  ///
  /// In en, this message translates to:
  /// **'Change the pace. Watch the air respond.'**
  String get breathFlowDescription;

  /// No description provided for @breathPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'LIVE PREVIEW'**
  String get breathPreviewLabel;

  /// No description provided for @breathPaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Breaths per minute'**
  String get breathPaceLabel;

  /// No description provided for @breathInhaleDuration.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec inhale'**
  String breathInhaleDuration(String seconds);

  /// No description provided for @breathExhaleDuration.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec exhale'**
  String breathExhaleDuration(String seconds);

  /// No description provided for @breathSeePlan.
  ///
  /// In en, this message translates to:
  /// **'See my plan'**
  String get breathSeePlan;

  /// No description provided for @breathSelectionNote.
  ///
  /// In en, this message translates to:
  /// **'Your selection shapes the next screen.'**
  String get breathSelectionNote;

  /// No description provided for @breathProfileLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading your profile…'**
  String get breathProfileLoading;

  /// No description provided for @breathProfileError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load your profile. Please try again.'**
  String get breathProfileError;

  /// No description provided for @planAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Your breathing plan'**
  String get planAppBarTitle;

  /// No description provided for @planGreeting.
  ///
  /// In en, this message translates to:
  /// **'Your rhythm, {name}.'**
  String planGreeting(String name);

  /// No description provided for @planAge.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String planAge(int age);

  /// No description provided for @planSelectedPace.
  ///
  /// In en, this message translates to:
  /// **'YOUR BREATHING PACE'**
  String get planSelectedPace;

  /// No description provided for @planPaceUnit.
  ///
  /// In en, this message translates to:
  /// **'breaths / min'**
  String get planPaceUnit;

  /// No description provided for @planCycle.
  ///
  /// In en, this message translates to:
  /// **'Breathe in for {seconds} sec, out for {seconds} sec.'**
  String planCycle(String seconds);

  /// No description provided for @planAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust my rhythm'**
  String get planAdjust;

  /// No description provided for @planNote.
  ///
  /// In en, this message translates to:
  /// **'A preview of your selected rhythm.\nAdjust the pace whenever you like.'**
  String get planNote;

  /// No description provided for @breathPhaseOption.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s in / out'**
  String breathPhaseOption(String seconds);

  /// No description provided for @planSlowGuidance.
  ///
  /// In en, this message translates to:
  /// **'Take your time. Follow the ring through each long, even breath.'**
  String get planSlowGuidance;

  /// No description provided for @planMediumGuidance.
  ///
  /// In en, this message translates to:
  /// **'Find a steady flow. Keep your inhale and exhale even.'**
  String get planMediumGuidance;

  /// No description provided for @planFasterGuidance.
  ///
  /// In en, this message translates to:
  /// **'Follow a lighter rhythm with short, even breathing phases.'**
  String get planFasterGuidance;

  /// No description provided for @resetAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset app'**
  String get resetAppTitle;

  /// No description provided for @resetAppQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset onboarding and restart the app?'**
  String get resetAppQuestion;

  /// No description provided for @resetAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Your selected pace and cached profile will be cleared. You’ll see the introduction again.'**
  String get resetAppDescription;

  /// No description provided for @resetAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetAppConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @resetAppError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t reset the app. Please try again.'**
  String get resetAppError;

  /// No description provided for @breathPaceSaveError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t save your pace. Please try again.'**
  String get breathPaceSaveError;

  /// No description provided for @breathPacesLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load the available breathing paces. Please try again.'**
  String get breathPacesLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
