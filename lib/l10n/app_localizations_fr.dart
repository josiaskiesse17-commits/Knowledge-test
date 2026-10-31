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

  @override
  String get gameQuitSessionTooltip => 'Quitter la session';

  @override
  String get gameResumeTooltip => 'Reprendre';

  @override
  String get gamePauseTooltip => 'Mettre en pause';

  @override
  String get gameQuitDialogTitle => 'Quitter la session ?';

  @override
  String get gameQuitDialogContent =>
      'La progression et les scores seront perdus.';

  @override
  String get gameQuitDialogStay => 'Rester';

  @override
  String get gameQuitDialogQuit => 'Quitter';

  @override
  String get gameModeWhichCameFirst => 'Lequel en premier ?';

  @override
  String get gameModeGuessTheCountry => 'Devine le pays';

  @override
  String get gameModeFactOrCap => 'Fait ou Fake';

  @override
  String get gameModePutInOrder => 'Mets dans l\'ordre';

  @override
  String get gameModeHowMuch => 'Combien ?';

  @override
  String get finalRankingAppBarTitle => 'Classement final';

  @override
  String get finalRankingSessionEnded => 'Partie terminée';

  @override
  String finalRankingQuestionsPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# questions jouées',
      one: '1 question jouée',
    );
    return '$_temp0';
  }

  @override
  String get finalRankingNewGame => 'Configurer une nouvelle partie';

  @override
  String get finalRankingBackHome => 'Retour à l\'accueil';

  @override
  String get finalRankingPlayerNameFallback => 'Joueur';

  @override
  String get finalRankingTiedNote => 'À égalité avec un autre joueur';

  @override
  String finalRankingScore(int score) {
    String _temp0 = intl.Intl.pluralLogic(
      score,
      locale: localeName,
      other: '# pts',
      one: '1 pt',
    );
    return '$_temp0';
  }

  @override
  String finalRankingRank(String rank) {
    String _temp0 = intl.Intl.selectLogic(rank, {
      '1': '1er',
      '2': '2e',
      '3': '3e',
      'other': '#e',
    });
    return '$_temp0';
  }

  @override
  String get sessionHistoryTitle => 'Historique des sessions';

  @override
  String get sessionHistoryBackTooltip => 'Retour';

  @override
  String get sessionHistoryClearTooltip => 'Vider l\'historique';

  @override
  String get sessionHistoryClearDialogTitle => 'Vider l\'historique ?';

  @override
  String get sessionHistoryClearDialogContent =>
      'Toutes les sessions enregistrées seront supprimées de cet appareil.';

  @override
  String get sessionHistoryClearDialogCancel => 'Annuler';

  @override
  String get sessionHistoryClearDialogConfirm => 'Vider';

  @override
  String get sessionHistoryNoPlayer => 'Aucun joueur';

  @override
  String get sessionHistoryPlayerFallback => 'Joueur';

  @override
  String sessionHistoryScore(int score) {
    String _temp0 = intl.Intl.pluralLogic(
      score,
      locale: localeName,
      other: '# pts',
      one: '1 pt',
    );
    return '$_temp0';
  }

  @override
  String sessionHistoryPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# joueurs',
      one: '1 joueur',
    );
    return '$_temp0';
  }

  @override
  String get sessionHistoryDeleteSessionTooltip => 'Supprimer cette session';

  @override
  String get sessionHistoryUnavailable => 'Historique indisponible';

  @override
  String get sessionHistoryNoSessions => 'Aucune session enregistrée';

  @override
  String get sessionHistoryUnavailableMessage =>
      'Les sessions ne peuvent pas être lues sur cet appareil pour le moment.';

  @override
  String get sessionHistoryEmptyMessage =>
      'Terminez une partie pour la retrouver ici, avec les scores et les questions jouées.';

  @override
  String get sessionHistoryFooter =>
      'Les sessions restent sur cet appareil : aucun compte ni connexion n\'est nécessaire.';

  @override
  String get sessionDetailTitle => 'Détail de la session';

  @override
  String get sessionDetailBackTooltip => 'Retour';

  @override
  String get sessionDetailFinalRanking => 'Classement final';

  @override
  String get sessionDetailNoQuestions =>
      'Aucune question enregistrée pour cette session.';

  @override
  String get sessionDetailQuestionsPlayed => 'Questions jouées';

  @override
  String sessionDetailQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get sessionDetailQuestionRemoved =>
      'Question retirée de la bibliothèque';

  @override
  String sessionDetailPointsFor(String winners) {
    return 'Point pour $winners';
  }

  @override
  String get sessionDetailMissingTitle => 'Session introuvable';

  @override
  String get sessionDetailMissingMessage =>
      'Cette session a peut-être été supprimée de l\'historique.';

  @override
  String get sessionDetailBackToHistory => 'Retour à l\'historique';

  @override
  String get sessionOutcomeScored => 'Notée';

  @override
  String get sessionOutcomeSkipped => 'Passée';

  @override
  String get sessionOutcomeInvalidated => 'Invalidée';

  @override
  String get sessionOutcomePending => 'Non terminée';

  @override
  String sessionSettingsTimed(int minutes) {
    return 'Session minutée : $minutes min';
  }

  @override
  String sessionSettingsQuestions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String sessionSettingsDifficulty(String difficulty) {
    return 'Difficulté : $difficulty';
  }

  @override
  String sessionSettingsCategories(String categories) {
    return 'Catégories : $categories';
  }

  @override
  String get sessionSettingsShuffled => 'Questions mélangées';

  @override
  String get sessionSettingsNotShuffled => 'Questions dans l\'ordre';

  @override
  String sessionSettingsDurationLabel(int minutes) {
    return 'Durée : $minutes min';
  }

  @override
  String sessionSettingsQuestionCountLabel(int count) {
    return 'Nombre de questions : $count';
  }

  @override
  String startupErrorTitle(String error) {
    return 'Impossible de charger la banque de questions.\n$error';
  }

  @override
  String get startupErrorRetry => 'Réessayer';

  @override
  String get gameSetupTitle => 'Configuration de la partie';

  @override
  String get gameSetupPlayersTitle => 'Joueurs';

  @override
  String get gameSetupPlayersSubtitle =>
      'De 2 à 8 joueurs, sur un seul appareil.';

  @override
  String get gameSetupPlayerNameHint => 'Nom du joueur';

  @override
  String get gameSetupAddPlayer => 'Ajouter un joueur';

  @override
  String get gameSetupRemovePlayerTooltip => 'Supprimer le joueur';

  @override
  String get gameSetupModesTitle => 'Modes de jeu';

  @override
  String get gameSetupModesSubtitle => 'Un ou plusieurs modes pour la session.';

  @override
  String get gameSetupDifficultyTitle => 'Difficulté';

  @override
  String get gameSetupDifficultySubtitle =>
      'Les questions de ce niveau sont privilégiées.';

  @override
  String get gameSetupCategoriesTitle => 'Catégories';

  @override
  String get gameSetupCategoriesSubtitleAll => 'Toutes les catégories.';

  @override
  String gameSetupCategoriesSubtitleSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# catégories sélectionnées',
      one: '1 catégorie sélectionnée',
    );
    return '$_temp0';
  }

  @override
  String get gameSetupLengthTitle => 'Durée ou nombre de questions';

  @override
  String get gameSetupLengthSubtitleTimed =>
      'Session minutée : la question en cours est toujours terminée.';

  @override
  String get gameSetupLengthSubtitleQuestions =>
      'Session limitée en nombre de questions.';

  @override
  String get gameSetupLengthQuestions => 'Questions';

  @override
  String get gameSetupLengthDuration => 'Durée';

  @override
  String get gameSetupDecreaseDurationTooltip => 'Réduire la durée';

  @override
  String get gameSetupIncreaseDurationTooltip => 'Augmenter la durée';

  @override
  String get gameSetupDecreaseQuestionsTooltip => 'Moins de questions';

  @override
  String get gameSetupIncreaseQuestionsTooltip => 'Plus de questions';

  @override
  String get gameSetupShuffleTitle => 'Mélanger les questions';

  @override
  String get gameSetupShuffleSubtitle => 'Ordre aléatoire à chaque session.';

  @override
  String get gameSetupStartGame => 'Commencer la partie';

  @override
  String get gameSetupMinPlayersError =>
      'Il faut au moins 2 joueurs pour commencer';

  @override
  String get gameSetupMaxPlayersError => 'Maximum 8 joueurs autorisés';

  @override
  String get gameSetupUniqueNamesError =>
      'Les noms des joueurs doivent être uniques';

  @override
  String get gameSetupSelectModeError => 'Sélectionnez au moins un mode de jeu';

  @override
  String get gameSetupDurationMinError =>
      'La durée doit être d\'au moins 1 minute';

  @override
  String get gameSetupQuestionCountMinError =>
      'Le nombre de questions doit être d\'au moins 1';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get categoryHistory => 'Histoire';

  @override
  String get categoryScience => 'Sciences';

  @override
  String get categoryGeography => 'Géographie';

  @override
  String get categoryArts => 'Arts et Culture';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryTechnology => 'Technologie';

  @override
  String get categoryNature => 'Nature';

  @override
  String get categoryGeneral => 'Culture Générale';

  @override
  String get categoryAfrica => 'Afrique';

  @override
  String get gameModeWhichCameFirstDesc =>
      'Comparez des événements historiques, découvertes et inventions';

  @override
  String get gameModeGuessTheCountryDesc =>
      'Identifiez des pays à partir d\'indices progressifs, drapeaux, capitales ou silhouettes';

  @override
  String get gameModeFactOrCapDesc =>
      'Vrai/faux, deux vérités un mensonge, identifiez la fausse affirmation';

  @override
  String get gameModePutInOrderDesc =>
      'Rangez des éléments chronologiquement ou par une propriété mesurable';

  @override
  String get gameModeHowMuchDesc =>
      'Estimation numérique : quantités, dates, distances, populations';

  @override
  String get awardResultAwarded => 'Point attribué.';

  @override
  String get awardResultUnknownPlayer => 'Joueur inconnu.';

  @override
  String get awardResultAlreadyAwarded =>
      'Ce joueur a déjà reçu un point pour cette question.';

  @override
  String get awardResultInvalidatedQuestion =>
      'Question invalidée : aucun point ne peut être attribué.';

  @override
  String get awardResultSessionNotActive => 'La session est terminée.';

  @override
  String get awardResultWrongOrder =>
      'Le classement doit correspondre exactement à la bonne réponse.';
}
