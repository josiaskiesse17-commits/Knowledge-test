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
  String get sessionConfigErrorMinPlayers => 'Ajoutez au moins 2 joueurs.';

  @override
  String get sessionConfigErrorMaxPlayers => 'Maximum 8 joueurs autorisés.';

  @override
  String get sessionConfigErrorUniqueNames =>
      'Les noms des joueurs doivent être uniques.';

  @override
  String get sessionConfigErrorNoMode =>
      'Sélectionnez au moins un mode de jeu.';

  @override
  String get sessionConfigErrorDurationTooShort =>
      'La durée doit être d\'au moins 1 minute.';

  @override
  String get sessionConfigErrorQuestionCountTooLow =>
      'Le nombre de questions doit être d\'au moins 1.';

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

  @override
  String get emptySessionTitle => 'Session';

  @override
  String get emptySessionNoSession => 'Aucune session en cours.';

  @override
  String get emptySessionSetup => 'Configurer une partie';

  @override
  String get questionLibraryTitle => 'Bibliothèque de questions';

  @override
  String get questionFilterMode => 'Mode';

  @override
  String get questionFilterDifficulty => 'Difficulté';

  @override
  String get questionFilterCategory => 'Catégorie';

  @override
  String get questionFilterVariation => 'Variation';

  @override
  String get questionFilterSearchHint => 'Rechercher une question…';

  @override
  String get questionFilterClearTooltip => 'Effacer la recherche';

  @override
  String get questionFilterFilters => 'Filtres';

  @override
  String questionFilterActiveCount(int count) {
    return '$count filtre actif';
  }

  @override
  String questionFilterActiveCountOther(int count) {
    return '$count filtres actifs';
  }

  @override
  String questionFilterResultCount(int count) {
    return '$count question';
  }

  @override
  String questionFilterResultCountOther(int count) {
    return '$count questions';
  }

  @override
  String get questionFilterHideTooltip => 'Masquer les filtres';

  @override
  String get questionFilterShowTooltip => 'Afficher les filtres';

  @override
  String get questionLibraryNoResult => 'Aucune question ne correspond';

  @override
  String get questionLibraryNoResultHint =>
      'Modifiez la recherche ou réinitialisez les filtres.';

  @override
  String get questionLibrarySelectHint => 'Sélectionnez une question';

  @override
  String get questionLibrarySelectHintDetail =>
      'Sa réponse, son explication et sa source s\'afficheront ici.';

  @override
  String get questionBodyRevealAnswer => 'Révéler la réponse';

  @override
  String get questionBodyHideExplanation => 'Masquer l\'explication';

  @override
  String get questionBodyShowExplanation => 'Voir l\'explication';

  @override
  String get questionBodyExplanationTitle => 'Explication';

  @override
  String get questionBodySource => 'Source :';

  @override
  String get questionDetailExplanation => 'Explication';

  @override
  String get questionDetailSource => 'Source :';

  @override
  String get questionDetailId => 'Identifiant';

  @override
  String get questionDetailFactGroup => 'Groupe de fait :';

  @override
  String get questionDetailClues => 'Indices';

  @override
  String get questionDetailEstimation => 'Estimation';

  @override
  String get questionBodyCluesRevealed => 'Indices révélés :';

  @override
  String get questionBodyNoCluesYet => 'Aucun indice pour le moment.';

  @override
  String get questionBodyElementsToOrder => 'Éléments à classer';

  @override
  String get questionBodyCompleteOrder => 'Classement complet attendu';

  @override
  String get questionBodyExpectedAnswer => 'Réponse attendue';

  @override
  String get questionBodyAcceptedRange => 'Plage acceptée';

  @override
  String get questionBodyScoringRule => 'Règle de score';

  @override
  String get questionBodyCorrectAnswer => 'Bonne réponse';

  @override
  String get questionBodyFirst => 'En premier';

  @override
  String get questionBodyThen => 'Ensuite';

  @override
  String get questionBodyCountry => 'Pays';

  @override
  String get questionBodyCapital => 'Capitale';

  @override
  String get questionBodyAcceptedAnswers => 'Réponses acceptées';

  @override
  String questionBodyStatementTrueFalse(String isTrue) {
    String _temp0 = intl.Intl.selectLogic(isTrue, {
      'true': 'vraie',
      'false': 'fausse',
      'other': 'vraie',
    });
    return 'Cette affirmation est $_temp0.';
  }

  @override
  String get questionBodyFalseStatements => 'Affirmation(s) fausse(s) :';

  @override
  String get questionBodyCorrectOrder => 'Ordre correct :';

  @override
  String get questionBodyValue => 'Valeur';

  @override
  String get questionVariationChronology => 'Chronologie';

  @override
  String get questionVariationClues => 'Indices';

  @override
  String get questionVariationFlag => 'Drapeau';

  @override
  String get questionVariationCapital => 'Capitale';

  @override
  String get questionVariationSilhouette => 'Silhouette';

  @override
  String get questionVariationTrueFalse => 'Vrai ou faux';

  @override
  String get questionVariationTwoTruthsOneLie => 'Deux vérités, un mensonge';

  @override
  String get questionVariationIdentifyFalse => 'Trouve la fausse affirmation';

  @override
  String get questionVariationByProperty => 'Par propriété';

  @override
  String get questionVariationQuantity => 'Quantité';

  @override
  String get questionVariationDate => 'Date';

  @override
  String get questionVariationDistance => 'Distance';

  @override
  String get questionVariationPopulation => 'Population';

  @override
  String get routerPageNotFound => 'Page non trouvée';

  @override
  String get routerRouteUnknown => 'Route inconnue';

  @override
  String get routerBackToHome => 'Retour à l\'accueil';

  @override
  String gameBarScoresTotal(Object total) {
    return 'Scores — total $total';
  }

  @override
  String gameBarQuestionsResolved(Object resolved, Object total) {
    return '$resolved/$total notées';
  }

  @override
  String get gameBarUndoAward => 'Annuler';

  @override
  String get gameBarAwardPoint => 'Point';

  @override
  String get gameBarSkip => 'Passer';

  @override
  String get gameBarInvalidate => 'Invalider';

  @override
  String get gameBarEndSession => 'Terminer la session';

  @override
  String get gameBarNextQuestion => 'Question suivante';

  @override
  String get gameBarSnackBarRoundIncomplete =>
      'Notez, passez ou invalidez cette question avant de continuer.';

  @override
  String get gameBoardHeaderTitle => 'Scores';

  @override
  String gameBoardHeaderSubtitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# points attribués pour cette question',
      one: '1 point attribué pour cette question',
    );
    return '$_temp0';
  }

  @override
  String get gameBoardUndoTooltip => 'Annuler le point';

  @override
  String get gameBoardAwardOrdering => 'Bon classement';

  @override
  String get gameBoardInvalidatedMessage =>
      'Question invalidée : aucun point ne peut être attribué.';

  @override
  String get gameBoardOrderExactMessage =>
      'Le classement doit être exact pour obtenir le point.';

  @override
  String get gameBoardStatusPending => 'En cours';

  @override
  String gameBoardTimeRemaining(Object time) {
    return 'Temps restant : $time';
  }

  @override
  String get gameOrderDialogTitle => 'Classement annoncé';

  @override
  String get gameOrderDialogInstruction =>
      'Sélectionnez les éléments dans l\'ordre annoncé par les joueurs.';

  @override
  String get gameOrderDialogSelectedTitle => 'Ordre choisi';

  @override
  String get gameOrderDialogNoSelection => 'Aucun élément sélectionné.';

  @override
  String get gameOrderDialogRemainingTitle => 'Éléments restants';

  @override
  String get gameOrderDialogRemoveTooltip => 'Retirer';

  @override
  String get gameOrderDialogCancel => 'Annuler';

  @override
  String get gameOrderDialogConfirm => 'Valider';

  @override
  String get gameNoticePausedTimer =>
      'Session en pause. Le chronomètre est arrêté.';

  @override
  String get gameNoticePaused => 'Session en pause.';

  @override
  String get gameNoticeTimeExpired =>
      'Temps écoulé. Terminez cette question, puis la session s\'arrêtera.';

  @override
  String gameColumnNextClue(Object current, Object total) {
    return 'Indice suivant ($current/$total)';
  }

  @override
  String gameBoardQuestionNumber(Object number, Object total) {
    return 'Question $number / $total';
  }

  @override
  String get questionFilterReset => 'Réinitialiser';

  @override
  String get playerNameHint => 'Nom du joueur';
}
