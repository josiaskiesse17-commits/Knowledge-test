import 'dart:math';

import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/services/game_state.dart';

export 'game_state.dart';

/// Pure game rules. Every method returns a new [GameState] so the rules can be
/// unit tested without Flutter, timers or widgets.
class GameRules {
  const GameRules._();

  /// Builds the initial state of a session from the quizmaster's draft.
  ///
  /// Questions are picked from [availableQuestions]: first the ones matching the
  /// selected modes (and categories when some are selected), preferring the
  /// requested difficulty. Questions sharing a `factGroupId` are never selected
  /// twice, and the same question is never played twice in one session.
  ///
  /// [recentQuestionIds] lists the questions of the saved sessions, most recent
  /// first. Never-used questions are preferred; the cross-session rule is
  /// relaxed gradually when the pool is too small to fill the session, but the
  /// within-session rules above are never relaxed.
  ///
  /// The selected categories are kept even when they hold fewer questions than
  /// requested: the session then plays those questions only. The category
  /// filter is dropped only when it leaves no eligible question at all, so a
  /// session can always start.
  static GameState buildSession({
    required SessionConfig config,
    required List<BaseQuestion> availableQuestions,
    List<String> recentQuestionIds = const [],
    Random? random,
  }) {
    final normalizedConfig = _normalizeConfig(config);

    final byModes = availableQuestions
        .where((q) => normalizedConfig.modes.contains(q.mode))
        .toList();

    final byModesAndCategories = byModes
        .where((q) => normalizedConfig.categories.isEmpty ||
            normalizedConfig.categories.contains(q.category))
        .toList();

    // The selected categories are respected as long as they hold at least one
    // eligible question: a session that is shorter than the requested number of
    // questions still plays only the chosen categories. Dropping the filter
    // just because the pool is smaller than the request would silently ignore
    // the quizmaster's selection.
    var pool = byModesAndCategories;

    // No eligible question at all in the selected categories: widen to the
    // whole selected modes, then to everything, so the session can start.
    if (pool.isEmpty && byModes.isNotEmpty) {
      pool = byModes;
    }
    if (pool.isEmpty) {
      pool = availableQuestions;
    }

    final selected = _pickQuestions(
      pool: pool,
      count: normalizedConfig.questionCount,
      difficulty: normalizedConfig.difficulty,
      modes: normalizedConfig.modes,
      shuffle: normalizedConfig.shuffleQuestions,
      recentQuestionIds: recentQuestionIds,
      random: random,
    );

    final players = [
      for (var i = 0; i < normalizedConfig.playerNames.length; i++)
        Player(
          id: 'p${i + 1}',
          name: normalizedConfig.playerNames[i],
          score: 0,
          isActive: true,
        ),
    ];

    return GameState(
      config: normalizedConfig,
      players: players,
      questions: selected,
      rounds: [for (final q in selected) RoundState(questionId: q.id)],
      status: sessionStatusNotStarted,
      remainingSeconds: normalizedConfig.isTimed
          ? normalizedConfig.sessionDuration!.inSeconds
          : null,
    );
  }

  /// Reorders players/rounds when the quizmaster edits the names, questionCount
  /// or shuffle flag before starting.
  static GameState updateConfig(
    GameState state,
    SessionConfig config, {
    List<String> recentQuestionIds = const [],
  }) {
    final normalized = _normalizeConfig(config);
    final targetCount = normalized.questionCount;

    var questions = state.questions;
    if (questions.length > targetCount) {
      questions = questions.sublist(0, targetCount);
    } else if (questions.length < targetCount) {
      final extra = _pickQuestions(
        pool: state.questions.isEmpty ? const <BaseQuestion>[] : state.questions,
        count: targetCount,
        difficulty: normalized.difficulty,
        modes: normalized.modes,
        shuffle: normalized.shuffleQuestions,
        recentQuestionIds: recentQuestionIds,
      );
      questions = questions.isEmpty ? extra : questions;
    }

    return state.copyWith(
      config: normalized,
      players: [
        for (var i = 0; i < normalized.playerNames.length; i++)
          Player(
            id: 'p${i + 1}',
            name: normalized.playerNames[i],
            score: 0,
            isActive: true,
          ),
      ],
      questions: questions,
      rounds: [for (final q in questions) RoundState(questionId: q.id)],
    );
  }

  /// Starts the session.
  static GameState start(GameState state, {DateTime? now}) {
    if (!state.hasQuestions) return state;
    if (state.isActive || state.isPaused) return state;
    return state.copyWith(
      status: sessionStatusActive,
      startedAt: now ?? DateTime.now(),
      completedAt: null,
    );
  }

  static GameState pause(GameState state) {
    if (!state.isActive) return state;
    return state.copyWith(status: sessionStatusPaused);
  }

  static GameState resume(GameState state) {
    if (!state.isPaused) return state;
    if (state.timeExpired) return state;
    return state.copyWith(status: sessionStatusActive);
  }

  /// Advances the countdown of a timed session by one second.
  ///
  /// Expiring the clock never interrupts the current question: it only records
  /// that the session may end once the current question is resolved.
  static GameState tick(GameState state) {
    if (!state.isActive || !state.isTimedSession) return state;
    if (state.remainingSeconds == null) return state;

    final next = state.remainingSeconds! - 1;
    if (next <= 0) {
      return state.copyWith(remainingSeconds: 0, timeExpired: true);
    }
    return state.copyWith(remainingSeconds: next);
  }

  static GameState revealAnswer(GameState state) {
    final round = state.currentRound;
    if (round == null || state.isOver) return state;
    return _updateCurrentRound(state, round.copyWith(answerRevealed: true));
  }

  static GameState revealExplanation(GameState state) {
    final round = state.currentRound;
    if (round == null || state.isOver) return state;
    return _updateCurrentRound(state, round.copyWith(explanationRevealed: true));
  }

  static GameState revealNextClue(GameState state) {
    final round = state.currentRound;
    if (round == null || state.isOver) return state;

    final question = state.currentQuestion;
    final maxClues = question is GuessTheCountryQuestion ? question.clues.length : 0;
    if (round.revealedClues >= maxClues) return state;

    return _updateCurrentRound(
      state,
      round.copyWith(revealedClues: round.revealedClues + 1),
    );
  }

  /// Awards one point to [playerId].
  ///
  /// For ordering questions, [announcedOrder] is required and must match the
  /// complete correct sequence: no partial credit is ever awarded.
  static ({GameState state, AwardResult result}) awardPoint(
    GameState state,
    String playerId, {
    List<String>? announcedOrder,
  }) {
    if (state.isOver) return (state: state, result: AwardResult.sessionNotActive);

    final round = state.currentRound;
    if (round == null) return (state: state, result: AwardResult.sessionNotActive);
    if (round.isInvalidated) return (state: state, result: AwardResult.invalidatedQuestion);
    if (round.awardsPointTo(playerId)) return (state: state, result: AwardResult.alreadyAwarded);

    final exists = state.players.any((p) => p.id == playerId);
    if (!exists) return (state: state, result: AwardResult.unknownPlayer);

    final question = state.currentQuestion;
    if (question is PutInOrderQuestion) {
      final order = announcedOrder;
      if (order == null || !isSequenceCorrect(state, order)) {
        return (state: state, result: AwardResult.wrongOrder);
      }
    }

    final players = [
      for (final player in state.players)
        if (player.id == playerId) player.copyWith(score: player.score + 1) else player,
    ];

    final updatedRound = round.copyWith(
      outcome: QuestionOutcome.scored,
      awardedPlayerIds: {...round.awardedPlayerIds, playerId},
    );

    return (
      state: _updateCurrentRound(state.copyWith(players: players), updatedRound),
      result: AwardResult.awarded,
    );
  }

  /// Removes a point awarded by mistake, before the quizmaster moves on.
  static ({GameState state, bool removed}) undoAward(GameState state, String playerId) {
    final round = state.currentRound;
    if (round == null || state.isOver) return (state: state, removed: false);
    if (!round.awardsPointTo(playerId)) return (state: state, removed: false);

    final players = [
      for (final player in state.players)
        if (player.id == playerId) player.copyWith(score: player.score - 1) else player,
    ];

    final remainingAwards = {...round.awardedPlayerIds}..remove(playerId);
    final updatedRound = round.copyWith(
      awardedPlayerIds: remainingAwards,
      outcome: remainingAwards.isEmpty ? QuestionOutcome.pending : QuestionOutcome.scored,
    );

    return (
      state: _updateCurrentRound(state.copyWith(players: players), updatedRound),
      removed: true,
    );
  }

  /// Marks the current question as skipped. Refused once the question is scored,
  /// so an accidental tap cannot remove awarded points.
  static ({GameState state, bool ok}) skipQuestion(GameState state) {
    final round = state.currentRound;
    if (round == null || state.isOver) return (state: state, ok: false);
    if (round.isComplete) return (state: state, ok: false);

    return (
      state: _updateCurrentRound(
        state,
        round.copyWith(outcome: QuestionOutcome.skipped),
      ),
      ok: true,
    );
  }

  /// Marks the current question as invalidated: no points can be awarded, and
  /// any point already given is taken back.
  static ({GameState state, bool ok}) invalidateQuestion(GameState state) {
    final round = state.currentRound;
    if (round == null || state.isOver) return (state: state, ok: false);
    if (round.isInvalidated) return (state: state, ok: false);

    final players = state.players
        .map((player) => round.awardsPointTo(player.id)
            ? player.copyWith(score: player.score - 1)
            : player)
        .toList();

    return (
      state: _updateCurrentRound(
        state.copyWith(players: players),
        round.copyWith(
          outcome: QuestionOutcome.invalidated,
          awardedPlayerIds: const {},
        ),
      ),
      ok: true,
    );
  }

  /// Moves to the next question, or ends the session.
  ///
  /// The current question must be resolved first: the quizmaster awards points,
  /// skips or invalidates it. When the clock has run out, ending the session
  /// happens on this same action instead of a new question.
  static ({GameState state, NextResult result}) nextQuestion(GameState state) {
    if (state.isOver) return (state: state, result: NextResult.sessionCompleted);
    if (!state.hasQuestions) return (state: state, result: NextResult.noMoreQuestions);

    final round = state.currentRound;
    if (round == null || !round.isComplete) {
      return (state: state, result: NextResult.roundIncomplete);
    }

    final mustEnd = state.timeExpired || state.isLastQuestion;
    if (mustEnd) {
      return (
        state: state.copyWith(
          status: sessionStatusCompleted,
          completedAt: DateTime.now(),
        ),
        result: NextResult.sessionCompleted,
      );
    }

    return (
      state: state.copyWith(currentIndex: state.currentIndex + 1),
      result: NextResult.advanced,
    );
  }

  /// Ends the session immediately (quizmaster action).
  static GameState endSession(GameState state) {
    if (state.isOver) return state;
    return state.copyWith(
      status: sessionStatusCompleted,
      completedAt: DateTime.now(),
    );
  }

  /// Ends the session because the quizmaster left it: the session is cancelled
  /// and must not be recorded as a played session.
  static GameState abandonSession(GameState state) {
    if (state.isOver) return state;
    return state.copyWith(status: GameStatus.cancelled);
  }

  /// Ranking of the players, best score first.
  ///
  /// Players with equal scores share a rank and are flagged as tied; the order
  /// within a tie follows the seating order, so it is deterministic without
  /// implying a tie-break winner.
  static List<FinalRankingEntry> rankings(GameState state) =>
      rankingsOf(state.players);

  /// Same ranking rules, applied to the players of a stored session.
  static List<FinalRankingEntry> rankingsOf(Iterable<Player> players) {
    final entries = [
      for (var i = 0; i < players.length; i++) (player: players.elementAt(i), seat: i),
    ]..sort((a, b) {
        final byScore = b.player.score.compareTo(a.player.score);
        if (byScore != 0) return byScore;
        return a.seat.compareTo(b.seat);
      });

    final result = <FinalRankingEntry>[];
    var rank = 0;
    var previousScore = -1;
    var groupSize = 0;

    for (var i = 0; i < entries.length; i++) {
      final player = entries[i].player;
      if (player.score != previousScore) {
        rank = i + 1;
        previousScore = player.score;
        groupSize = 1;
      } else {
        groupSize++;
      }
      result.add(FinalRankingEntry(player: player, rank: rank, isTied: groupSize > 1));
    }

    // A group only counts as tied once every member is known.
    final counts = <int, int>{};
    for (final entry in result) {
      counts[entry.rank] = (counts[entry.rank] ?? 0) + 1;
    }
    return [
      for (final entry in result)
        FinalRankingEntry(
          player: entry.player,
          rank: entry.rank,
          isTied: (counts[entry.rank] ?? 1) > 1,
        ),
    ];
  }

  /// True when [orderedIds] is the complete correct sequence of the current
  /// ordering question, in the right order.
  static bool isSequenceCorrect(GameState state, List<String> orderedIds) {
    final question = state.currentQuestion;
    if (question is! PutInOrderQuestion) return false;
    if (orderedIds.length != question.correctOrderIds.length) return false;
    for (var i = 0; i < orderedIds.length; i++) {
      if (orderedIds[i] != question.correctOrderIds[i]) return false;
    }
    return true;
  }

  /// Formats a duration as mm:ss.
  static String formatDuration(int? totalSeconds) {
    if (totalSeconds == null) return '--:--';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  static SessionConfig _normalizeConfig(SessionConfig config) {
    final names = config.playerNames.map((n) => n.trim()).where((n) => n.isNotEmpty).toList();
    final modes = config.modes.isEmpty ? GameMode.values.toList() : config.modes;
    final categories = config.categories;
    final questionCount = config.questionCount < 1 ? 1 : config.questionCount;
    final durationMinutes = config.isTimed && config.sessionDurationMinutes! < 1
        ? 1
        : config.sessionDurationMinutes;

    return SessionConfig(
      playerNames: names,
      modes: modes,
      categories: categories,
      difficulty: config.difficulty,
      questionCount: questionCount,
      sessionDurationMinutes: durationMinutes,
      shuffleQuestions: config.shuffleQuestions,
    );
  }

  /// Selects up to [count] questions.
  ///
  /// Ordering rules, applied in this order:
  /// 1. questions never played in a previous session come first;
  /// 2. then questions already played, least recently used first;
  /// 3. the requested [difficulty] is preferred inside each of those groups,
  ///    falling back to the other difficulties when it runs out;
  /// 4. modes are interleaved so one mode is not repeated back to back.
  ///
  /// Within-session rules are never relaxed: a question is picked at most once
  /// and at most one question per `factGroupId`.
  static List<BaseQuestion> _pickQuestions({
    required List<BaseQuestion> pool,
    required int count,
    required Difficulty difficulty,
    required List<GameMode> modes,
    required bool shuffle,
    List<String> recentQuestionIds = const [],
    Random? random,
  }) {
    if (pool.isEmpty || count <= 0) return const [];

    final order = List<BaseQuestion>.from(pool);
    if (shuffle) {
      order.shuffle(random ?? Random());
    }

    // Position in the history of played questions: 0 is the most recent one.
    final recentRank = <String, int>{};
    for (var i = 0; i < recentQuestionIds.length; i++) {
      recentRank.putIfAbsent(recentQuestionIds[i], () => i);
    }

    final preferred = order.where((q) => q.difficulty == difficulty).toList();
    final others = order.where((q) => q.difficulty != difficulty).toList();

    // Never-used questions first, then the most distant ones in time.
    final fresh = [...preferred, ...others]
        .where((q) => !recentRank.containsKey(q.id))
        .toList();
    final stale = [...preferred, ...others]
        .where((q) => recentRank.containsKey(q.id))
        .toList()
      ..sort((a, b) =>
          (recentRank[b.id] ?? 0).compareTo(recentRank[a.id] ?? 0));

    final picked = <BaseQuestion>[];
    final usedFactGroups = <String>{};

    void takeFrom(List<BaseQuestion> candidates) {
      if (picked.length >= count) return;

      final buckets = <GameMode, List<BaseQuestion>>{};
      for (final question in candidates) {
        buckets.putIfAbsent(question.mode, () => []).add(question);
      }

      final modeOrder = modes.isEmpty ? buckets.keys.toList() : [
        ...modes.where((m) => buckets.containsKey(m)),
        ...buckets.keys.where((m) => !modes.contains(m)),
      ];

      for (final mode in modeOrder) {
        for (final question in buckets[mode]!) {
          if (picked.length >= count) return;
          if (usedFactGroups.contains(question.factGroupId)) continue;
          usedFactGroups.add(question.factGroupId);
          picked.add(question);
        }
      }
    }

    // Step 1: only questions that were never played in a previous session.
    takeFrom(fresh);
    // Step 2: relaxation, the question pool is too small for the fresh ones.
    takeFrom(stale);

    return picked;
  }

  static GameState _updateCurrentRound(GameState state, RoundState round) {
    final rounds = [...state.rounds];
    if (state.currentIndex < 0 || state.currentIndex >= rounds.length) return state;
    rounds[state.currentIndex] = round;
    return state.copyWith(rounds: rounds);
  }
}