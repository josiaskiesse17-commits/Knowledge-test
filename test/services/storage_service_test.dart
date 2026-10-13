import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

GameSession _session({
  String id = 'sess-1',
  DateTime? createdAt,
  int aliceScore = 3,
  int bobScore = 2,
}) {
  final date = createdAt ?? DateTime.utc(2026, 5, 4, 20);
  return GameSession(
    id: id,
    createdAt: date,
    players: [
      Player(id: 'p1', name: 'Alice', score: aliceScore),
      Player(id: 'p2', name: 'Bob', score: bobScore),
    ],
    settings: const GameSettings(questionCount: 5, difficulty: 'easy'),
    rounds: [
      RoundResult(
        roundNumber: 1,
        questionId: 'wcf-001',
        questionText: '',
        answers: const [],
        correctAnswer: '',
        answeredAt: date,
        outcome: QuestionOutcome.scored,
        awardedPlayerIds: const {'p1'},
      ),
      RoundResult(
        roundNumber: 2,
        questionId: 'wcf-002',
        questionText: '',
        answers: const [],
        correctAnswer: '',
        answeredAt: date,
        outcome: QuestionOutcome.skipped,
      ),
    ],
    status: GameStatus.completed,
    completedAt: date,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<StorageService> newStorage() => StorageService.create();

  group('Saving and loading sessions', () {
    test('a saved session is loaded back unchanged', () async {
      final storage = await newStorage();
      final session = _session();

      await storage.saveSession(session);
      final sessions = await storage.getSessions();

      expect(sessions, [session]);
    });

    test('sessions are returned most recent first', () async {
      final storage = await newStorage();
      final older = _session(id: 'old', createdAt: DateTime.utc(2026, 5, 1));
      final newer = _session(id: 'new', createdAt: DateTime.utc(2026, 5, 2));

      await storage.saveSession(older);
      await storage.saveSession(newer);

      final sessions = await storage.getSessions();
      expect(sessions.map((s) => s.id).toList(), ['new', 'old']);
    });

    test('saveSessionOnce writes the session only once', () async {
      final storage = await newStorage();

      expect(await storage.saveSessionOnce(_session()), isTrue);
      expect(await storage.saveSessionOnce(_session()), isFalse);

      final sessions = await storage.getSessions();
      expect(sessions.length, 1);
    });

    test('saveSessionOnce still writes a different session', () async {
      final storage = await newStorage();
      await storage.saveSessionOnce(_session(id: 'first'));

      expect(await storage.saveSessionOnce(_session(id: 'second')), isTrue);
      expect((await storage.getSessions()).length, 2);
    });

    test('updateSession replaces the stored sessions', () async {
      final storage = await newStorage();
      final session = _session();
      await storage.saveSession(session);

      await storage.updateSession(session.copyWith(
        players: session.players.map((p) => p.copyWith(score: 0)).toList(),
      ));

      final loaded = (await storage.getSessions()).single;
      expect(loaded.players.every((p) => p.score == 0), isTrue);
    });

    test('deleteSession removes only the requested session', () async {
      final storage = await newStorage();
      await storage.saveSession(_session(id: 'first'));
      await storage.saveSession(_session(id: 'second'));

      await storage.deleteSession('first');
      final sessions = await storage.getSessions();

      expect(sessions.map((s) => s.id).toList(), ['second']);
    });

    test('clearAllSessions empties the history', () async {
      final storage = await newStorage();
      await storage.saveSession(_session());

      await storage.clearAllSessions();

      expect(await storage.getSessions(), isEmpty);
    });
  });

  group('Damaged or older stored data', () {
    test('an empty or missing history loads as an empty list', () async {
      final storage = await newStorage();
      expect(await storage.getSessions(), isEmpty);
    });

    test('unreadable entries are skipped, readable ones are kept', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'game_sessions': <String>[
          'not json at all',
          '{}',
          '[]',
          jsonEncode(_session(id: 'valid').toJson()),
        ],
      });
      final storage = await newStorage();

      final sessions = await storage.getSessions();

      expect(sessions.map((s) => s.id).toList(), ['valid']);
    });

    test('a session saved by an older version loads with defaults', () async {
      // Older sessions carried no outcome, no awarded players and no completed
      // date, and sometimes a date that is not ISO-8601 at all.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'game_sessions': <String>[
          jsonEncode(<String, dynamic>{
            'id': 'legacy-1',
            'createdAt': 'whenever',
            'players': <dynamic>[
              <String, dynamic>{'id': 'p1', 'name': 'Alice', 'score': 4},
            ],
            'settings': 'not a map',
            'rounds': <dynamic>[
              <String, dynamic>{'roundNumber': 1, 'questionId': 'wcf-001'},
              'ignored',
            ],
          }),
        ],
      });
      final storage = await newStorage();

      final session = (await storage.getSessions()).single;

      expect(session.id, 'legacy-1');
      expect(session.createdAt, DateTime.fromMillisecondsSinceEpoch(0));
      expect(session.players.single.name, 'Alice');
      expect(session.settings, const GameSettings());
      expect(session.status, GameStatus.pending);
      expect(session.completedAt, isNull);
      expect(session.rounds.length, 1);
      expect(session.rounds.single.outcome, QuestionOutcome.pending);
      expect(session.rounds.single.awardedPlayerIds, isEmpty);
    });

    test('a session saved by a newer version keeps its unknown status', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'game_sessions': <String>[
          jsonEncode(<String, dynamic>{
            'id': 'future-1',
            'createdAt': '2026-05-04T18:00:00.000',
            'status': 'unknownStatus',
          }),
        ],
      });
      final storage = await newStorage();

      final session = (await storage.getSessions()).single;

      expect(session.status, GameStatus.pending);
      expect(session.players, isEmpty);
    });

    test('a partly damaged history still opens and can be extended', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'game_sessions': <String>[
          '{{{ broken',
          jsonEncode(_session(id: 'kept').toJson()),
        ],
      });
      final storage = await newStorage();

      expect((await storage.getSessions()).map((s) => s.id).toList(), ['kept']);

      await storage.saveSession(_session(id: 'added'));
      expect((await storage.getSessions()).length, 2);
    });
  });

  group('History size', () {
    test('trimHistory keeps only the most recent sessions', () async {
      final storage = await newStorage();
      for (var day = 1; day <= 4; day++) {
        await storage.saveSession(
          _session(id: 'day-$day', createdAt: DateTime.utc(2026, 5, day)),
        );
      }

      await storage.trimHistory(2);
      final sessions = await storage.getSessions();

      expect(sessions.map((s) => s.id).toList(), ['day-4', 'day-3']);
    });

    test('trimHistory does nothing below the limit', () async {
      final storage = await newStorage();
      await storage.saveSession(_session());

      await storage.trimHistory(10);

      expect((await storage.getSessions()).length, 1);
    });
  });

  group('Settings', () {
    test('settings survive a save and load', () async {
      final storage = await newStorage();
      const settings = GameSettings(questionCount: 7, timePerQuestion: 15);

      await storage.saveSettings(settings);

      expect(await storage.getSettings(), settings);
    });

    test('damaged settings fall back to the defaults', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'game_settings': 'not json',
      });
      final storage = await newStorage();

      expect(await storage.getSettings(), const GameSettings());
    });

    test('missing settings return the defaults', () async {
      final storage = await newStorage();
      expect(await storage.getSettings(), const GameSettings());
    });

    test('recent player names are capped and read back', () async {
      final storage = await newStorage();

      await storage.saveRecentPlayerNames(
          [for (var i = 0; i < 15; i++) 'Joueur $i']);

      expect((await storage.getRecentPlayerNames()).length, 10);
    });
  });
}
