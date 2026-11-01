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

  /// No description provided for @sessionConfigErrorMinPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins 2 joueurs.'**
  String get sessionConfigErrorMinPlayers;

  /// No description provided for @sessionConfigErrorMaxPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Maximum 8 joueurs autorisés.'**
  String get sessionConfigErrorMaxPlayers;

  /// No description provided for @sessionConfigErrorUniqueNames.
  ///
  /// In fr, this message translates to:
  /// **'Les noms des joueurs doivent être uniques.'**
  String get sessionConfigErrorUniqueNames;

  /// No description provided for @sessionConfigErrorNoMode.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez au moins un mode de jeu.'**
  String get sessionConfigErrorNoMode;

  /// No description provided for @sessionConfigErrorDurationTooShort.
  ///
  /// In fr, this message translates to:
  /// **'La durée doit être d\'au moins 1 minute.'**
  String get sessionConfigErrorDurationTooShort;

  /// No description provided for @sessionConfigErrorQuestionCountTooLow.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre de questions doit être d\'au moins 1.'**
  String get sessionConfigErrorQuestionCountTooLow;

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

  /// No description provided for @emptySessionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session'**
  String get emptySessionTitle;

  /// No description provided for @emptySessionNoSession.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session en cours.'**
  String get emptySessionNoSession;

  /// No description provided for @emptySessionSetup.
  ///
  /// In fr, this message translates to:
  /// **'Configurer une partie'**
  String get emptySessionSetup;

  /// No description provided for @questionLibraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque de questions'**
  String get questionLibraryTitle;

  /// No description provided for @questionFilterMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode'**
  String get questionFilterMode;

  /// No description provided for @questionFilterDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get questionFilterDifficulty;

  /// No description provided for @questionFilterCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get questionFilterCategory;

  /// No description provided for @questionFilterVariation.
  ///
  /// In fr, this message translates to:
  /// **'Variation'**
  String get questionFilterVariation;

  /// No description provided for @questionFilterSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une question…'**
  String get questionFilterSearchHint;

  /// No description provided for @questionFilterClearTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Effacer la recherche'**
  String get questionFilterClearTooltip;

  /// No description provided for @questionFilterFilters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get questionFilterFilters;

  /// No description provided for @questionFilterActiveCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} filtre actif'**
  String questionFilterActiveCount(int count);

  /// No description provided for @questionFilterActiveCountOther.
  ///
  /// In fr, this message translates to:
  /// **'{count} filtres actifs'**
  String questionFilterActiveCountOther(int count);

  /// No description provided for @questionFilterResultCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} question'**
  String questionFilterResultCount(int count);

  /// No description provided for @questionFilterResultCountOther.
  ///
  /// In fr, this message translates to:
  /// **'{count} questions'**
  String questionFilterResultCountOther(int count);

  /// No description provided for @questionFilterHideTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Masquer les filtres'**
  String get questionFilterHideTooltip;

  /// No description provided for @questionFilterShowTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Afficher les filtres'**
  String get questionFilterShowTooltip;

  /// No description provided for @questionLibraryNoResult.
  ///
  /// In fr, this message translates to:
  /// **'Aucune question ne correspond'**
  String get questionLibraryNoResult;

  /// No description provided for @questionLibraryNoResultHint.
  ///
  /// In fr, this message translates to:
  /// **'Modifiez la recherche ou réinitialisez les filtres.'**
  String get questionLibraryNoResultHint;

  /// No description provided for @questionLibrarySelectHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une question'**
  String get questionLibrarySelectHint;

  /// No description provided for @questionLibrarySelectHintDetail.
  ///
  /// In fr, this message translates to:
  /// **'Sa réponse, son explication et sa source s\'afficheront ici.'**
  String get questionLibrarySelectHintDetail;

  /// No description provided for @questionBodyRevealAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Révéler la réponse'**
  String get questionBodyRevealAnswer;

  /// No description provided for @questionBodyHideExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Masquer l\'explication'**
  String get questionBodyHideExplanation;

  /// No description provided for @questionBodyShowExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'explication'**
  String get questionBodyShowExplanation;

  /// No description provided for @questionBodyExplanationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explication'**
  String get questionBodyExplanationTitle;

  /// No description provided for @questionBodySource.
  ///
  /// In fr, this message translates to:
  /// **'Source :'**
  String get questionBodySource;

  /// No description provided for @questionDetailExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Explication'**
  String get questionDetailExplanation;

  /// No description provided for @questionDetailSource.
  ///
  /// In fr, this message translates to:
  /// **'Source :'**
  String get questionDetailSource;

  /// No description provided for @questionDetailId.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant'**
  String get questionDetailId;

  /// No description provided for @questionDetailFactGroup.
  ///
  /// In fr, this message translates to:
  /// **'Groupe de fait :'**
  String get questionDetailFactGroup;

  /// No description provided for @questionDetailClues.
  ///
  /// In fr, this message translates to:
  /// **'Indices'**
  String get questionDetailClues;

  /// No description provided for @questionDetailEstimation.
  ///
  /// In fr, this message translates to:
  /// **'Estimation'**
  String get questionDetailEstimation;

  /// No description provided for @questionBodyCluesRevealed.
  ///
  /// In fr, this message translates to:
  /// **'Indices révélés :'**
  String get questionBodyCluesRevealed;

  /// No description provided for @questionBodyNoCluesYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun indice pour le moment.'**
  String get questionBodyNoCluesYet;

  /// No description provided for @questionBodyElementsToOrder.
  ///
  /// In fr, this message translates to:
  /// **'Éléments à classer'**
  String get questionBodyElementsToOrder;

  /// No description provided for @questionBodyCompleteOrder.
  ///
  /// In fr, this message translates to:
  /// **'Classement complet attendu'**
  String get questionBodyCompleteOrder;

  /// No description provided for @questionBodyExpectedAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Réponse attendue'**
  String get questionBodyExpectedAnswer;

  /// No description provided for @questionBodyAcceptedRange.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée'**
  String get questionBodyAcceptedRange;

  /// No description provided for @questionBodyScoringRule.
  ///
  /// In fr, this message translates to:
  /// **'Règle de score'**
  String get questionBodyScoringRule;

  /// No description provided for @questionBodyCorrectAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse'**
  String get questionBodyCorrectAnswer;

  /// No description provided for @questionBodyFirst.
  ///
  /// In fr, this message translates to:
  /// **'En premier'**
  String get questionBodyFirst;

  /// No description provided for @questionBodyThen.
  ///
  /// In fr, this message translates to:
  /// **'Ensuite'**
  String get questionBodyThen;

  /// No description provided for @questionBodyCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get questionBodyCountry;

  /// No description provided for @questionBodyCapital.
  ///
  /// In fr, this message translates to:
  /// **'Capitale'**
  String get questionBodyCapital;

  /// No description provided for @questionBodyAcceptedAnswers.
  ///
  /// In fr, this message translates to:
  /// **'Réponses acceptées'**
  String get questionBodyAcceptedAnswers;

  /// No description provided for @questionBodyStatementTrueFalse.
  ///
  /// In fr, this message translates to:
  /// **'Cette affirmation est {isTrue, select, true {vraie} false {fausse} other {vraie}}.'**
  String questionBodyStatementTrueFalse(String isTrue);

  /// No description provided for @questionBodyFalseStatements.
  ///
  /// In fr, this message translates to:
  /// **'Affirmation(s) fausse(s) :'**
  String get questionBodyFalseStatements;

  /// No description provided for @questionBodyCorrectOrder.
  ///
  /// In fr, this message translates to:
  /// **'Ordre correct :'**
  String get questionBodyCorrectOrder;

  /// No description provided for @questionBodyValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur'**
  String get questionBodyValue;

  /// No description provided for @questionVariationChronology.
  ///
  /// In fr, this message translates to:
  /// **'Chronologie'**
  String get questionVariationChronology;

  /// No description provided for @questionVariationClues.
  ///
  /// In fr, this message translates to:
  /// **'Indices'**
  String get questionVariationClues;

  /// No description provided for @questionVariationFlag.
  ///
  /// In fr, this message translates to:
  /// **'Drapeau'**
  String get questionVariationFlag;

  /// No description provided for @questionVariationCapital.
  ///
  /// In fr, this message translates to:
  /// **'Capitale'**
  String get questionVariationCapital;

  /// No description provided for @questionVariationSilhouette.
  ///
  /// In fr, this message translates to:
  /// **'Silhouette'**
  String get questionVariationSilhouette;

  /// No description provided for @questionVariationTrueFalse.
  ///
  /// In fr, this message translates to:
  /// **'Vrai ou faux'**
  String get questionVariationTrueFalse;

  /// No description provided for @questionVariationTwoTruthsOneLie.
  ///
  /// In fr, this message translates to:
  /// **'Deux vérités, un mensonge'**
  String get questionVariationTwoTruthsOneLie;

  /// No description provided for @questionVariationIdentifyFalse.
  ///
  /// In fr, this message translates to:
  /// **'Trouve la fausse affirmation'**
  String get questionVariationIdentifyFalse;

  /// No description provided for @questionVariationByProperty.
  ///
  /// In fr, this message translates to:
  /// **'Par propriété'**
  String get questionVariationByProperty;

  /// No description provided for @questionVariationQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get questionVariationQuantity;

  /// No description provided for @questionVariationDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get questionVariationDate;

  /// No description provided for @questionVariationDistance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get questionVariationDistance;

  /// No description provided for @questionVariationPopulation.
  ///
  /// In fr, this message translates to:
  /// **'Population'**
  String get questionVariationPopulation;

  /// No description provided for @routerPageNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Page non trouvée'**
  String get routerPageNotFound;

  /// No description provided for @routerRouteUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Route inconnue'**
  String get routerRouteUnknown;

  /// No description provided for @routerBackToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get routerBackToHome;

  /// No description provided for @gameBarScoresTotal.
  ///
  /// In fr, this message translates to:
  /// **'Scores — total {total}'**
  String gameBarScoresTotal(Object total);

  /// No description provided for @gameBarQuestionsResolved.
  ///
  /// In fr, this message translates to:
  /// **'{resolved}/{total} notées'**
  String gameBarQuestionsResolved(Object resolved, Object total);

  /// No description provided for @gameBarUndoAward.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get gameBarUndoAward;

  /// No description provided for @gameBarAwardPoint.
  ///
  /// In fr, this message translates to:
  /// **'Point'**
  String get gameBarAwardPoint;

  /// No description provided for @gameBarSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get gameBarSkip;

  /// No description provided for @gameBarInvalidate.
  ///
  /// In fr, this message translates to:
  /// **'Invalider'**
  String get gameBarInvalidate;

  /// No description provided for @gameBarEndSession.
  ///
  /// In fr, this message translates to:
  /// **'Terminer la session'**
  String get gameBarEndSession;

  /// No description provided for @gameBarNextQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question suivante'**
  String get gameBarNextQuestion;

  /// No description provided for @gameBarSnackBarRoundIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Notez, passez ou invalidez cette question avant de continuer.'**
  String get gameBarSnackBarRoundIncomplete;

  /// No description provided for @gameBoardHeaderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scores'**
  String get gameBoardHeaderTitle;

  /// No description provided for @gameBoardHeaderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 point attribué pour cette question} other {# points attribués pour cette question}}'**
  String gameBoardHeaderSubtitle(num count);

  /// No description provided for @gameBoardUndoTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le point'**
  String get gameBoardUndoTooltip;

  /// No description provided for @gameBoardAwardOrdering.
  ///
  /// In fr, this message translates to:
  /// **'Bon classement'**
  String get gameBoardAwardOrdering;

  /// No description provided for @gameBoardInvalidatedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Question invalidée : aucun point ne peut être attribué.'**
  String get gameBoardInvalidatedMessage;

  /// No description provided for @gameBoardOrderExactMessage.
  ///
  /// In fr, this message translates to:
  /// **'Le classement doit être exact pour obtenir le point.'**
  String get gameBoardOrderExactMessage;

  /// No description provided for @gameBoardStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get gameBoardStatusPending;

  /// No description provided for @gameBoardTimeRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Temps restant : {time}'**
  String gameBoardTimeRemaining(Object time);

  /// No description provided for @gameOrderDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Classement annoncé'**
  String get gameOrderDialogTitle;

  /// No description provided for @gameOrderDialogInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez les éléments dans l\'ordre annoncé par les joueurs.'**
  String get gameOrderDialogInstruction;

  /// No description provided for @gameOrderDialogSelectedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ordre choisi'**
  String get gameOrderDialogSelectedTitle;

  /// No description provided for @gameOrderDialogNoSelection.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément sélectionné.'**
  String get gameOrderDialogNoSelection;

  /// No description provided for @gameOrderDialogRemainingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Éléments restants'**
  String get gameOrderDialogRemainingTitle;

  /// No description provided for @gameOrderDialogRemoveTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get gameOrderDialogRemoveTooltip;

  /// No description provided for @gameOrderDialogCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get gameOrderDialogCancel;

  /// No description provided for @gameOrderDialogConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get gameOrderDialogConfirm;

  /// No description provided for @gameNoticePausedTimer.
  ///
  /// In fr, this message translates to:
  /// **'Session en pause. Le chronomètre est arrêté.'**
  String get gameNoticePausedTimer;

  /// No description provided for @gameNoticePaused.
  ///
  /// In fr, this message translates to:
  /// **'Session en pause.'**
  String get gameNoticePaused;

  /// No description provided for @gameNoticeTimeExpired.
  ///
  /// In fr, this message translates to:
  /// **'Temps écoulé. Terminez cette question, puis la session s\'arrêtera.'**
  String get gameNoticeTimeExpired;

  /// No description provided for @gameColumnNextClue.
  ///
  /// In fr, this message translates to:
  /// **'Indice suivant ({current}/{total})'**
  String gameColumnNextClue(Object current, Object total);

  /// No description provided for @gameBoardQuestionNumber.
  ///
  /// In fr, this message translates to:
  /// **'Question {number} / {total}'**
  String gameBoardQuestionNumber(Object number, Object total);

  /// No description provided for @questionFilterReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get questionFilterReset;

  /// No description provided for @playerNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom du joueur'**
  String get playerNameHint;

  /// No description provided for @homeSoloMode.
  ///
  /// In fr, this message translates to:
  /// **'Jouer seul(e)'**
  String get homeSoloMode;

  /// No description provided for @homeSoloModeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Répondez aux questions vous-même et progressez grâce aux explications'**
  String get homeSoloModeDescription;

  /// No description provided for @soloSetupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Configuration solo'**
  String get soloSetupTitle;

  /// No description provided for @soloSetupModesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modes de jeu'**
  String get soloSetupModesTitle;

  /// No description provided for @soloSetupModesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Un ou plusieurs modes pour votre partie solo.'**
  String get soloSetupModesSubtitle;

  /// No description provided for @soloSetupDifficultyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get soloSetupDifficultyTitle;

  /// No description provided for @soloSetupDifficultySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les questions de ce niveau sont privilégiées.'**
  String get soloSetupDifficultySubtitle;

  /// No description provided for @soloSetupCategoriesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get soloSetupCategoriesTitle;

  /// No description provided for @soloSetupCategoriesSubtitleAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories.'**
  String get soloSetupCategoriesSubtitleAll;

  /// No description provided for @soloSetupCategoriesSubtitleSelected.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1 {1 catégorie sélectionnée} other {# catégories sélectionnées}}'**
  String soloSetupCategoriesSubtitleSelected(num count);

  /// No description provided for @soloSetupLengthTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de questions'**
  String get soloSetupLengthTitle;

  /// No description provided for @soloSetupLengthSubtitleQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Session limitée en nombre de questions.'**
  String get soloSetupLengthSubtitleQuestions;

  /// No description provided for @soloSetupShuffleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mélanger les questions'**
  String get soloSetupShuffleTitle;

  /// No description provided for @soloSetupShuffleSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ordre aléatoire à chaque session.'**
  String get soloSetupShuffleSubtitle;

  /// No description provided for @soloStartGame.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la partie solo'**
  String get soloStartGame;

  /// No description provided for @soloResumeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partie solo en cours'**
  String get soloResumeTitle;

  /// No description provided for @soloResumeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez une partie solo non terminée. Voulez-vous la reprendre ?'**
  String get soloResumeSubtitle;

  /// No description provided for @soloResumeButton.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get soloResumeButton;

  /// No description provided for @soloDiscardButton.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get soloDiscardButton;

  /// No description provided for @soloErrorNoMode.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez au moins un mode de jeu.'**
  String get soloErrorNoMode;

  /// No description provided for @soloErrorQuestionCountTooLow.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre de questions doit être d\'au moins 1.'**
  String get soloErrorQuestionCountTooLow;

  /// No description provided for @soloErrorNotEnoughQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Pas assez de questions disponibles avec ces critères.'**
  String get soloErrorNotEnoughQuestions;

  /// No description provided for @soloNotSupportedYet.
  ///
  /// In fr, this message translates to:
  /// **'Ce mode n\'est pas encore disponible en solo.'**
  String get soloNotSupportedYet;

  /// No description provided for @soloSkipQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Passer cette question'**
  String get soloSkipQuestion;

  /// No description provided for @soloQuestionNumber.
  ///
  /// In fr, this message translates to:
  /// **'Question {number} / {total}'**
  String soloQuestionNumber(Object number, Object total);

  /// No description provided for @soloScore.
  ///
  /// In fr, this message translates to:
  /// **'Score : {score}'**
  String soloScore(Object score);

  /// No description provided for @soloStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série : {streak}'**
  String soloStreak(Object streak);

  /// No description provided for @soloCorrect.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse !'**
  String get soloCorrect;

  /// No description provided for @soloIncorrect.
  ///
  /// In fr, this message translates to:
  /// **'Mauvaise réponse.'**
  String get soloIncorrect;

  /// No description provided for @soloPointsEarned.
  ///
  /// In fr, this message translates to:
  /// **'{points, plural, =1 {+1 pt} other {+# pts}}'**
  String soloPointsEarned(int points);

  /// No description provided for @soloYourAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Votre réponse'**
  String get soloYourAnswer;

  /// No description provided for @soloCorrectAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse'**
  String get soloCorrectAnswer;

  /// No description provided for @soloExplanation.
  ///
  /// In fr, this message translates to:
  /// **'Explication'**
  String get soloExplanation;

  /// No description provided for @soloSource.
  ///
  /// In fr, this message translates to:
  /// **'Source :'**
  String get soloSource;

  /// No description provided for @soloNextQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question suivante'**
  String get soloNextQuestion;

  /// No description provided for @soloSeeResults.
  ///
  /// In fr, this message translates to:
  /// **'Voir les résultats'**
  String get soloSeeResults;

  /// No description provided for @soloQuitDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la partie solo ?'**
  String get soloQuitDialogTitle;

  /// No description provided for @soloQuitDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Votre progression sera conservée pour reprendre plus tard.'**
  String get soloQuitDialogContent;

  /// No description provided for @soloQuitDialogStay.
  ///
  /// In fr, this message translates to:
  /// **'Rester'**
  String get soloQuitDialogStay;

  /// No description provided for @soloQuitDialogQuit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get soloQuitDialogQuit;

  /// No description provided for @soloSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultats de votre partie solo'**
  String get soloSummaryTitle;

  /// No description provided for @soloBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get soloBackHome;

  /// No description provided for @soloNoAnswer.
  ///
  /// In fr, this message translates to:
  /// **'(aucune réponse)'**
  String get soloNoAnswer;

  /// No description provided for @soloTrue.
  ///
  /// In fr, this message translates to:
  /// **'Vrai'**
  String get soloTrue;

  /// No description provided for @soloFalse.
  ///
  /// In fr, this message translates to:
  /// **'Faux'**
  String get soloFalse;

  /// No description provided for @soloGuessTheCountryHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom du pays'**
  String get soloGuessTheCountryHint;

  /// No description provided for @soloPutInOrderInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Glissez les éléments dans l\'ordre'**
  String get soloPutInOrderInstruction;

  /// No description provided for @soloPutInOrderValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider l\'ordre'**
  String get soloPutInOrderValidate;

  /// No description provided for @soloValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get soloValidate;

  /// No description provided for @soloHowMuchHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre estimation'**
  String get soloHowMuchHint;

  /// No description provided for @soloHowMuchInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get soloHowMuchInvalid;

  /// No description provided for @soloHowMuchReference.
  ///
  /// In fr, this message translates to:
  /// **'Valeur de référence'**
  String get soloHowMuchReference;

  /// No description provided for @soloHowMuchAcceptedRange.
  ///
  /// In fr, this message translates to:
  /// **'Plage acceptée'**
  String get soloHowMuchAcceptedRange;

  /// No description provided for @soloHowMuchTolerance.
  ///
  /// In fr, this message translates to:
  /// **'Tolérance appliquée'**
  String get soloHowMuchTolerance;
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
