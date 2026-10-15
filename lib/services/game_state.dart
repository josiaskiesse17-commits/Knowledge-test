import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';

/// Immutable snapshot of a running session.
class GameState {
  final SessionConfig config;
  final List<Player> players;
  final List<BaseQuestion> questions;
  final List<RoundState> rounds;
  final GameStatus status;
  final int currentIndex;
  final int? remainingSeconds;
  final bool timeExpired;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const GameState({
    required this.config,
    this.players = const [],
    this.questions = const [],
    this.rounds = const [],
    this.status = GameStatus.pending,
    this.currentIndex = 0,
    this.remainingSeconds,
    this.timeExpired = false,
    this.startedAt,
    this.completedAt,
  });

  BaseQuestion? get currentQuestion =>
      (currentIndex >= 0 && currentIndex < questions.length) ? questions[currentIndex] : null;

  RoundState? get currentRound =>
      (currentIndex >= 0 && currentIndex < rounds.length) ? rounds[currentIndex] : null;

  bool get isTimedSession => config.isTimed;

  bool get isActive => status == GameStatus.inProgress;

  bool get isPaused => status == GameStatus.paused;

  bool get isCompleted => status == GameStatus.completed;

  /// A session the quizmaster left without finishing. It is recorded as
  /// cancelled and never written to the history as a completed session.
  bool get isCancelled => status == GameStatus.cancelled;

  bool get isOver => isCompleted || isCancelled;

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  bool get hasQuestions => questions.isNotEmpty;

  /// 1-based number of the question being played.
  int get questionNumber => hasQuestions ? currentIndex + 1 : 0;

  int get resolvedQuestionCount => rounds.where((r) => r.isComplete).length;

  int get totalScore => players.fold(0, (sum, p) => sum + p.score);

  /// True when nothing prevents the session from ending: the clock ran out or
  /// the last question is resolved.
  bool get canEndSession => timeExpired || (isLastQuestion && (currentRound?.isComplete ?? false));

  GameState copyWith({
    SessionConfig? config,
    List<Player>? players,
    List<BaseQuestion>? questions,
    List<RoundState>? rounds,
    GameStatus? status,
    int? currentIndex,
    int? remainingSeconds,
    bool clearRemainingSeconds = false,
    bool? timeExpired,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return GameState(
      config: config ?? this.config,
      players: players ?? this.players,
      questions: questions ?? this.questions,
      rounds: rounds ?? this.rounds,
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds:
          clearRemainingSeconds ? null : remainingSeconds ?? this.remainingSeconds,
      timeExpired: timeExpired ?? this.timeExpired,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() =>
      'GameState(status: ${status.name}, question: $questionNumber/${questions.length}, '
      'players: ${players.map((p) => '${p.name}:${p.score}').toList()}, remaining: $remainingSeconds, '
      'timeExpired: $timeExpired)';
}
