// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Quiz Master';

  @override
  String get homeWelcome => 'Welcome';

  @override
  String get homeWelcomeSubtitle => 'Host quizzes in person with your friends';

  @override
  String get homeNewGame => 'New game';

  @override
  String get homeQuestionLibrary => 'Question library';

  @override
  String get homeQuestionLibraryDescription => 'Browse the quiz questions';

  @override
  String get homeSessionHistory => 'Session history';

  @override
  String get homeSessionHistoryDescription => 'Review your finished games';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeSettingsDescription => 'Light or dark theme';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsBackTooltip => 'Back';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsAppearanceSubtitle => 'Choose the app theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose the app language';

  @override
  String get settingsDataTitle => 'Data';

  @override
  String get settingsDataSubtitle => 'Stored on this device only';

  @override
  String settingsStoredSessions(int count, int max) {
    return '$count saved session(s) (maximum $max)';
  }

  @override
  String get settingsHistoryFull =>
      'History full: the oldest sessions are replaced automatically';

  @override
  String get settingsOpenHistory => 'Open the session history';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutDescription =>
      'Quiz Master works offline: no account, no internet connection, no ads. Questions and sessions are stored locally on this device.';
}
