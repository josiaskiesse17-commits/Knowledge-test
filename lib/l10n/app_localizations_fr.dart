// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get homeTitle => 'Quiz Master';

  @override
  String get homeWelcome => 'Bienvenue';

  @override
  String get homeWelcomeSubtitle =>
      'Organisez des quiz en personne avec vos amis';

  @override
  String get homeNewGame => 'Nouvelle partie';

  @override
  String get homeQuestionLibrary => 'Bibliothèque de questions';

  @override
  String get homeQuestionLibraryDescription =>
      'Consultez les questions du quiz';

  @override
  String get homeSessionHistory => 'Historique des sessions';

  @override
  String get homeSessionHistoryDescription => 'Reprenez vos parties terminées';

  @override
  String get homeSettings => 'Paramètres';

  @override
  String get homeSettingsDescription => 'Thème clair ou sombre';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsBackTooltip => 'Retour';

  @override
  String get settingsAppearanceTitle => 'Apparence';

  @override
  String get settingsAppearanceSubtitle =>
      'Choisissez le thème de l\'application';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageSubtitle =>
      'Choisissez la langue de l\'application';

  @override
  String get settingsDataTitle => 'Données';

  @override
  String get settingsDataSubtitle => 'Stockées uniquement sur cet appareil';

  @override
  String settingsStoredSessions(int count, int max) {
    return '$count session(s) enregistrée(s) (maximum $max)';
  }

  @override
  String get settingsHistoryFull =>
      'Historique plein : les sessions les plus anciennes sont remplacées automatiquement';

  @override
  String get settingsOpenHistory => 'Ouvrir l\'historique des sessions';

  @override
  String get settingsAboutTitle => 'À propos';

  @override
  String get settingsAboutDescription =>
      'Quiz Master fonctionne hors connexion : ni compte, ni connexion internet, ni publicité. Les questions et les sessions sont stockées localement sur cet appareil.';
}
