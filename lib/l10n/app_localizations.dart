import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quiz Master'**
  String get homeTitle;

  /// No description provided for @homeWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get homeWelcome;

  /// No description provided for @homeWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Organisez des quiz en personne avec vos amis'**
  String get homeWelcomeSubtitle;

  /// No description provided for @homeNewGame.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get homeNewGame;

  /// No description provided for @homeQuestionLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque de questions'**
  String get homeQuestionLibrary;

  /// No description provided for @homeQuestionLibraryDescription.
  ///
  /// In fr, this message translates to:
  /// **'Consultez les questions du quiz'**
  String get homeQuestionLibraryDescription;

  /// No description provided for @homeSessionHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des sessions'**
  String get homeSessionHistory;

  /// No description provided for @homeSessionHistoryDescription.
  ///
  /// In fr, this message translates to:
  /// **'Reprenez vos parties terminées'**
  String get homeSessionHistoryDescription;

  /// No description provided for @homeSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get homeSettings;

  /// No description provided for @homeSettingsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Thème clair ou sombre'**
  String get homeSettingsDescription;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsBackTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get settingsBackTooltip;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsAppearanceSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le thème de l\'application'**
  String get settingsAppearanceSubtitle;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez la langue de l\'application'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsDataTitle.
  ///
  /// In fr, this message translates to:
  /// **'Données'**
  String get settingsDataTitle;

  /// No description provided for @settingsDataSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Stockées uniquement sur cet appareil'**
  String get settingsDataSubtitle;

  /// No description provided for @settingsStoredSessions.
  ///
  /// In fr, this message translates to:
  /// **'{count} session(s) enregistrée(s) (maximum {max})'**
  String settingsStoredSessions(int count, int max);

  /// No description provided for @settingsHistoryFull.
  ///
  /// In fr, this message translates to:
  /// **'Historique plein : les sessions les plus anciennes sont remplacées automatiquement'**
  String get settingsHistoryFull;

  /// No description provided for @settingsOpenHistory.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir l\'historique des sessions'**
  String get settingsOpenHistory;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAboutTitle;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Quiz Master fonctionne hors connexion : ni compte, ni connexion internet, ni publicité. Les questions et les sessions sont stockées localement sur cet appareil.'**
  String get settingsAboutDescription;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
