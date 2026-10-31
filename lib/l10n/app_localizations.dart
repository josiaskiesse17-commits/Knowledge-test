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

  /// No description provided for @gameQuitSessionTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la session'**
  String get gameQuitSessionTooltip;

  /// No description provided for @gameResumeTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get gameResumeTooltip;

  /// No description provided for @gamePauseTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Mettre en pause'**
  String get gamePauseTooltip;

  /// No description provided for @gameQuitDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la session ?'**
  String get gameQuitDialogTitle;

  /// No description provided for @gameQuitDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'La progression et les scores seront perdus.'**
  String get gameQuitDialogContent;

  /// No description provided for @gameQuitDialogStay.
  ///
  /// In fr, this message translates to:
  /// **'Rester'**
  String get gameQuitDialogStay;

  /// No description provided for @gameQuitDialogQuit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get gameQuitDialogQuit;

  /// No description provided for @gameModeWhichCameFirst.
  ///
  /// In fr, this message translates to:
  /// **'Lequel en premier ?'**
  String get gameModeWhichCameFirst;

  /// No description provided for @gameModeGuessTheCountry.
  ///
  /// In fr, this message translates to:
  /// **'Devine le pays'**
  String get gameModeGuessTheCountry;

  /// No description provided for @gameModeFactOrCap.
  ///
  /// In fr, this message translates to:
  /// **'Fait ou Fake'**
  String get gameModeFactOrCap;

  /// No description provided for @gameModePutInOrder.
  ///
  /// In fr, this message translates to:
  /// **'Mets dans l\'ordre'**
  String get gameModePutInOrder;

  /// No description provided for @gameModeHowMuch.
  ///
  /// In fr, this message translates to:
  /// **'Combien ?'**
  String get gameModeHowMuch;

  /// No description provided for @finalRankingAppBarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Classement final'**
  String get finalRankingAppBarTitle;

  /// No description provided for @finalRankingSessionEnded.
  ///
  /// In fr, this message translates to:
  /// **'Partie terminée'**
  String get finalRankingSessionEnded;

  /// No description provided for @finalRankingQuestionsPlayed.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 question jouée} other {# questions jouées}}'**
  String finalRankingQuestionsPlayed(int count);

  /// No description provided for @finalRankingNewGame.
  ///
  /// In fr, this message translates to:
  /// **'Configurer une nouvelle partie'**
  String get finalRankingNewGame;

  /// No description provided for @finalRankingBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get finalRankingBackHome;

  /// No description provided for @finalRankingPlayerNameFallback.
  ///
  /// In fr, this message translates to:
  /// **'Joueur'**
  String get finalRankingPlayerNameFallback;

  /// No description provided for @finalRankingTiedNote.
  ///
  /// In fr, this message translates to:
  /// **'À égalité avec un autre joueur'**
  String get finalRankingTiedNote;

  /// No description provided for @finalRankingScore.
  ///
  /// In fr, this message translates to:
  /// **'{score, plural, =1 {1 pt} other {# pts}}'**
  String finalRankingScore(int score);

  /// No description provided for @finalRankingRank.
  ///
  /// In fr, this message translates to:
  /// **'{rank, select, 1 {1er} 2 {2e} 3 {3e} other {#e}}'**
  String finalRankingRank(String rank);

  /// No description provided for @sessionHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des sessions'**
  String get sessionHistoryTitle;

  /// No description provided for @sessionHistoryBackTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get sessionHistoryBackTooltip;

  /// No description provided for @sessionHistoryClearTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Vider l\'historique'**
  String get sessionHistoryClearTooltip;

  /// No description provided for @sessionHistoryClearDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vider l\'historique ?'**
  String get sessionHistoryClearDialogTitle;

  /// No description provided for @sessionHistoryClearDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les sessions enregistrées seront supprimées de cet appareil.'**
  String get sessionHistoryClearDialogContent;

  /// No description provided for @sessionHistoryClearDialogCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get sessionHistoryClearDialogCancel;

  /// No description provided for @sessionHistoryClearDialogConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Vider'**
  String get sessionHistoryClearDialogConfirm;

  /// No description provided for @sessionHistoryNoPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Aucun joueur'**
  String get sessionHistoryNoPlayer;

  /// No description provided for @sessionHistoryPlayerFallback.
  ///
  /// In fr, this message translates to:
  /// **'Joueur'**
  String get sessionHistoryPlayerFallback;

  /// No description provided for @sessionHistoryScore.
  ///
  /// In fr, this message translates to:
  /// **'{score, plural, =1 {1 pt} other {# pts}}'**
  String sessionHistoryScore(int score);

  /// No description provided for @sessionHistoryPlayers.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 joueur} other {# joueurs}}'**
  String sessionHistoryPlayers(int count);

  /// No description provided for @sessionHistoryDeleteSessionTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette session'**
  String get sessionHistoryDeleteSessionTooltip;

  /// No description provided for @sessionHistoryUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Historique indisponible'**
  String get sessionHistoryUnavailable;

  /// No description provided for @sessionHistoryNoSessions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session enregistrée'**
  String get sessionHistoryNoSessions;

  /// No description provided for @sessionHistoryUnavailableMessage.
  ///
  /// In fr, this message translates to:
  /// **'Les sessions ne peuvent pas être lues sur cet appareil pour le moment.'**
  String get sessionHistoryUnavailableMessage;

  /// No description provided for @sessionHistoryEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Terminez une partie pour la retrouver ici, avec les scores et les questions jouées.'**
  String get sessionHistoryEmptyMessage;

  /// No description provided for @sessionHistoryFooter.
  ///
  /// In fr, this message translates to:
  /// **'Les sessions restent sur cet appareil : aucun compte ni connexion n\'est nécessaire.'**
  String get sessionHistoryFooter;

  /// No description provided for @sessionDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail de la session'**
  String get sessionDetailTitle;

  /// No description provided for @sessionDetailBackTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get sessionDetailBackTooltip;

  /// No description provided for @sessionDetailFinalRanking.
  ///
  /// In fr, this message translates to:
  /// **'Classement final'**
  String get sessionDetailFinalRanking;

  /// No description provided for @sessionDetailNoQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune question enregistrée pour cette session.'**
  String get sessionDetailNoQuestions;

  /// No description provided for @sessionDetailQuestionsPlayed.
  ///
  /// In fr, this message translates to:
  /// **'Questions jouées'**
  String get sessionDetailQuestionsPlayed;

  /// No description provided for @sessionDetailQuestionCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 question} other {# questions}}'**
  String sessionDetailQuestionCount(int count);

  /// No description provided for @sessionDetailQuestionRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Question retirée de la bibliothèque'**
  String get sessionDetailQuestionRemoved;

  /// No description provided for @sessionDetailPointsFor.
  ///
  /// In fr, this message translates to:
  /// **'Point pour {winners}'**
  String sessionDetailPointsFor(String winners);

  /// No description provided for @sessionDetailMissingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session introuvable'**
  String get sessionDetailMissingTitle;

  /// No description provided for @sessionDetailMissingMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette session a peut-être été supprimée de l\'historique.'**
  String get sessionDetailMissingMessage;

  /// No description provided for @sessionDetailBackToHistory.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'historique'**
  String get sessionDetailBackToHistory;

  /// No description provided for @sessionOutcomeScored.
  ///
  /// In fr, this message translates to:
  /// **'Notée'**
  String get sessionOutcomeScored;

  /// No description provided for @sessionOutcomeSkipped.
  ///
  /// In fr, this message translates to:
  /// **'Passée'**
  String get sessionOutcomeSkipped;

  /// No description provided for @sessionOutcomeInvalidated.
  ///
  /// In fr, this message translates to:
  /// **'Invalidée'**
  String get sessionOutcomeInvalidated;

  /// No description provided for @sessionOutcomePending.
  ///
  /// In fr, this message translates to:
  /// **'Non terminée'**
  String get sessionOutcomePending;

  /// No description provided for @sessionSettingsTimed.
  ///
  /// In fr, this message translates to:
  /// **'Session minutée : {minutes} min'**
  String sessionSettingsTimed(int minutes);

  /// No description provided for @sessionSettingsQuestions.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 question} other {# questions}}'**
  String sessionSettingsQuestions(int count);

  /// No description provided for @sessionSettingsDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté : {difficulty}'**
  String sessionSettingsDifficulty(String difficulty);

  /// No description provided for @sessionSettingsCategories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories : {categories}'**
  String sessionSettingsCategories(String categories);

  /// No description provided for @sessionSettingsShuffled.
  ///
  /// In fr, this message translates to:
  /// **'Questions mélangées'**
  String get sessionSettingsShuffled;

  /// No description provided for @sessionSettingsNotShuffled.
  ///
  /// In fr, this message translates to:
  /// **'Questions dans l\'ordre'**
  String get sessionSettingsNotShuffled;

  /// No description provided for @sessionSettingsDurationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Durée : {minutes} min'**
  String sessionSettingsDurationLabel(int minutes);

  /// No description provided for @sessionSettingsQuestionCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de questions : {count}'**
  String sessionSettingsQuestionCountLabel(int count);

  /// No description provided for @startupErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la banque de questions.\n{error}'**
  String startupErrorTitle(String error);

  /// No description provided for @startupErrorRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get startupErrorRetry;

  /// No description provided for @gameSetupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Configuration de la partie'**
  String get gameSetupTitle;

  /// No description provided for @gameSetupPlayersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs'**
  String get gameSetupPlayersTitle;

  /// No description provided for @gameSetupPlayersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'De 2 à 8 joueurs, sur un seul appareil.'**
  String get gameSetupPlayersSubtitle;

  /// No description provided for @gameSetupPlayerNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom du joueur'**
  String get gameSetupPlayerNameHint;

  /// No description provided for @gameSetupAddPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un joueur'**
  String get gameSetupAddPlayer;

  /// No description provided for @gameSetupRemovePlayerTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le joueur'**
  String get gameSetupRemovePlayerTooltip;

  /// No description provided for @gameSetupModesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modes de jeu'**
  String get gameSetupModesTitle;

  /// No description provided for @gameSetupModesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Un ou plusieurs modes pour la session.'**
  String get gameSetupModesSubtitle;

  /// No description provided for @gameSetupDifficultyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get gameSetupDifficultyTitle;

  /// No description provided for @gameSetupDifficultySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les questions de ce niveau sont privilégiées.'**
  String get gameSetupDifficultySubtitle;

  /// No description provided for @gameSetupCategoriesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get gameSetupCategoriesTitle;

  /// No description provided for @gameSetupCategoriesSubtitleAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories.'**
  String get gameSetupCategoriesSubtitleAll;

  /// No description provided for @gameSetupCategoriesSubtitleSelected.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 catégorie sélectionnée} other {# catégories sélectionnées}}'**
  String gameSetupCategoriesSubtitleSelected(int count);

  /// No description provided for @gameSetupLengthTitle.
  ///
  /// In fr, this message translates to:
  /// **'Durée ou nombre de questions'**
  String get gameSetupLengthTitle;

  /// No description provided for @gameSetupLengthSubtitleTimed.
  ///
  /// In fr, this message translates to:
  /// **'Session minutée : la question en cours est toujours terminée.'**
  String get gameSetupLengthSubtitleTimed;

  /// No description provided for @gameSetupLengthSubtitleQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Session limitée en nombre de questions.'**
  String get gameSetupLengthSubtitleQuestions;

  /// No description provided for @gameSetupLengthQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Questions'**
  String get gameSetupLengthQuestions;

  /// No description provided for @gameSetupLengthDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get gameSetupLengthDuration;

  /// No description provided for @gameSetupDecreaseDurationTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Réduire la durée'**
  String get gameSetupDecreaseDurationTooltip;

  /// No description provided for @gameSetupIncreaseDurationTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter la durée'**
  String get gameSetupIncreaseDurationTooltip;

  /// No description provided for @gameSetupDecreaseQuestionsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Moins de questions'**
  String get gameSetupDecreaseQuestionsTooltip;

  /// No description provided for @gameSetupIncreaseQuestionsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Plus de questions'**
  String get gameSetupIncreaseQuestionsTooltip;

  /// No description provided for @gameSetupShuffleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mélanger les questions'**
  String get gameSetupShuffleTitle;

  /// No description provided for @gameSetupShuffleSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ordre aléatoire à chaque session.'**
  String get gameSetupShuffleSubtitle;

  /// No description provided for @gameSetupStartGame.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la partie'**
  String get gameSetupStartGame;

  /// No description provided for @gameSetupMinPlayersError.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins 2 joueurs.'**
  String get gameSetupMinPlayersError;

  /// No description provided for @gameSetupMaxPlayersError.
  ///
  /// In fr, this message translates to:
  /// **'Maximum 8 joueurs autorisés.'**
  String get gameSetupMaxPlayersError;

  /// No description provided for @gameSetupUniqueNamesError.
  ///
  /// In fr, this message translates to:
  /// **'Les noms des joueurs doivent être uniques.'**
  String get gameSetupUniqueNamesError;

  /// No description provided for @gameSetupSelectModeError.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez au moins un mode de jeu.'**
  String get gameSetupSelectModeError;

  /// No description provided for @gameSetupDurationMinError.
  ///
  /// In fr, this message translates to:
  /// **'La durée doit être d\'au moins 1 minute.'**
  String get gameSetupDurationMinError;

  /// No description provided for @gameSetupQuestionCountMinError.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre de questions doit être d\'au moins 1.'**
  String get gameSetupQuestionCountMinError;

  /// No description provided for @difficultyEasy.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get difficultyHard;

  /// No description provided for @categoryHistory.
  ///
  /// In fr, this message translates to:
  /// **'Histoire'**
  String get categoryHistory;

  /// No description provided for @categoryScience.
  ///
  /// In fr, this message translates to:
  /// **'Sciences'**
  String get categoryScience;

  /// No description provided for @categoryGeography.
  ///
  /// In fr, this message translates to:
  /// **'Géographie'**
  String get categoryGeography;

  /// No description provided for @categoryArts.
  ///
  /// In fr, this message translates to:
  /// **'Arts et Culture'**
  String get categoryArts;

  /// No description provided for @categorySports.
  ///
  /// In fr, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryTechnology.
  ///
  /// In fr, this message translates to:
  /// **'Technologie'**
  String get categoryTechnology;

  /// No description provided for @categoryNature.
  ///
  /// In fr, this message translates to:
  /// **'Nature'**
  String get categoryNature;

  /// No description provided for @categoryGeneral.
  ///
  /// In fr, this message translates to:
  /// **'Culture Générale'**
  String get categoryGeneral;

  /// No description provided for @categoryAfrica.
  ///
  /// In fr, this message translates to:
  /// **'Afrique'**
  String get categoryAfrica;

  /// No description provided for @gameModeWhichCameFirstDesc.
  ///
  /// In fr, this message translates to:
  /// **'Comparez des événements historiques, découvertes et inventions'**
  String get gameModeWhichCameFirstDesc;

  /// No description provided for @gameModeGuessTheCountryDesc.
  ///
  /// In fr, this message translates to:
  /// **'Identifiez des pays à partir d\'indices progressifs, drapeaux, capitales ou silhouettes'**
  String get gameModeGuessTheCountryDesc;

  /// No description provided for @gameModeFactOrCapDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vrai/faux, deux vérités un mensonge, identifiez la fausse affirmation'**
  String get gameModeFactOrCapDesc;

  /// No description provided for @gameModePutInOrderDesc.
  ///
  /// In fr, this message translates to:
  /// **'Rangez des éléments chronologiquement ou par une propriété mesurable'**
  String get gameModePutInOrderDesc;

  /// No description provided for @gameModeHowMuchDesc.
  ///
  /// In fr, this message translates to:
  /// **'Estimation numérique : quantités, dates, distances, populations'**
  String get gameModeHowMuchDesc;

  /// No description provided for @awardResultAwarded.
  ///
  /// In fr, this message translates to:
  /// **'Point attribué.'**
  String get awardResultAwarded;

  /// No description provided for @awardResultUnknownPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Joueur inconnu.'**
  String get awardResultUnknownPlayer;

  /// No description provided for @awardResultAlreadyAwarded.
  ///
  /// In fr, this message translates to:
  /// **'Ce joueur a déjà reçu un point pour cette question.'**
  String get awardResultAlreadyAwarded;

  /// No description provided for @awardResultInvalidatedQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question invalidée : aucun point ne peut être attribué.'**
  String get awardResultInvalidatedQuestion;

  /// No description provided for @awardResultSessionNotActive.
  ///
  /// In fr, this message translates to:
  /// **'La session est terminée.'**
  String get awardResultSessionNotActive;

  /// No description provided for @awardResultWrongOrder.
  ///
  /// In fr, this message translates to:
  /// **'Le classement doit correspondre exactement à la bonne réponse.'**
  String get awardResultWrongOrder;
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
