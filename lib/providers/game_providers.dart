import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/repositories/question_repository.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Question source used by the app.
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  throw StateError('questionRepositoryProvider must be overridden');
});

/// Draft of the session being configured on the setup screen.
///
/// Starts with two empty players and every game mode selected, which is the
/// quickest setup for the quizmaster.
final sessionSetupProvider =
    StateNotifierProvider<SessionSetupNotifier, SessionConfig>((ref) {
      return SessionSetupNotifier();
    });

SessionConfig get _defaultConfig =>
    SessionConfig(playerNames: const ['', ''], modes: GameMode.values.toList());

class SessionSetupNotifier extends StateNotifier<SessionConfig> {
  SessionSetupNotifier() : super(_defaultConfig);

  void setPlayers(List<String> names) =>
      state = state.copyWith(playerNames: names);

  void updatePlayerName(int index, String name) {
    final names = [...state.playerNames];
    if (index < 0 || index >= names.length) return;
    names[index] = name;
    state = state.copyWith(playerNames: names);
  }

  void addPlayer() {
    if (state.playerNames.length >= state.maxPlayers) return;
    state = state.copyWith(playerNames: [...state.playerNames, '']);
  }

  void removePlayer(int index) {
    if (state.playerNames.length <= state.minPlayers) return;
    final names = [...state.playerNames]..removeAt(index);
    state = state.copyWith(playerNames: names);
  }

  void toggleMode(GameMode mode) {
    final modes = [...state.modes];
    if (!modes.remove(mode)) modes.add(mode);
    state = state.copyWith(modes: modes);
  }

  void toggleCategory(QuestionCategory category) {
    final categories = [...state.categories];
    if (!categories.remove(category)) categories.add(category);
    state = state.copyWith(categories: categories);
  }

  void setDifficulty(Difficulty difficulty) =>
      state = state.copyWith(difficulty: difficulty);

  void setQuestionCount(int count) =>
      state = state.copyWith(questionCount: count);

  void setSessionDurationMinutes(int? minutes) {
    state = minutes == null
        ? state.copyWith(clearSessionDuration: true)
        : state.copyWith(sessionDurationMinutes: minutes);
  }

  void toggleShuffle() =>
      state = state.copyWith(shuffleQuestions: !state.shuffleQuestions);

  void reset() => state = _defaultConfig;
}

/// Controls the running session: rules live in [GameRules], this controller only
/// owns the countdown timer and exposes the resulting [GameState].
final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) {
    final repository = ref.watch(questionRepositoryProvider);
    return GameController(repository);
  },
);

class GameController extends StateNotifier<GameState> {
  final QuestionRepository _repository;
  Timer? _timer;

  GameController(this._repository)
    : super(
        GameRules.buildSession(
          config: const SessionConfig(),
          availableQuestions: _repository.getAllQuestions(),
        ),
      );

  /// Prepares a session from the quizmaster's draft.
  ///
  /// [recentQuestionIds] are the question ids of the stored sessions, most
  /// recent first: they are played again only when the fresh questions of the
  /// selected modes and filters are not enough to fill the session.
  ///
  /// Returns the validation errors of the draft, empty when the session is
  /// ready to be started.
  List<String> prepare(
    SessionConfig config, {
    List<String> recentQuestionIds = const [],
  }) {
    final errors = config.validate();
    state = GameRules.buildSession(
      config: config,
      availableQuestions: _repository.getAllQuestions(),
      recentQuestionIds: recentQuestionIds,
    );
    return errors;
  }

  void start() {
    state = GameRules.start(state);
    _syncTimer();
  }

  void pause() {
    state = GameRules.pause(state);
    _stopTimer();
  }

  void resume() {
    state = GameRules.resume(state);
    _syncTimer();
  }

  void revealAnswer() => state = GameRules.revealAnswer(state);

  void revealExplanation() => state = GameRules.revealExplanation(state);

  void revealNextClue() => state = GameRules.revealNextClue(state);

  AwardResult awardPoint(String playerId, {List<String>? announcedOrder}) {
    final (state: nextState, result: result) = GameRules.awardPoint(
      state,
      playerId,
      announcedOrder: announcedOrder,
    );
    state = nextState;
    return result;
  }

  bool undoAward(String playerId) {
    final (state: nextState, removed: removed) = GameRules.undoAward(
      state,
      playerId,
    );
    state = nextState;
    return removed;
  }

  bool skip() {
    final (state: nextState, ok: ok) = GameRules.skipQuestion(state);
    state = nextState;
    return ok;
  }

  bool invalidate() {
    final (state: nextState, ok: ok) = GameRules.invalidateQuestion(state);
    state = nextState;
    return ok;
  }

  NextResult next() {
    final (state: nextState, result: result) = GameRules.nextQuestion(state);
    state = nextState;
    _syncTimer();
    return result;
  }

  void endSession() {
    state = GameRules.endSession(state);
    _stopTimer();
  }

  /// Ends the session because the quizmaster left it. The session is cancelled
  /// and never saved to the history as a completed one.
  void abandon() {
    state = GameRules.abandonSession(state);
    _stopTimer();
  }

  List<FinalRankingEntry> get rankings => GameRules.rankings(state);

  bool isSequenceCorrect(List<String> orderedIds) =>
      GameRules.isSequenceCorrect(state, orderedIds);

  String formatRemainingTime() =>
      GameRules.formatDuration(state.remainingSeconds);

  /// Starts, restarts or stops the countdown so there is never more than one
  /// periodic timer running.
  void _syncTimer() {
    _stopTimer();
    if (!state.isTimedSession || !state.isActive || state.timeExpired) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      state = GameRules.tick(state);
      if (state.timeExpired) _stopTimer();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
