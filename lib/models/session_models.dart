import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Outcome of a single question inside a session.
///
/// * [QuestionOutcome.pending] – not resolved yet.
/// * [QuestionOutcome.scored] – at least one player earned a point.
/// * [QuestionOutcome.skipped] – skipped by the quizmaster, no points.
/// * [QuestionOutcome.invalidated] – question withdrawn, no points.
enum QuestionOutcome { pending, scored, skipped, invalidated }

/// Session status, mapped onto the existing [GameStatus] values:
/// not started -> `pending`, active -> `inProgress`, paused -> `paused`,
/// completed -> `completed`.
const GameStatus sessionStatusNotStarted = GameStatus.pending;
const GameStatus sessionStatusActive = GameStatus.inProgress;
const GameStatus sessionStatusPaused = GameStatus.paused;
const GameStatus sessionStatusCompleted = GameStatus.completed;

/// Why a [SessionConfig] failed validation.
///
/// Kept free of any UI dependency so the models layer stays pure.
enum SessionConfigError {
  minPlayers,
  maxPlayers,
  uniqueNames,
  noMode,
  durationTooShort,
  questionCountTooLow,
}

/// Quizmaster choices made on the game-setup screen.
///
/// This complements [GameSettings], which stores a single category and no game
/// modes: a session can mix modes, categories and a duration. [toGameSettings]
/// maps the draft onto [GameSettings] for the session record.
class SessionConfig {
  final List<String> playerNames;
  final List<GameMode> modes;
  final List<QuestionCategory> categories;
  final Difficulty difficulty;
  final int questionCount;
  final int? sessionDurationMinutes;
  final bool shuffleQuestions;

  const SessionConfig({
    this.playerNames = const [],
    this.modes = const [],
    this.categories = const [],
    this.difficulty = Difficulty.medium,
    this.questionCount = 10,
    this.sessionDurationMinutes,
    this.shuffleQuestions = true,
  });

  /// True when the session is limited by duration instead of question count.
  bool get isTimed => sessionDurationMinutes != null;

  Duration? get sessionDuration => sessionDurationMinutes == null
      ? null
      : Duration(minutes: sessionDurationMinutes!);

  int get minPlayers => 2;
  int get maxPlayers => 8;

  SessionConfig copyWith({
    List<String>? playerNames,
    List<GameMode>? modes,
    List<QuestionCategory>? categories,
    Difficulty? difficulty,
    int? questionCount,
    int? sessionDurationMinutes,
    bool clearSessionDuration = false,
    bool? shuffleQuestions,
  }) {
    return SessionConfig(
      playerNames: playerNames ?? this.playerNames,
      modes: modes ?? this.modes,
      categories: categories ?? this.categories,
      difficulty: difficulty ?? this.difficulty,
      questionCount: questionCount ?? this.questionCount,
      sessionDurationMinutes: clearSessionDuration
          ? null
          : sessionDurationMinutes ?? this.sessionDurationMinutes,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
    );
  }

  /// Maps the draft onto the existing persistence model.
  GameSettings toGameSettings() {
    return GameSettings(
      questionCount: questionCount,
      timePerQuestion: sessionDurationMinutes ?? 0,
      randomizeQuestions: shuffleQuestions,
      showCorrectAnswer: false,
      category: categories.isEmpty
          ? 'general'
          : categories.map((c) => c.name).join(', '),
      difficulty: difficulty.name,
    );
  }

  /// Validation errors as error codes, with no UI dependency.
  List<SessionConfigError> validate() {
    final errors = <SessionConfigError>[];

    final namedPlayers = playerNames
        .map((n) => n.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    if (namedPlayers.length < minPlayers) {
      errors.add(SessionConfigError.minPlayers);
    }
    if (namedPlayers.length > maxPlayers) {
      errors.add(SessionConfigError.maxPlayers);
    }
    if (namedPlayers.toSet().length != namedPlayers.length) {
      errors.add(SessionConfigError.uniqueNames);
    }
    if (modes.isEmpty) {
      errors.add(SessionConfigError.noMode);
    }
    if (isTimed) {
      if (sessionDurationMinutes! < 1) {
        errors.add(SessionConfigError.durationTooShort);
      }
    } else if (questionCount < 1) {
      errors.add(SessionConfigError.questionCountTooLow);
    }

    return errors;
  }

  /// Whether the config has no validation errors.
  bool get isValid => validate().isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionConfig &&
          runtimeType == other.runtimeType &&
          listEqualsByValue(playerNames, other.playerNames) &&
          listEqualsByValue(modes, other.modes) &&
          listEqualsByValue(categories, other.categories) &&
          difficulty == other.difficulty &&
          questionCount == other.questionCount &&
          sessionDurationMinutes == other.sessionDurationMinutes &&
          shuffleQuestions == other.shuffleQuestions;

  @override
  int get hashCode => Object.hash(
    listHashCode(playerNames),
    listHashCode(modes),
    listHashCode(categories),
    difficulty,
    questionCount,
    sessionDurationMinutes,
    shuffleQuestions,
  );

  @override
  String toString() =>
      'SessionConfig(players: $playerNames, modes: ${modes.map((m) => m.name).toList()}, '
      'categories: ${categories.map((c) => c.name).toList()}, difficulty: ${difficulty.name}, '
      'questionCount: $questionCount, duration: $sessionDurationMinutes, shuffle: $shuffleQuestions)';
}

/// Runtime state of one question inside the running session.
class RoundState {
  final String questionId;
  final QuestionOutcome outcome;
  final Set<String> awardedPlayerIds;
  final bool answerRevealed;
  final bool explanationRevealed;
  final int revealedClues;

  const RoundState({
    required this.questionId,
    this.outcome = QuestionOutcome.pending,
    this.awardedPlayerIds = const {},
    this.answerRevealed = false,
    this.explanationRevealed = false,
    this.revealedClues = 0,
  });

  bool get isComplete => outcome != QuestionOutcome.pending;

  bool get isScored => outcome == QuestionOutcome.scored;

  bool get isInvalidated => outcome == QuestionOutcome.invalidated;

  bool awardsPointTo(String playerId) => awardedPlayerIds.contains(playerId);

  RoundState copyWith({
    String? questionId,
    QuestionOutcome? outcome,
    Set<String>? awardedPlayerIds,
    bool? answerRevealed,
    bool? explanationRevealed,
    int? revealedClues,
  }) {
    return RoundState(
      questionId: questionId ?? this.questionId,
      outcome: outcome ?? this.outcome,
      awardedPlayerIds: awardedPlayerIds ?? this.awardedPlayerIds,
      answerRevealed: answerRevealed ?? this.answerRevealed,
      explanationRevealed: explanationRevealed ?? this.explanationRevealed,
      revealedClues: revealedClues ?? this.revealedClues,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundState &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId &&
          outcome == other.outcome &&
          setEqualsByValue(awardedPlayerIds, other.awardedPlayerIds) &&
          answerRevealed == other.answerRevealed &&
          explanationRevealed == other.explanationRevealed &&
          revealedClues == other.revealedClues;

  @override
  int get hashCode => Object.hash(
    questionId,
    outcome,
    setHashCode(awardedPlayerIds),
    answerRevealed,
    explanationRevealed,
    revealedClues,
  );

  @override
  String toString() =>
      'RoundState(questionId: $questionId, outcome: ${outcome.name}, awarded: $awardedPlayerIds, '
      'answerRevealed: $answerRevealed, explanationRevealed: $explanationRevealed, revealedClues: $revealedClues)';
}

/// One line of the final ranking.
class FinalRankingEntry {
  final Player player;
  final int rank;
  final bool isTied;

  const FinalRankingEntry({
    required this.player,
    required this.rank,
    required this.isTied,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinalRankingEntry &&
          runtimeType == other.runtimeType &&
          player == other.player &&
          rank == other.rank &&
          isTied == other.isTied;

  @override
  int get hashCode => Object.hash(player, rank, isTied);

  @override
  String toString() =>
      'FinalRankingEntry(${player.name}, score: ${player.score}, rank: $rank, tied: $isTied)';
}

/// Why an award request was refused.
enum AwardResult {
  awarded,
  unknownPlayer,
  alreadyAwarded,
  invalidatedQuestion,
  sessionNotActive,
  wrongOrder,
}

/// Result of moving to the next question.
enum NextResult { advanced, sessionCompleted, roundIncomplete, noMoreQuestions }

bool setEqualsByValue<T>(Set<T>? a, Set<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  return a.containsAll(b);
}

int setHashCode<T>(Set<T>? set) => set == null ? 0 : Object.hashAll(set);
