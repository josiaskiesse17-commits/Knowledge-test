import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/services/game_engine.dart';

import '../helpers/sample_question_bank.dart';

/// Builds a small deterministic question set used by the rule tests.
List<BaseQuestion> _testQuestions() {
  final bank = SampleQuestionBank.questions;

  final whichCameFirst = bank.whereType<WhichCameFirstQuestion>().firstWhere(
    (q) => q.correctFirstIndex == 1,
  );
  final country = bank.whereType<GuessTheCountryQuestion>().first;
  final factOrCap = bank.whereType<FactOrCapQuestion>().firstWhere(
    (q) => q.variation == QuestionVariation.factOrCapTrueFalse,
  );
  final ordering = bank.whereType<PutInOrderQuestion>().first;
  final howMuch = bank.whereType<HowMuchQuestion>().firstWhere(
    (q) => q.variation == QuestionVariation.howMuchQuantity,
  );

  return [whichCameFirst, country, factOrCap, ordering, howMuch];
}

SessionConfig _config({
  int questionCount = 5,
  bool shuffle = false,
  List<GameMode>? modes,
  List<QuestionCategory>? categories,
  Difficulty difficulty = Difficulty.easy,
  int? durationMinutes,
}) {
  return SessionConfig(
    playerNames: const ['Alice', 'Bob', 'Chloé'],
    questionCount: questionCount,
    difficulty: difficulty,
    modes: modes ?? GameMode.values.toList(),
    categories: categories ?? const [],
    sessionDurationMinutes: durationMinutes,
    shuffleQuestions: shuffle,
  );
}

GameState _startedSession({
  int questionCount = 5,
  bool shuffle = false,
  List<GameMode>? modes,
  List<QuestionCategory>? categories,
  Difficulty difficulty = Difficulty.easy,
  int? durationMinutes,
}) {
  final state = GameRules.buildSession(
    config: _config(
      questionCount: questionCount,
      shuffle: shuffle,
      modes: modes,
      categories: categories,
      difficulty: difficulty,
      durationMinutes: durationMinutes,
    ),
    availableQuestions: _testQuestions(),
  );
  return GameRules.start(state);
}

void main() {
  group('Session build and validation', () {
    test('builds a session with all selected questions', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 5),
        availableQuestions: _testQuestions(),
      );

      expect(state.questions.length, 5);
      expect(state.rounds.length, 5);
      expect(state.players.map((p) => p.name).toList(), [
        'Alice',
        'Bob',
        'Chloé',
      ]);
      expect(state.players.every((p) => p.score == 0), isTrue);
      expect(state.status, GameStatus.pending);
      expect(state.isTimedSession, isFalse);
    });

    test('scores start at zero and every round is pending', () {
      final state = _startedSession();
      expect(state.currentRound!.outcome, QuestionOutcome.pending);
      expect(state.currentRound!.awardedPlayerIds, isEmpty);
      expect(state.resolvedQuestionCount, 0);
    });

    test('rejects a session with a single player', () {
      final config = SessionConfig(
        playerNames: const ['Solo'],
        modes: GameMode.values.toList(),
      );
      expect(config.isValid, isFalse);
      expect(config.validate(), isNotEmpty);
    });

    test('rejects a session with duplicate names', () {
      final config = SessionConfig(
        playerNames: const ['Alice', 'Alice'],
        modes: GameMode.values.toList(),
      );
      expect(config.validate(), isNotEmpty);
    });

    test('rejects a session without any game mode', () {
      final config = const SessionConfig(playerNames: ['Alice', 'Bob']);
      expect(config.isValid, isFalse);
      expect(config.validate(), isNotEmpty);
    });

    test('rejects a timed session with no duration', () {
      final config = SessionConfig(
        playerNames: const ['Alice', 'Bob'],
        modes: GameMode.values.toList(),
        sessionDurationMinutes: 0,
      );
      expect(config.validate(), isNotEmpty);
    });

    test('a timed session starts with the full duration in seconds', () {
      final state = _startedSession(questionCount: 2, durationMinutes: 1);
      expect(state.isTimedSession, isTrue);
      expect(state.remainingSeconds, 60);
    });

    test('selects questions only from the chosen modes', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 2, modes: const [GameMode.howMuch]),
        availableQuestions: SampleQuestionBank.questions,
      );

      expect(state.questions.length, 2);
      expect(state.questions.every((q) => q.mode == GameMode.howMuch), isTrue);
    });

    test('never selects two questions from the same fact group', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 12, shuffle: false),
        availableQuestions: SampleQuestionBank.questions,
      );

      final groups = state.questions.map((q) => q.factGroupId).toList();
      expect(groups.toSet().length, groups.length);
    });

    test('mixes modes instead of playing one mode five times in a row', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 5, shuffle: false),
        availableQuestions: _testQuestions(),
      );

      expect(state.questions.map((q) => q.mode).toSet().length, greaterThan(1));
    });

    test('shuffle is deterministic with a fixed seed', () {
      final first = GameRules.buildSession(
        config: _config(questionCount: 5, shuffle: true),
        availableQuestions: _testQuestions(),
        random: _SeededRandom(7),
      );
      final second = GameRules.buildSession(
        config: _config(questionCount: 5, shuffle: true),
        availableQuestions: _testQuestions(),
        random: _SeededRandom(7),
      );
      expect(
        first.questions.map((q) => q.id).toList(),
        second.questions.map((q) => q.id).toList(),
      );
    });

    test(
      'selection keeps the selected categories even when the pool is small',
      () {
        final testQuestions = _testQuestions();
        final eligible = testQuestions
            .where((q) => q.category == QuestionCategory.geography)
            .length;
        expect(eligible, greaterThan(0));
        expect(eligible, lessThan(testQuestions.length));

        final state = GameRules.buildSession(
          config: _config(
            questionCount: testQuestions.length,
            categories: const [QuestionCategory.geography],
          ),
          availableQuestions: testQuestions,
        );

        // The session is shorter than requested rather than wider than the
        // selected category.
        expect(state.questions.length, eligible);
        expect(
          state.questions.every(
            (q) => q.category == QuestionCategory.geography,
          ),
          isTrue,
        );
      },
    );

    test('selection widens to the whole mode when no category is eligible', () {
      final state = GameRules.buildSession(
        config: _config(
          questionCount: 4,
          categories: const [QuestionCategory.sports],
          modes: const [GameMode.putInOrder],
        ),
        availableQuestions: _testQuestions(),
      );

      // Put-in-order has no sports question, so the whole mode stays playable
      // rather than producing an empty session.
      expect(state.questions, isNotEmpty);
    });

    test('updateConfig renames players without keeping stale scores', () {
      final state = _startedSession();
      final scored = GameRules.awardPoint(state, 'p1').state;

      final updated = GameRules.updateConfig(
        scored,
        _config().copyWith(playerNames: const ['Alice', 'Bob', 'Chloé']),
      );

      expect(updated.players.map((p) => p.name).toList(), [
        'Alice',
        'Bob',
        'Chloé',
      ]);
      expect(updated.players.every((p) => p.score == 0), isTrue);
      expect(
        updated.rounds.every((r) => r.outcome == QuestionOutcome.pending),
        isTrue,
      );
    });
  });

  group('Scoring', () {
    test('a correct answer gives one point', () {
      final outcome = GameRules.awardPoint(_startedSession(), 'p1');

      expect(outcome.result, AwardResult.awarded);
      expect(outcome.state.players.first.score, 1);
      expect(outcome.state.currentRound!.isScored, isTrue);
    });

    test('two players may both receive a point for the same question', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.awardPoint(state, 'p2').state;

      expect(state.players[0].score, 1);
      expect(state.players[1].score, 1);
      expect(state.currentRound!.awardedPlayerIds, {'p1', 'p2'});
    });

    test('a player cannot receive a second point for the same question', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;

      final outcome = GameRules.awardPoint(state, 'p1');

      expect(outcome.result, AwardResult.alreadyAwarded);
      expect(outcome.state.players[0].score, 1);
    });

    test('an unknown player is refused', () {
      final outcome = GameRules.awardPoint(_startedSession(), 'inconnu');

      expect(outcome.result, AwardResult.unknownPlayer);
      expect(outcome.state.totalScore, 0);
    });

    test('a skipped question awards no points', () {
      final outcome = GameRules.skipQuestion(_startedSession());

      expect(outcome.state.currentRound!.outcome, QuestionOutcome.skipped);
      expect(outcome.state.totalScore, 0);
    });

    test('skip is refused once the question has been scored', () {
      final awarded = GameRules.awardPoint(_startedSession(), 'p1').state;
      final outcome = GameRules.skipQuestion(awarded);

      expect(outcome.ok, isFalse);
      expect(outcome.state.currentRound!.isScored, isTrue);
    });

    test('an invalidated question gives no points and takes back awards', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.awardPoint(state, 'p2').state;
      expect(state.totalScore, 2);

      state = GameRules.invalidateQuestion(state).state;

      expect(state.currentRound!.isInvalidated, isTrue);
      expect(state.currentRound!.awardedPlayerIds, isEmpty);
      expect(state.totalScore, 0);
    });

    test('a point cannot be awarded on an invalidated question', () {
      var state = _startedSession();
      state = GameRules.invalidateQuestion(state).state;
      final outcome = GameRules.awardPoint(state, 'p1');

      expect(outcome.result, AwardResult.invalidatedQuestion);
      expect(outcome.state.totalScore, 0);
    });

    test('undo removes the point before the quizmaster moves on', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.undoAward(state, 'p1').state;

      expect(state.players[0].score, 0);
      expect(state.currentRound!.outcome, QuestionOutcome.pending);
      expect(state.currentRound!.awardedPlayerIds, isEmpty);
    });

    test('undo only affects the requested player', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.undoAward(state, 'p1').state;

      expect(state.players[0].score, 0);
      expect(state.players[1].score, 1);
      expect(state.currentRound!.isScored, isTrue);
    });

    test('undo is refused when the player has no point', () {
      final outcome = GameRules.undoAward(_startedSession(), 'p1');

      expect(outcome.removed, isFalse);
      expect(outcome.state.totalScore, 0);
    });

    test('awards are refused once the session is completed', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.nextQuestion(state).state;
      state = GameRules.endSession(state);

      final outcome = GameRules.awardPoint(state, 'p1');
      expect(outcome.result, AwardResult.sessionNotActive);
    });
  });

  group('Ordering questions: exact sequence only', () {
    GameState orderingSession() {
      final state = GameRules.buildSession(
        config: _config(questionCount: 5, modes: const [GameMode.putInOrder]),
        availableQuestions: _testQuestions(),
      );
      return GameRules.start(state);
    }

    test('the exact sequence is accepted', () {
      final state = orderingSession();
      final question = state.currentQuestion as PutInOrderQuestion;

      expect(
        GameRules.isSequenceCorrect(state, question.correctOrderIds),
        isTrue,
      );

      final outcome = GameRules.awardPoint(
        state,
        'p1',
        announcedOrder: question.correctOrderIds,
      );
      expect(outcome.result, AwardResult.awarded);
      expect(outcome.state.players[0].score, 1);
    });

    test('a reversed order gives no point', () {
      final state = orderingSession();
      final question = state.currentQuestion as PutInOrderQuestion;

      final swapped = question.correctOrderIds.reversed.toList();
      expect(GameRules.isSequenceCorrect(state, swapped), isFalse);

      final outcome = GameRules.awardPoint(
        state,
        'p1',
        announcedOrder: swapped,
      );
      expect(outcome.result, AwardResult.wrongOrder);
      expect(outcome.state.totalScore, 0);
    });

    test('an incomplete sequence gives no point', () {
      final state = orderingSession();
      final question = state.currentQuestion as PutInOrderQuestion;
      final partial = question.correctOrderIds.sublist(0, 2);

      final outcome = GameRules.awardPoint(
        state,
        'p1',
        announcedOrder: partial,
      );
      expect(outcome.result, AwardResult.wrongOrder);
      expect(outcome.state.totalScore, 0);
    });

    test('no announced order gives no point', () {
      final outcome = GameRules.awardPoint(orderingSession(), 'p1');

      expect(outcome.result, AwardResult.wrongOrder);
      expect(outcome.state.totalScore, 0);
    });

    test('a wrong order can be undone and corrected', () {
      var state = orderingSession();
      const playerId = 'p1';
      final question = state.currentQuestion as PutInOrderQuestion;

      final wrong = question.correctOrderIds.reversed.toList();
      expect(
        GameRules.awardPoint(state, playerId, announcedOrder: wrong).result,
        AwardResult.wrongOrder,
      );

      state = GameRules.awardPoint(
        state,
        playerId,
        announcedOrder: question.correctOrderIds,
      ).state;
      state = GameRules.undoAward(state, playerId).state;

      expect(state.totalScore, 0);
      expect(state.currentRound!.outcome, QuestionOutcome.pending);
    });

    test('a non-ordering question needs no announced order', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 1, modes: const [GameMode.howMuch]),
        availableQuestions: _testQuestions(),
      );
      final active = GameRules.start(state);

      expect(GameRules.awardPoint(active, 'p1').result, AwardResult.awarded);
    });
  });

  group('Question progression', () {
    test('next requires the current question to be resolved', () {
      final outcome = GameRules.nextQuestion(_startedSession());

      expect(outcome.result, NextResult.roundIncomplete);
      expect(outcome.state.currentIndex, 0);
    });

    test('next advances to the following question', () {
      var state = _startedSession();
      state = GameRules.skipQuestion(state).state;
      state = GameRules.nextQuestion(state).state;

      expect(state.currentIndex, 1);
      expect(state.questions[0].id, state.rounds[0].questionId);
      expect(state.currentRound!.outcome, QuestionOutcome.pending);
    });

    test('reveal state of the previous question is preserved', () {
      var state = _startedSession();
      state = GameRules.revealAnswer(state);
      state = GameRules.revealExplanation(state);
      state = GameRules.skipQuestion(state).state;
      state = GameRules.nextQuestion(state).state;

      expect(state.rounds[0].answerRevealed, isTrue);
      expect(state.rounds[0].explanationRevealed, isTrue);
      expect(state.rounds[1].answerRevealed, isFalse);
    });

    test('awards carry over between questions', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.nextQuestion(state).state;

      expect(state.players[0].score, 1);
      expect(state.currentRound!.awardedPlayerIds, isEmpty);
    });

    test('a question-count session ends on the last question', () {
      var state = _startedSession(questionCount: 2);
      state = GameRules.skipQuestion(state).state;
      expect(GameRules.nextQuestion(state).result, NextResult.advanced);

      state = GameRules.nextQuestion(state).state;
      expect(state.currentIndex, 1);

      state = GameRules.skipQuestion(state).state;
      final outcome = GameRules.nextQuestion(state);

      expect(outcome.result, NextResult.sessionCompleted);
      expect(outcome.state.isCompleted, isTrue);
    });

    test('the session stops after the configured number of questions', () {
      var state = _startedSession(questionCount: 3);
      for (var i = 0; i < 3; i++) {
        state = GameRules.skipQuestion(state).state;
        state = GameRules.nextQuestion(state).state;
      }

      expect(state.isCompleted, isTrue);
      expect(state.resolvedQuestionCount, 3);
    });

    test('ending the session completes it and keeps the scores', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.endSession(state);

      expect(state.isCompleted, isTrue);
      expect(state.players[0].score, 1);
    });
  });

  group('Reveal controls', () {
    test('the answer is revealed on request', () {
      var state = _startedSession();
      expect(state.currentRound!.answerRevealed, isFalse);

      state = GameRules.revealAnswer(state);
      expect(state.currentRound!.answerRevealed, isTrue);
    });

    test('the explanation is revealed on request', () {
      var state = _startedSession();
      state = GameRules.revealAnswer(state);
      expect(state.currentRound!.explanationRevealed, isFalse);

      state = GameRules.revealExplanation(state);
      expect(state.currentRound!.explanationRevealed, isTrue);
    });

    test('country clues are revealed one at a time', () {
      var state = GameRules.buildSession(
        config: _config(
          questionCount: 1,
          modes: const [GameMode.guessTheCountry],
        ),
        availableQuestions: _testQuestions(),
      );
      state = GameRules.start(state);

      expect(state.currentQuestion, isA<GuessTheCountryQuestion>());
      expect(state.currentRound!.revealedClues, 0);

      state = GameRules.revealNextClue(state);
      expect(state.currentRound!.revealedClues, 1);

      state = GameRules.revealNextClue(state);
      expect(state.currentRound!.revealedClues, 2);
    });

    test('clue reveal stops at the number of available clues', () {
      var state = GameRules.buildSession(
        config: _config(
          questionCount: 1,
          modes: const [GameMode.guessTheCountry],
        ),
        availableQuestions: _testQuestions(),
      );
      state = GameRules.start(state);

      final question = state.currentQuestion as GuessTheCountryQuestion;
      for (var i = 0; i < question.clues.length + 5; i++) {
        state = GameRules.revealNextClue(state);
      }

      expect(state.currentRound!.revealedClues, question.clues.length);
    });

    test('non-country questions expose no clue', () {
      var state = GameRules.buildSession(
        config: _config(questionCount: 1, modes: const [GameMode.howMuch]),
        availableQuestions: _testQuestions(),
      );
      state = GameRules.start(state);
      state = GameRules.revealNextClue(state);

      expect(state.currentRound!.revealedClues, 0);
    });

    test('reveals are blocked once the session is completed', () {
      var state = _startedSession();
      state = GameRules.endSession(state);
      state = GameRules.revealAnswer(state);

      expect(state.currentRound!.answerRevealed, isFalse);
    });
  });

  group('Timer', () {
    test('a timed session counts down every tick', () {
      var state = _startedSession(questionCount: 1, durationMinutes: 1);
      expect(state.remainingSeconds, 60);

      state = GameRules.tick(state);
      expect(state.remainingSeconds, 59);
    });

    test('the countdown never interrupts the running question', () {
      var state = _startedSession(questionCount: 3, durationMinutes: 1);

      for (var i = 0; i < 60; i++) {
        state = GameRules.tick(state);
      }

      expect(state.remainingSeconds, 0);
      expect(state.timeExpired, isTrue);
      expect(state.isActive, isTrue);
      expect(state.currentIndex, 0);
      expect(state.currentRound!.outcome, QuestionOutcome.pending);
    });

    test('pause stops the countdown', () {
      var state = _startedSession(questionCount: 1, durationMinutes: 1);
      state = GameRules.tick(state);
      state = GameRules.pause(state);
      final paused = state.remainingSeconds;

      state = GameRules.tick(state);
      state = GameRules.tick(state);

      expect(state.isPaused, isTrue);
      expect(state.remainingSeconds, paused);
    });

    test('resume restarts the countdown', () {
      var state = _startedSession(questionCount: 1, durationMinutes: 1);

      final paused = GameRules.pause(state).remainingSeconds;
      expect(paused, 60);

      state = GameRules.resume(state);
      state = GameRules.tick(state);

      expect(state.isActive, isTrue);
      expect(state.remainingSeconds, 59);
    });

    test('a question-count session has no countdown', () {
      final state = _startedSession(questionCount: 3);
      expect(state.isTimedSession, isFalse);
      expect(state.remainingSeconds, isNull);
    });

    test('an expired session ends after the current question is resolved', () {
      var state = _startedSession(questionCount: 3, durationMinutes: 1);
      for (var i = 0; i < 60; i++) {
        state = GameRules.tick(state);
      }
      expect(state.timeExpired, isTrue);

      // The current question must be resolved before the session can end.
      expect(GameRules.nextQuestion(state).result, NextResult.roundIncomplete);

      state = GameRules.skipQuestion(state).state;
      final outcome = GameRules.nextQuestion(state);

      expect(outcome.result, NextResult.sessionCompleted);
      expect(outcome.state.isCompleted, isTrue);
    });

    test('the clock is formatted as mm:ss', () {
      expect(GameRules.formatDuration(null), '--:--');
      expect(GameRules.formatDuration(0), '00:00');
      expect(GameRules.formatDuration(65), '01:05');
      expect(GameRules.formatDuration(600), '10:00');
    });

    test('tick does nothing before the session starts', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 1, durationMinutes: 2),
        availableQuestions: _testQuestions(),
      );

      final ticked = GameRules.tick(state);
      expect(ticked.remainingSeconds, 120);
      expect(ticked.isActive, isFalse);
    });
  });

  group('Final ranking', () {
    test('players are ranked by score, ties resolved by seating order', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.skipQuestion(state).state;
      state = GameRules.nextQuestion(state).state;
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.awardPoint(state, 'p3').state;
      state = GameRules.skipQuestion(state).state;
      state = GameRules.nextQuestion(state).state;
      state = GameRules.awardPoint(state, 'p1').state;

      // Bob 2 points, Alice and Chloé 1 point each; Alice sits before Chloé.
      final rankings = GameRules.rankings(state);

      expect(rankings.map((e) => e.player.name).toList(), [
        'Bob',
        'Alice',
        'Chloé',
      ]);
      expect(rankings.first.player.score, 2);
      expect(rankings.first.rank, 1);
      expect(rankings[1].player.score, 1);
      expect(rankings[2].player.score, 1);
    });

    test('tied players share a rank and are flagged as tied', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.skipQuestion(state).state;

      final rankings = GameRules.rankings(state);
      final tied = rankings.where((e) => e.isTied).toList();

      expect(tied.length, 2);
      expect(tied.every((e) => e.rank == 1), isTrue);
      expect(rankings.where((e) => e.player.id == 'p3').first.rank, 3);
    });

    test('the order inside a tie follows the seating order', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.skipQuestion(state).state;

      final rankings = GameRules.rankings(state);
      expect(rankings.map((e) => e.player.id).toList(), ['p1', 'p2', 'p3']);
      expect(rankings[0].isTied, isTrue);
      expect(rankings[0].rank, rankings[1].rank);
    });

    test('ranks are not reused after a tie', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.skipQuestion(state).state;
      state = GameRules.nextQuestion(state).state;
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.awardPoint(state, 'p2').state;
      state = GameRules.awardPoint(state, 'p3').state;

      final rankings = GameRules.rankings(state);

      expect(rankings[0].rank, 1);
      expect(rankings[1].rank, 1);
      expect(rankings[2].rank, 3);
      expect(rankings[2].isTied, isFalse);
    });

    test('equal scores are flagged as tied for every member', () {
      var state = _startedSession();
      state = GameRules.awardPoint(state, 'p1').state;
      state = GameRules.skipQuestion(state).state;

      final rankings = GameRules.rankings(state);
      final zeros = rankings.where((e) => e.player.score == 0).toList();

      expect(zeros.length, 2);
      expect(zeros.every((e) => e.isTied), isTrue);
    });
  });

  group('State immutability', () {
    test('rules never mutate the state they were given', () {
      final state = _startedSession();
      final snapshot = state.currentRound!;

      GameRules.revealAnswer(state);
      GameRules.revealNextClue(state);
      GameRules.awardPoint(state, 'p1');
      GameRules.skipQuestion(state);
      GameRules.tick(state);

      expect(state.currentRound, snapshot);
      expect(state.players.every((p) => p.score == 0), isTrue);
    });
  });

  group('Session config mapping', () {
    test('config maps onto the existing GameSettings model', () {
      final config =
          _config(
            questionCount: 7,
            durationMinutes: 20,
            shuffle: true,
          ).copyWith(
            categories: const [
              QuestionCategory.geography,
              QuestionCategory.science,
            ],
          );

      final settings = config.toGameSettings();

      expect(settings, isA<GameSettings>());
      expect(settings.questionCount, 7);
      expect(settings.timePerQuestion, 20);
      expect(settings.difficulty, 'easy');
      expect(settings.category.contains('geography'), isTrue);
      expect(settings.randomizeQuestions, isTrue);
    });

    test('config copyWith clears the duration for question-count sessions', () {
      final timed = _config(durationMinutes: 15);
      final byCount = timed.copyWith(clearSessionDuration: true);

      expect(byCount.isTimed, isFalse);
      expect(timed.isTimed, isTrue);
    });

    test('status values cover the four session states', () {
      expect(GameStatus.pending.name, 'pending');
      expect(GameStatus.inProgress.name, 'inProgress');
      expect(GameStatus.paused.name, 'paused');
      expect(GameStatus.completed.name, 'completed');
    });
  });

  group('Question repetition rules', () {
    final bank = SampleQuestionBank.questions;

    test('never selects the same question twice in one session', () {
      final state = GameRules.buildSession(
        config: _config(questionCount: 12, shuffle: false),
        availableQuestions: bank,
      );
      final ids = state.questions.map((q) => q.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('questions already played are avoided while fresh ones remain', () {
      final first = GameRules.buildSession(
        config: _config(
          questionCount: 6,
          shuffle: false,
          difficulty: Difficulty.easy,
        ),
        availableQuestions: bank,
      );
      final played = first.questions.map((q) => q.id).toList();

      final second = GameRules.buildSession(
        config: _config(
          questionCount: 6,
          shuffle: false,
          difficulty: Difficulty.easy,
        ),
        availableQuestions: bank,
        recentQuestionIds: played,
      );

      final overlap = second.questions
          .map((q) => q.id)
          .where(played.contains)
          .toList();
      expect(overlap, isEmpty);
    });

    test(
      'fresh preferred-difficulty questions are picked before stale ones',
      () {
        // Build a session of 5 easy questions (there are 11 easy total).
        final first = GameRules.buildSession(
          config: _config(
            questionCount: 5,
            shuffle: false,
            difficulty: Difficulty.easy,
          ),
          availableQuestions: bank,
        );
        final played = first.questions.map((q) => q.id).toList();

        // Now request 5 more easy questions. At least 6 fresh easy remain.
        // The engine should pick from fresh preferred first.
        final second = GameRules.buildSession(
          config: _config(
            questionCount: 5,
            shuffle: false,
            difficulty: Difficulty.easy,
          ),
          availableQuestions: bank,
          recentQuestionIds: played,
        );

        // At least one fresh easy should be picked (fresh preferred > stale).
        final freshEasyPicked = second.questions
            .where(
              (q) => q.difficulty == Difficulty.easy && !played.contains(q.id),
            )
            .length;
        expect(freshEasyPicked, greaterThan(0));
      },
    );

    test('relaxes the cross-session rule when the pool is too small', () {
      final wcfIds = bank
          .where((q) => q.mode == GameMode.whichCameFirst)
          .map((q) => q.id)
          .toList();

      // Every WhichCameFirst question of the bank has already been played, so
      // the pool is exhausted and the cross-session rule has to be relaxed.
      final history = wcfIds;
      const requested = 4;

      final state = GameRules.buildSession(
        config: _config(
          questionCount: requested,
          shuffle: false,
          modes: const [GameMode.whichCameFirst],
        ),
        availableQuestions: bank,
        recentQuestionIds: history,
      );

      // The requested number of questions is filled with the least recently
      // used ones, so the oldest id of the history is played again first.
      expect(state.questions.length, requested);
      expect(
        state.questions.map((q) => q.id).toList(),
        wcfIds.sublist(wcfIds.length - requested).reversed.toList(),
      );
    });

    test(
      'never relaxes within-session uniqueness even when pool is exhausted',
      () {
        final wcfIds = bank
            .where((q) => q.mode == GameMode.whichCameFirst)
            .map((q) => q.id)
            .toList();

        final state = GameRules.buildSession(
          config: _config(
            questionCount: 6,
            shuffle: false,
            modes: const [GameMode.whichCameFirst],
          ),
          availableQuestions: bank,
          recentQuestionIds: wcfIds,
        );

        expect(state.questions.length, 6);
        final groups = state.questions.map((q) => q.factGroupId).toList();
        expect(groups.toSet().length, groups.length);
      },
    );
  });

  group('Category selection', () {
    final bank = SampleQuestionBank.questions;

    SessionConfig config({
      int questionCount = 5,
      List<QuestionCategory>? categories,
    }) {
      return _config(questionCount: questionCount, categories: categories);
    }

    test('no category selected means every category is eligible', () {
      final state = GameRules.buildSession(
        config: config(categories: const []),
        availableQuestions: bank,
      );

      expect(state.questions.length, 5);
    });

    test('a selected category excludes the other categories', () {
      final state = GameRules.buildSession(
        config: config(categories: const [QuestionCategory.history]),
        availableQuestions: bank,
      );

      expect(state.questions, isNotEmpty);
      expect(
        state.questions.every((q) => q.category == QuestionCategory.history),
        isTrue,
      );
    });

    test('several selected categories are combined', () {
      final state = GameRules.buildSession(
        config: config(
          categories: const [
            QuestionCategory.geography,
            QuestionCategory.nature,
          ],
        ),
        availableQuestions: bank,
      );

      expect(state.questions, isNotEmpty);
      expect(
        state.questions.every(
          (q) => const {
            QuestionCategory.geography,
            QuestionCategory.nature,
          }.contains(q.category),
        ),
        isTrue,
      );
    });

    test('the category is respected in every game mode', () {
      for (final mode in GameMode.values) {
        final state = GameRules.buildSession(
          config: config(
            questionCount: 5,
            categories: const [QuestionCategory.africa],
          ).copyWith(modes: [mode]),
          availableQuestions: bank,
        );

        // Every mode has at least one African question in the bank.
        expect(
          state.questions,
          isNotEmpty,
          reason: 'the ${mode.name} mode has no African question',
        );
        expect(
          state.questions.every((q) => q.category == QuestionCategory.africa),
          isTrue,
          reason: 'a question of another category leaked into ${mode.name}',
        );
      }
    });

    test(
      'a short session is played when the categories hold fewer questions',
      () {
        // Nature holds far fewer questions than the default request of 10.
        final natureCount = bank
            .where((q) => q.category == QuestionCategory.nature)
            .length;
        expect(natureCount, greaterThan(0));

        final state = GameRules.buildSession(
          config: config(
            questionCount: 10,
            categories: const [QuestionCategory.nature],
          ),
          availableQuestions: bank,
        );

        // The session starts, but never exceeds the eligible pool and never
        // widens to another category.
        expect(state.questions.length, natureCount);
        expect(
          state.questions.every((q) => q.category == QuestionCategory.nature),
          isTrue,
        );
      },
    );

    test('a category with no eligible question widens instead of failing', () {
      final state = GameRules.buildSession(
        config:
            config(
              questionCount: 3,
              categories: const [QuestionCategory.africa],
            ).copyWith(
              modes: const [GameMode.putInOrder],
              difficulty: Difficulty.hard,
            ),
        availableQuestions: bank
            .where(
              (q) =>
                  !(q.mode == GameMode.putInOrder &&
                      q.category == QuestionCategory.africa),
            )
            .toList(),
      );

      // The African put-in-order question was removed: the session still starts
      // with the questions of the selected mode.
      expect(state.questions, isNotEmpty);
    });
  });
}

/// Small reproducible random source so shuffle tests stay deterministic.
class _SeededRandom implements Random {
  _SeededRandom(this._seed);

  int _seed;
  final _mask = 0x7fffffff;

  @override
  int nextInt(int max) {
    _seed = (_seed * 48271) % _mask;
    return _seed % max;
  }

  @override
  bool nextBool() => nextInt(2) == 0;

  @override
  double nextDouble() => nextInt(1 << 30) / (1 << 30);
}
