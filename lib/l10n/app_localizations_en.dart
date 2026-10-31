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
  String get gameSetupMinPlayersError => 'Add at least 2 players.';

  @override
  String get gameSetupMaxPlayersError => 'Maximum 8 players allowed.';

  @override
  String get gameSetupUniqueNamesError => 'Player names must be unique.';

  @override
  String get gameSetupSelectModeError => 'Select at least one game mode.';

  @override
  String get gameSetupDurationMinError => 'Duration must be at least 1 minute.';

  @override
  String get gameSetupQuestionCountMinError =>
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
}
