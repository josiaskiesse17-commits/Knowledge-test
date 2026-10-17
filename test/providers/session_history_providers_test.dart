import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';
import 'package:knowledge_test/services/session_history_service.dart';

import '../helpers/fake_session_store.dart';
import '../helpers/sample_question_bank.dart';

/// Fixed timestamp used by the hand-written stored sessions.
final DateTime _epoch = DateTime.utc(2026, 5, 1);

/// Plays a full session of [questionCount] questions: the first player scores
/// every question, except the second one which is skipped.
GameState _completedSession({int questionCount = 3}) {
  var state = GameRules.buildSession(
    config: SessionConfig(
      playerNames: const ['Alice', 'Bob'],
      modes: GameMode.values.toList(),
      questionCount: questionCount,
    ),
    availableQuestions: SampleQuestionBank.questions,
  );
  state = GameRules.start(state);
  var index = 0;
  while (!state.isCompleted) {
    state = index == 1
        ? GameRules.skipQuestion(state).state
        : GameRules.awardPoint(state, 'p1').state;
    state = GameRules.nextQuestion(state).state;
    index++;
  }
  return state;
}

void main() {
  final completed = _completedSession();

  group('Loading the history', () {
    test('stored sessions are exposed, newest first', () async {
      final store = FakeSessionStore()
        ..stored.addAll([
          GameSession(
            id: 'older',
            createdAt: DateTime.utc(2026, 5, 1),
            players: const [Player(id: 'p1', name: 'Alice', score: 1)],
            settings: const GameSettings(),
          ),
          GameSession(
            id: 'newer',
            createdAt: DateTime.utc(2026, 5, 2),
            players: const [Player(id: 'p1', name: 'Alice', score: 2)],
            settings: const GameSettings(),
          ),
        ]);
      final notifier = SessionHistoryNotifier(() async => store);

      await notifier.load();

      expect(notifier.state.sessions.map((s) => s.id).toList(), [
        'newer',
        'older',
      ]);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.loadFailed, isFalse);
    });

    test('a failing store reports the failure without throwing', () async {
      final store = FakeSessionStore()..failLoad = true;
      final notifier = SessionHistoryNotifier(() async => store);

      await notifier.load();

      expect(notifier.state.isEmpty, isTrue);
      expect(notifier.state.loadFailed, isTrue);
    });

    test('no store at all keeps the app usable', () async {
      final notifier = SessionHistoryNotifier(() async => null);

      await notifier.load();

      expect(notifier.state.isEmpty, isTrue);
      expect(notifier.state.loadFailed, isTrue);
    });

    test('recent question ids come from the stored sessions', () async {
      final store = FakeSessionStore()
        ..stored.addAll([
          GameSession(
            id: 'older',
            createdAt: DateTime.utc(2026, 5, 1),
            players: const [Player(id: 'p1', name: 'Alice')],
            settings: const GameSettings(),
            rounds: [
              RoundResult(
                roundNumber: 1,
                questionId: 'wcf-001',
                questionText: '',
                answers: [],
                correctAnswer: '',
                answeredAt: _epoch,
              ),
            ],
          ),
          GameSession(
            id: 'newer',
            createdAt: DateTime.utc(2026, 5, 2),
            players: const [Player(id: 'p1', name: 'Alice')],
            settings: const GameSettings(),
            rounds: [
              RoundResult(
                roundNumber: 1,
                questionId: 'wcf-002',
                questionText: '',
                answers: const [],
                correctAnswer: '',
                answeredAt: DateTime.utc(2026, 5, 2),
              ),
            ],
          ),
        ]);
      final notifier = SessionHistoryNotifier(() async => store);

      await notifier.load();

      expect(notifier.recentQuestionIds, ['wcf-002', 'wcf-001']);
    });
  });

  group('Saving a completed session', () {
    test('the completed session is stored once', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);

      await notifier.persistCompleted(completed);

      expect(store.stored.length, 1);
      final record = store.stored.single;
      expect(record.status, GameStatus.completed);
      expect(record.players.map((p) => p.score).toList(), [2, 0]);
      expect(record.rounds.map((r) => r.outcome).toList(), [
        QuestionOutcome.scored,
        QuestionOutcome.skipped,
        QuestionOutcome.scored,
      ]);
      expect(
        record.id,
        SessionHistoryService.sessionIdOf(
          completed,
          completedAt: completed.completedAt!,
        ),
      );
    });

    test(
      'repeated completion of the same session does not write twice',
      () async {
        final store = FakeSessionStore();
        final notifier = SessionHistoryNotifier(() async => store);

        await notifier.persistCompleted(completed);
        await notifier.persistCompleted(completed);

        expect(store.stored.length, 1);
        expect(store.saveCalls, 1);
      },
    );

    test(
      'completion and navigation close together write the session once',
      () async {
        final store = FakeSessionStore();
        final notifier = SessionHistoryNotifier(() async => store);

        // Both calls happen before the first one had a chance to write.
        final first = notifier.persistCompleted(completed);
        final second = notifier.persistCompleted(completed);
        await Future.wait([first, second]);

        expect(store.stored.length, 1);
      },
    );

    test('the saved session appears in the loaded history', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);

      await notifier.persistCompleted(completed);

      expect(notifier.state.sessions.length, 1);
    });

    test('a running session is never recorded', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);
      final running = GameRules.start(
        GameRules.buildSession(
          config: SessionConfig(
            playerNames: const ['Alice', 'Bob'],
            modes: GameMode.values.toList(),
            questionCount: 2,
          ),
          availableQuestions: SampleQuestionBank.questions,
        ),
      );

      await notifier.persistCompleted(running);

      expect(store.stored, isEmpty);
    });

    test('an abandoned session is never recorded', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);
      final abandoned = GameRules.abandonSession(
        GameRules.start(
          GameRules.buildSession(
            config: SessionConfig(
              playerNames: const ['Alice', 'Bob'],
              modes: GameMode.values.toList(),
              questionCount: 2,
            ),
            availableQuestions: SampleQuestionBank.questions,
          ),
        ),
      );

      await notifier.persistCompleted(abandoned);

      expect(store.stored, isEmpty);
      expect(store.saveCalls, 0);
    });

    test(
      'a failed write is retryable and never interrupts the caller',
      () async {
        final store = FakeSessionStore();
        final notifier = SessionHistoryNotifier(() async => store);
        store.failSave = true;

        await notifier.persistCompleted(completed);
        expect(store.stored, isEmpty);

        store.failSave = false;
        await notifier.persistCompleted(completed);

        expect(store.stored.length, 1);
      },
    );

    test('without a store nothing is written and nothing throws', () async {
      final notifier = SessionHistoryNotifier(() async => null);

      await notifier.persistCompleted(completed);

      expect(notifier.state.isEmpty, isTrue);
    });

    test('two different sessions are both stored', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);
      final other = _completedSession(questionCount: 2);

      await notifier.persistCompleted(completed);
      await notifier.persistCompleted(other);

      expect(store.stored.length, 2);
    });
  });

  group('History maintenance', () {
    test('deleting a session removes it from the state', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);
      await notifier.persistCompleted(completed);
      final id = notifier.state.sessions.single.id;

      await notifier.deleteSession(id);

      expect(notifier.state.isEmpty, isTrue);
    });

    test('clearing the history empties the state', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);
      await notifier.persistCompleted(completed);

      await notifier.clearHistory();

      expect(notifier.state.isEmpty, isTrue);
    });

    test('the history is trimmed to the maximum number of sessions', () async {
      final store = FakeSessionStore();
      final notifier = SessionHistoryNotifier(() async => store);

      for (var day = 1; day <= 3; day++) {
        store.stored.add(
          GameSession(
            id: 'day-$day',
            createdAt: DateTime.utc(2026, 5, day),
            players: const [Player(id: 'p1', name: 'Alice')],
            settings: const GameSettings(),
          ),
        );
      }

      await notifier.persistCompleted(completed);

      expect(store.trimCalls, kMaxStoredSessions);
      expect(store.stored.length, 4);
    });
  });
}
