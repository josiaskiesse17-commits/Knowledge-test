import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/data/sample_question_bank.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/services/game_engine.dart';
import 'package:knowledge_test/services/session_history_service.dart';

/// Plays the given session to the end: one point to the first player, except on
/// the questions listed in [skippedIndexes] which are skipped.
GameState _playThrough(
  GameState state, {
  Set<int> skippedIndexes = const {},
}) {
  var current = GameRules.start(state);
  var index = 0;
  while (!current.isCompleted) {
    current = skippedIndexes.contains(index)
        ? GameRules.skipQuestion(current).state
        : GameRules.awardPoint(current, 'p1').state;
    current = GameRules.nextQuestion(current).state;
    index++;
  }
  return current;
}

GameState _builtSession({int questionCount = 3}) {
  return GameRules.buildSession(
    config: SessionConfig(
      playerNames: const ['Alice', 'Bob'],
      modes: GameMode.values.toList(),
      questionCount: questionCount,
      difficulty: Difficulty.easy,
    ),
    availableQuestions: SampleQuestionBank.questions,
  );
}

GameState _completedSession({int questionCount = 3}) =>
    _playThrough(_builtSession(questionCount: questionCount),
        skippedIndexes: const {1});

GameSession _storedSession(
  String id,
  DateTime createdAt,
  List<String> questionIds,
) {
  return GameSession(
    id: id,
    createdAt: createdAt,
    players: const [
      Player(id: 'p1', name: 'Alice', score: 2),
      Player(id: 'p2', name: 'Bob', score: 1),
    ],
    settings: const GameSettings(),
    rounds: [
      for (var i = 0; i < questionIds.length; i++)
        RoundResult(
          roundNumber: i + 1,
          questionId: questionIds[i],
          questionText: '',
          answers: const [],
          correctAnswer: '',
          answeredAt: createdAt,
          outcome: QuestionOutcome.scored,
        ),
    ],
    status: GameStatus.completed,
    completedAt: createdAt,
  );
}

void main() {
  group('Session record mapping', () {
    test('stores the players, scores, settings and question outcomes', () {
      final state = _completedSession(questionCount: 3);

      final record = SessionHistoryService.recordOf(state);

      expect(record.status, GameStatus.completed);
      expect(record.players.map((p) => p.name).toList(), ['Alice', 'Bob']);
      expect(record.players.first.score, 2);
      expect(record.players.last.score, 0);
      expect(record.createdAt, state.startedAt);
      expect(record.completedAt, state.completedAt);
      expect(record.settings.questionCount, 3);
      expect(record.settings.difficulty, 'easy');

      expect(record.rounds.length, 3);
      expect(
        record.rounds.map((r) => r.questionId).toList(),
        state.questions.map((q) => q.id).toList(),
      );
      expect(record.rounds.map((r) => r.outcome).toList(), [
        QuestionOutcome.scored,
        QuestionOutcome.skipped,
        QuestionOutcome.scored,
      ]);
      // Alice scored the two non-skipped questions.
      expect(record.rounds[0].awardedPlayerIds, {'p1'});
      expect(record.rounds[1].awardedPlayerIds, isEmpty);
    });

    test('stores no duplicated question content', () {
      final record = SessionHistoryService.recordOf(_completedSession());

      for (final round in record.rounds) {
        expect(round.questionText, isEmpty);
        expect(round.correctAnswer, isEmpty);
        expect(round.answers, isEmpty);
      }
    });

    test('uses the completion time of the session when it has one', () {
      final state = _completedSession();
      final record = SessionHistoryService.recordOf(state);

      expect(record.completedAt, state.completedAt);
    });

    test('falls back to the given time when the state has none', () {
      final state = GameRules.buildSession(
        config: SessionConfig(
          playerNames: const ['Alice', 'Bob'],
          modes: GameMode.values.toList(),
          questionCount: 1,
        ),
        availableQuestions: SampleQuestionBank.questions,
      );
      final completedAt = DateTime.utc(2026, 5, 4, 10, 30);

      final record = SessionHistoryService.recordOf(state, now: completedAt);

      expect(record.completedAt, completedAt);
      expect(record.createdAt, completedAt);
    });
  });

  group('Session id', () {
    test('is stable for the same session and completion time', () {
      final state = _completedSession();
      final completedAt = DateTime.utc(2026, 5, 4);

      expect(
        SessionHistoryService.sessionIdOf(state, completedAt: completedAt),
        SessionHistoryService.sessionIdOf(state, completedAt: completedAt),
      );
    });

    test('differs between two different sessions', () {
      final first = _completedSession(questionCount: 2);
      final second = _completedSession(questionCount: 3);

      expect(
        SessionHistoryService.sessionIdOf(first, completedAt: first.completedAt!),
        isNot(SessionHistoryService.sessionIdOf(second, completedAt: second.completedAt!)),
      );
    });

    test('differs when the completion time differs', () {
      final state = _completedSession();

      expect(
        SessionHistoryService.sessionIdOf(
          state,
          completedAt: DateTime.utc(2026, 5, 4, 10),
        ),
        isNot(SessionHistoryService.sessionIdOf(
          state,
          completedAt: DateTime.utc(2026, 5, 4, 11),
        )),
      );
    });
  });

  group('Recently played questions', () {
    test('lists the newest session first, last question of a session first', () {
      final older = _storedSession('s1', DateTime.utc(2026, 5, 1), ['q1', 'q2']);
      final newer = _storedSession('s2', DateTime.utc(2026, 5, 2), ['q3', 'q4']);

      expect(
        SessionHistoryService.recentQuestionIdsOf([older, newer]),
        ['q4', 'q3', 'q2', 'q1'],
      );
    });

    test('ignores the order of the given sessions', () {
      final older = _storedSession('s1', DateTime.utc(2026, 5, 1), ['q1', 'q2']);
      final newer = _storedSession('s2', DateTime.utc(2026, 5, 2), ['q3', 'q4']);

      expect(
        SessionHistoryService.recentQuestionIdsOf([newer, older]),
        ['q4', 'q3', 'q2', 'q1'],
      );
    });

    test('keeps each question once, at its most recent position', () {
      final older = _storedSession('s1', DateTime.utc(2026, 5, 1), ['q1', 'q2']);
      final newer = _storedSession('s2', DateTime.utc(2026, 5, 2), ['q2', 'q3']);

      expect(
        SessionHistoryService.recentQuestionIdsOf([older, newer]),
        ['q3', 'q2', 'q1'],
      );
    });

    test('limits the number of inspected sessions', () {
      final older = _storedSession('s1', DateTime.utc(2026, 5, 1), ['q1']);
      final newer = _storedSession('s2', DateTime.utc(2026, 5, 2), ['q2']);

      expect(
        SessionHistoryService.recentQuestionIdsOf([older, newer], maxSessions: 1),
        ['q2'],
      );
    });

    test('limits the number of remembered ids', () {
      final session = _storedSession('s1', DateTime.utc(2026, 5, 1),
          ['q1', 'q2', 'q3', 'q4']);

      expect(
        SessionHistoryService.recentQuestionIdsOf([session], maxIds: 2),
        ['q4', 'q3'],
      );
    });

    test('returns nothing without stored sessions', () {
      expect(SessionHistoryService.recentQuestionIdsOf(const []), isEmpty);
    });
  });

  group('Date formatting', () {
    test('formats a stored date as dd/MM/yyyy HH:mm', () {
      expect(
        SessionHistoryService.formatSessionDate(DateTime.utc(2026, 5, 4, 9, 5)),
        '04/05/2026 09:05',
      );
    });
  });

  group('Round trip through storage serialization', () {
    test('a stored record decodes back to the same session', () {
      final record = SessionHistoryService.recordOf(_completedSession());

      final decoded =
          GameSession.fromJson(jsonDecode(jsonEncode(record.toJson())));

      expect(decoded, record);
    });
  });
}
