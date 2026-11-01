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
  String get homeSoloHistory => 'Solo history';

  @override
  String get homeSoloHistoryDescription => 'Review your finished solo games';

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

  @override
  String get gameQuitSessionTooltip => 'Quit the session';

  @override
  String get gameResumeTooltip => 'Resume';

  @override
  String get gamePauseTooltip => 'Pause';

  @override
  String get gameQuitDialogTitle => 'Quit the session?';

  @override
  String get gameQuitDialogContent => 'Progress and scores will be lost.';

  @override
  String get gameQuitDialogStay => 'Stay';

  @override
  String get gameQuitDialogQuit => 'Quit';

  @override
  String get gameModeWhichCameFirst => 'Which came first?';

  @override
  String get gameModeGuessTheCountry => 'Guess the country';

  @override
  String get gameModeFactOrCap => 'Fact or fake';

  @override
  String get gameModePutInOrder => 'Put in order';

  @override
  String get gameModeHowMuch => 'How much?';

  @override
  String get finalRankingAppBarTitle => 'Final ranking';

  @override
  String get finalRankingSessionEnded => 'Session over';

  @override
  String finalRankingQuestionsPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# questions played',
      one: '1 question played',
    );
    return '$_temp0';
  }

  @override
  String get finalRankingNewGame => 'Configure a new game';

  @override
  String get finalRankingBackHome => 'Back to home';

  @override
  String get finalRankingPlayerNameFallback => 'Player';

  @override
  String get finalRankingTiedNote => 'Tied with another player';

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
      '1': '1st',
      '2': '2nd',
      '3': '3rd',
      'other': '#th',
    });
    return '$_temp0';
  }

  @override
  String get sessionHistoryTitle => 'Session history';

  @override
  String get sessionHistoryBackTooltip => 'Back';

  @override
  String get sessionHistoryClearTooltip => 'Clear history';

  @override
  String get sessionHistoryClearDialogTitle => 'Clear history?';

  @override
  String get sessionHistoryClearDialogContent =>
      'All saved sessions will be deleted from this device.';

  @override
  String get sessionHistoryClearDialogCancel => 'Cancel';

  @override
  String get sessionHistoryClearDialogConfirm => 'Clear';

  @override
  String get sessionHistoryNoPlayer => 'No player';

  @override
  String get sessionHistoryPlayerFallback => 'Player';

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
      other: '# players',
      one: '1 player',
    );
    return '$_temp0';
  }

  @override
  String get sessionHistoryDeleteSessionTooltip => 'Delete this session';

  @override
  String get sessionHistoryUnavailable => 'History unavailable';

  @override
  String get sessionHistoryNoSessions => 'No saved sessions';

  @override
  String get sessionHistoryUnavailableMessage =>
      'Sessions cannot be read from this device at the moment.';

  @override
  String get sessionHistoryEmptyMessage =>
      'Finish a game to find it here, with scores and questions played.';

  @override
  String get sessionHistoryFooter =>
      'Sessions stay on this device: no account or connection is required.';

  @override
  String get sessionDetailTitle => 'Session details';

  @override
  String get sessionDetailBackTooltip => 'Back';

  @override
  String get sessionDetailFinalRanking => 'Final ranking';

  @override
  String get sessionDetailNoQuestions =>
      'No questions recorded for this session.';

  @override
  String get sessionDetailQuestionsPlayed => 'Questions played';

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
      'Question removed from the library';

  @override
  String sessionDetailPointsFor(String winners) {
    return 'Points for $winners';
  }

  @override
  String get sessionDetailMissingTitle => 'Session not found';

  @override
  String get sessionDetailMissingMessage =>
      'This session may have been deleted from the history.';

  @override
  String get sessionDetailBackToHistory => 'Back to history';

  @override
  String get sessionOutcomeScored => 'Scored';

  @override
  String get sessionOutcomeSkipped => 'Skipped';

  @override
  String get sessionOutcomeInvalidated => 'Invalidated';

  @override
  String get sessionOutcomePending => 'Not completed';

  @override
  String sessionSettingsTimed(int minutes) {
    return '$minutes-minute timed session';
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
    return 'Difficulty : $difficulty';
  }

  @override
  String sessionSettingsCategories(String categories) {
    return 'Categories : $categories';
  }

  @override
  String get sessionSettingsShuffled => 'Questions shuffled';

  @override
  String get sessionSettingsNotShuffled => 'Questions in order';

  @override
  String sessionSettingsDurationLabel(int minutes) {
    return 'Duration: $minutes min';
  }

  @override
  String sessionSettingsQuestionCountLabel(int count) {
    return 'Number of questions: $count';
  }

  @override
  String startupErrorTitle(String error) {
    return 'Unable to load the question bank.\n$error';
  }

  @override
  String get startupErrorRetry => 'Retry';

  @override
  String get gameSetupTitle => 'Game Setup';

  @override
  String get gameSetupPlayersTitle => 'Players';

  @override
  String get gameSetupPlayersSubtitle => '2 to 8 players, on a single device.';

  @override
  String get gameSetupPlayerNameHint => 'Player name';

  @override
  String get gameSetupAddPlayer => 'Add player';

  @override
  String get gameSetupRemovePlayerTooltip => 'Remove player';

  @override
  String get gameSetupModesTitle => 'Game modes';

  @override
  String get gameSetupModesSubtitle => 'One or more modes for the session.';

  @override
  String get gameSetupDifficultyTitle => 'Difficulty';

  @override
  String get gameSetupDifficultySubtitle =>
      'Questions of this level are preferred.';

  @override
  String get gameSetupCategoriesTitle => 'Categories';

  @override
  String get gameSetupCategoriesSubtitleAll => 'All categories.';

  @override
  String gameSetupCategoriesSubtitleSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# categories selected',
      one: '1 category selected',
    );
    return '$_temp0';
  }

  @override
  String get gameSetupLengthTitle => 'Duration or number of questions';

  @override
  String get gameSetupLengthSubtitleTimed =>
      'Timed session: the current question is always completed.';

  @override
  String get gameSetupLengthSubtitleQuestions =>
      'Session limited by number of questions.';

  @override
  String get gameSetupLengthQuestions => 'Questions';

  @override
  String get gameSetupLengthDuration => 'Duration';

  @override
  String get gameSetupDecreaseDurationTooltip => 'Decrease duration';

  @override
  String get gameSetupIncreaseDurationTooltip => 'Increase duration';

  @override
  String get gameSetupDecreaseQuestionsTooltip => 'Fewer questions';

  @override
  String get gameSetupIncreaseQuestionsTooltip => 'More questions';

  @override
  String get gameSetupShuffleTitle => 'Shuffle questions';

  @override
  String get gameSetupShuffleSubtitle => 'Random order for each session.';

  @override
  String get gameSetupStartGame => 'Start game';

  @override
  String get sessionConfigErrorMinPlayers => 'Add at least 2 players.';

  @override
  String get sessionConfigErrorMaxPlayers => 'Maximum 8 players allowed.';

  @override
  String get sessionConfigErrorUniqueNames => 'Player names must be unique.';

  @override
  String get sessionConfigErrorNoMode => 'Select at least one game mode.';

  @override
  String get sessionConfigErrorDurationTooShort =>
      'Duration must be at least 1 minute.';

  @override
  String get sessionConfigErrorQuestionCountTooLow =>
      'Number of questions must be at least 1.';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get categoryHistory => 'History';

  @override
  String get categoryScience => 'Science';

  @override
  String get categoryGeography => 'Geography';

  @override
  String get categoryArts => 'Arts & Culture';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get categoryNature => 'Nature';

  @override
  String get categoryGeneral => 'General Knowledge';

  @override
  String get categoryAfrica => 'Africa';

  @override
  String get gameModeWhichCameFirstDesc =>
      'Compare historical events, discoveries and inventions';

  @override
  String get gameModeGuessTheCountryDesc =>
      'Identify countries from progressive clues, flags, capitals or silhouettes';

  @override
  String get gameModeFactOrCapDesc =>
      'True/false, two truths one lie, identify the false statement';

  @override
  String get gameModePutInOrderDesc =>
      'Arrange items chronologically or by a measurable property';

  @override
  String get gameModeHowMuchDesc =>
      'Numerical estimation: quantities, dates, distances, populations';

  @override
  String get awardResultAwarded => 'Point awarded.';

  @override
  String get awardResultUnknownPlayer => 'Unknown player.';

  @override
  String get awardResultAlreadyAwarded =>
      'This player already received a point for this question.';

  @override
  String get awardResultInvalidatedQuestion =>
      'Question invalidated: no points can be awarded.';

  @override
  String get awardResultSessionNotActive => 'Session is completed.';

  @override
  String get awardResultWrongOrder =>
      'The order must exactly match the correct answer.';

  @override
  String get emptySessionTitle => 'Session';

  @override
  String get emptySessionNoSession => 'No session in progress.';

  @override
  String get emptySessionSetup => 'Configure a game';

  @override
  String get questionLibraryTitle => 'Question library';

  @override
  String get questionFilterMode => 'Mode';

  @override
  String get questionFilterDifficulty => 'Difficulty';

  @override
  String get questionFilterCategory => 'Category';

  @override
  String get questionFilterVariation => 'Variation';

  @override
  String get questionFilterSearchHint => 'Search for a question…';

  @override
  String get questionFilterClearTooltip => 'Clear search';

  @override
  String get questionFilterFilters => 'Filters';

  @override
  String questionFilterActiveCount(int count) {
    return '$count filter active';
  }

  @override
  String questionFilterActiveCountOther(int count) {
    return '$count filters active';
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
  String get questionFilterHideTooltip => 'Hide filters';

  @override
  String get questionFilterShowTooltip => 'Show filters';

  @override
  String get questionLibraryNoResult => 'No question matches';

  @override
  String get questionLibraryNoResultHint =>
      'Modify the search or reset the filters.';

  @override
  String get questionLibrarySelectHint => 'Select a question';

  @override
  String get questionLibrarySelectHintDetail =>
      'Its answer, explanation and source will appear here.';

  @override
  String get questionBodyRevealAnswer => 'Reveal answer';

  @override
  String get questionBodyHideExplanation => 'Hide explanation';

  @override
  String get questionBodyShowExplanation => 'Show explanation';

  @override
  String get questionBodyExplanationTitle => 'Explanation';

  @override
  String get questionBodySource => 'Source:';

  @override
  String get questionDetailExplanation => 'Explanation';

  @override
  String get questionDetailSource => 'Source:';

  @override
  String get questionDetailId => 'ID';

  @override
  String get questionDetailFactGroup => 'Fact group';

  @override
  String get questionDetailClues => 'Clues';

  @override
  String get questionDetailEstimation => 'Estimation';

  @override
  String get questionBodyCluesRevealed => 'Clues revealed:';

  @override
  String get questionBodyNoCluesYet => 'No clues yet.';

  @override
  String get questionBodyElementsToOrder => 'Elements to order';

  @override
  String get questionBodyCompleteOrder => 'Complete order expected';

  @override
  String get questionBodyExpectedAnswer => 'Expected answer';

  @override
  String get questionBodyAcceptedRange => 'Accepted range';

  @override
  String get questionBodyScoringRule => 'Scoring rule';

  @override
  String get questionBodyCorrectAnswer => 'Correct answer';

  @override
  String get questionBodyFirst => 'First';

  @override
  String get questionBodyThen => 'Then';

  @override
  String get questionBodyCountry => 'Country';

  @override
  String get questionBodyCapital => 'Capital';

  @override
  String get questionBodyAcceptedAnswers => 'Accepted answers';

  @override
  String questionBodyStatementTrueFalse(String isTrue) {
    String _temp0 = intl.Intl.selectLogic(isTrue, {
      'true': 'true',
      'false': 'false',
      'other': 'true',
    });
    return 'This statement is $_temp0.';
  }

  @override
  String get questionBodyFalseStatements => 'False statement(s):';

  @override
  String get questionBodyCorrectOrder => 'Correct order:';

  @override
  String get questionBodyValue => 'Value';

  @override
  String get questionVariationChronology => 'Chronology';

  @override
  String get questionVariationClues => 'Clues';

  @override
  String get questionVariationFlag => 'Flag';

  @override
  String get questionVariationCapital => 'Capital';

  @override
  String get questionVariationSilhouette => 'Silhouette';

  @override
  String get questionVariationTrueFalse => 'True or false';

  @override
  String get questionVariationTwoTruthsOneLie => 'Two truths, one lie';

  @override
  String get questionVariationIdentifyFalse => 'Identify the false statement';

  @override
  String get questionVariationByProperty => 'By property';

  @override
  String get questionVariationQuantity => 'Quantity';

  @override
  String get questionVariationDate => 'Date';

  @override
  String get questionVariationDistance => 'Distance';

  @override
  String get questionVariationPopulation => 'Population';

  @override
  String get routerPageNotFound => 'Page not found';

  @override
  String get routerRouteUnknown => 'Unknown route';

  @override
  String get routerBackToHome => 'Back to home';

  @override
  String gameBarScoresTotal(Object total) {
    return 'Scores — total $total';
  }

  @override
  String gameBarQuestionsResolved(Object resolved, Object total) {
    return '$resolved of $total scored';
  }

  @override
  String get gameBarUndoAward => 'Undo';

  @override
  String get gameBarAwardPoint => 'Point';

  @override
  String get gameBarSkip => 'Skip';

  @override
  String get gameBarInvalidate => 'Invalidate';

  @override
  String get gameBarEndSession => 'End session';

  @override
  String get gameBarNextQuestion => 'Next question';

  @override
  String get gameBarSnackBarRoundIncomplete =>
      'Score, skip or invalidate this question before continuing.';

  @override
  String get gameBoardHeaderTitle => 'Scores';

  @override
  String gameBoardHeaderSubtitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# points awarded for this question',
      one: '1 point awarded for this question',
    );
    return '$_temp0';
  }

  @override
  String get gameBoardUndoTooltip => 'Undo point';

  @override
  String get gameBoardAwardOrdering => 'Correct order';

  @override
  String get gameBoardInvalidatedMessage =>
      'Question invalidated: no points can be awarded.';

  @override
  String get gameBoardOrderExactMessage =>
      'Order must be exact to get the point.';

  @override
  String get gameBoardStatusPending => 'In progress';

  @override
  String gameBoardTimeRemaining(Object time) {
    return 'Time remaining: $time';
  }

  @override
  String get gameOrderDialogTitle => 'Announced order';

  @override
  String get gameOrderDialogInstruction =>
      'Select items in the order announced by players.';

  @override
  String get gameOrderDialogSelectedTitle => 'Selected order';

  @override
  String get gameOrderDialogNoSelection => 'No item selected.';

  @override
  String get gameOrderDialogRemainingTitle => 'Remaining items';

  @override
  String get gameOrderDialogRemoveTooltip => 'Remove';

  @override
  String get gameOrderDialogCancel => 'Cancel';

  @override
  String get gameOrderDialogConfirm => 'Validate';

  @override
  String get gameNoticePausedTimer => 'Session paused. The timer is stopped.';

  @override
  String get gameNoticePaused => 'Session paused.';

  @override
  String get gameNoticeTimeExpired =>
      'Time\'s up. Finish this question, then the session will end.';

  @override
  String gameColumnNextClue(Object current, Object total) {
    return 'Next clue ($current/$total)';
  }

  @override
  String gameBoardQuestionNumber(Object number, Object total) {
    return 'Question $number / $total';
  }

  @override
  String get questionFilterReset => 'Reset';

  @override
  String get playerNameHint => 'Player name';

  @override
  String get homeSoloMode => 'Play solo';

  @override
  String get homeSoloModeDescription =>
      'Answer questions yourself and improve with explanations';

  @override
  String get soloSetupTitle => 'Solo setup';

  @override
  String get soloSetupModesTitle => 'Game modes';

  @override
  String get soloSetupModesSubtitle =>
      'One or more modes for your solo session.';

  @override
  String get soloSetupDifficultyTitle => 'Difficulty';

  @override
  String get soloSetupDifficultySubtitle =>
      'Questions of this level are preferred.';

  @override
  String get soloSetupCategoriesTitle => 'Categories';

  @override
  String get soloSetupCategoriesSubtitleAll => 'All categories.';

  @override
  String soloSetupCategoriesSubtitleSelected(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# categories selected',
      one: '1 category selected',
    );
    return '$_temp0';
  }

  @override
  String get soloSetupLengthTitle => 'Number of questions';

  @override
  String get soloSetupLengthSubtitleQuestions =>
      'Session limited by number of questions.';

  @override
  String get soloSetupShuffleTitle => 'Shuffle questions';

  @override
  String get soloSetupShuffleSubtitle => 'Random order for each session.';

  @override
  String get soloStartGame => 'Start solo game';

  @override
  String get soloResumeTitle => 'Solo session in progress';

  @override
  String get soloResumeSubtitle =>
      'You have an unfinished solo session. Resume it?';

  @override
  String get soloResumeButton => 'Resume';

  @override
  String get soloDiscardButton => 'New game';

  @override
  String get soloErrorNoMode => 'Select at least one game mode.';

  @override
  String get soloErrorQuestionCountTooLow =>
      'Number of questions must be at least 1.';

  @override
  String get soloErrorNotEnoughQuestions =>
      'Not enough questions available with these criteria.';

  @override
  String get soloNotSupportedYet => 'This mode is not available in solo yet.';

  @override
  String get soloSkipQuestion => 'Skip this question';

  @override
  String soloQuestionNumber(Object number, Object total) {
    return 'Question $number / $total';
  }

  @override
  String soloScore(Object score) {
    return 'Score: $score';
  }

  @override
  String soloStreak(Object streak) {
    return 'Streak: $streak';
  }

  @override
  String get soloCorrect => 'Correct!';

  @override
  String get soloIncorrect => 'Incorrect.';

  @override
  String soloPointsEarned(int points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '+# pts',
      one: '+1 pt',
    );
    return '$_temp0';
  }

  @override
  String get soloYourAnswer => 'Your answer';

  @override
  String get soloCorrectAnswer => 'Correct answer';

  @override
  String get soloExplanation => 'Explanation';

  @override
  String get soloSource => 'Source:';

  @override
  String get soloNextQuestion => 'Next question';

  @override
  String get soloSeeResults => 'See results';

  @override
  String get soloQuitDialogTitle => 'Quit solo game?';

  @override
  String get soloQuitDialogContent =>
      'Your progress will be saved so you can resume later.';

  @override
  String get soloQuitDialogStay => 'Stay';

  @override
  String get soloQuitDialogQuit => 'Quit';

  @override
  String get soloSummaryTitle => 'Your solo results';

  @override
  String get soloBackHome => 'Back to home';

  @override
  String get soloNoAnswer => '(no answer)';

  @override
  String get soloTrue => 'True';

  @override
  String get soloFalse => 'False';

  @override
  String get soloGuessTheCountryHint => 'Country name';

  @override
  String get soloPutInOrderInstruction => 'Drag items into order';

  @override
  String get soloPutInOrderValidate => 'Validate order';

  @override
  String get soloValidate => 'Validate';

  @override
  String get soloHowMuchHint => 'Your estimate';

  @override
  String get soloHowMuchInvalid => 'Invalid number';

  @override
  String get soloHowMuchReference => 'Reference value';

  @override
  String get soloHowMuchAcceptedRange => 'Accepted range';

  @override
  String get soloHowMuchTolerance => 'Tolerance applied';

  @override
  String soloSummaryMaxStreak(int streak) {
    return 'Max streak: $streak';
  }

  @override
  String soloSummaryQuestionsPlayed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# questions played',
      one: '1 question played',
    );
    return '$_temp0';
  }

  @override
  String get soloSummaryOverallAccuracy => 'Overall accuracy';

  @override
  String get soloSummaryPerCategory => 'Accuracy by category';

  @override
  String get soloSummaryMistakes => 'Mistakes to review';

  @override
  String get soloSummaryNoMistakes => 'No mistakes! Well done.';

  @override
  String get soloSummaryPlayAgain => 'Replay the same game';

  @override
  String get soloSummaryNewSoloSetup => 'New solo setup';

  @override
  String get soloSummaryBackHome => 'Back to home';

  @override
  String get soloHistoryTitle => 'Solo history';

  @override
  String get soloHistoryBackTooltip => 'Back';

  @override
  String get soloHistoryClearTooltip => 'Clear solo history';

  @override
  String get soloHistoryClearDialogTitle => 'Clear solo history?';

  @override
  String get soloHistoryClearDialogContent =>
      'All recorded solo games will be deleted from this device.';

  @override
  String get soloHistoryClearDialogCancel => 'Cancel';

  @override
  String get soloHistoryClearDialogConfirm => 'Clear';

  @override
  String get soloHistoryDeleteSessionTooltip => 'Delete this game';

  @override
  String get soloHistoryDeleteDialogTitle => 'Delete this game?';

  @override
  String get soloHistoryDeleteDialogContent =>
      'This game and its results will be deleted from this device.';

  @override
  String get soloHistoryDeleteDialogCancel => 'Cancel';

  @override
  String get soloHistoryDeleteDialogConfirm => 'Delete';

  @override
  String get soloHistoryNoSessions => 'No solo games recorded';

  @override
  String get soloHistoryEmptyMessage =>
      'Finish a solo game to find it here, with its score and questions.';

  @override
  String get soloHistoryUnavailable => 'Solo history unavailable';

  @override
  String get soloHistoryUnavailableMessage =>
      'Solo games cannot be read on this device at the moment.';

  @override
  String get soloHistoryDate => 'Date';

  @override
  String get soloHistoryAccuracy => 'Accuracy';

  @override
  String soloHistoryQuestions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get soloHistoryFooter =>
      'Solo games stay on this device: no account or connection required.';
}
