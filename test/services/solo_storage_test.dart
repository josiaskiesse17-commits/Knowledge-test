import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DateTime _createdAt = DateTime.utc(2025, 1, 1);

WhichCameFirstQuestion _question({String id = 'q-1'}) {
  return WhichCameFirstQuestion(
    id: id,
    category: QuestionCategory.history,
    difficulty: Difficulty.easy,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: 'fg-$id',
    createdAt: _createdAt,
    events: [
      ChronologyEvent(
        id: '$id-e1',
        label: 'First $id',
        date: DateTime.utc(1900, 1, 1),
      ),
      ChronologyEvent(
        id: '$id-e2',
        label: 'Second $id',
        date: DateTime.utc(2000, 1, 1),
      ),
    ],
    correctFirstIndex: 0,
    correctSecondIndex: 1,
  );
}

SoloSession _session({
  String id = 's-1',
  DateTime? completedAt,
  int score = 10,
}) {
  return SoloSession(
    id: id,
    config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 5),
    questions: [_question(id: 'q-1')],
    answers: [
      SoloAnswer(
        questionId: 'q-1',
        userAnswer: '0',
        isCorrect: true,
        pointsEarned: 10,
        answeredAt: DateTime.utc(2026, 5, 4, 20),
      ),
    ],
    currentIndex: 1,
    score: score,
    status: GameStatus.completed,
    completedAt: completedAt,
  );
}

SoloQuestionRecord _record({
  String questionId = 'q-1',
  bool correct = true,
  DateTime? answeredAt,
}) {
  return SoloQuestionRecord(
    questionId: questionId,
    mode: GameMode.whichCameFirst,
    category: QuestionCategory.history,
    difficulty: Difficulty.easy,
    correct: correct,
    userAnswer: '0',
    correctAnswer: 'First q-1',
    answeredAt: answeredAt ?? DateTime.utc(2026, 5, 4, 20),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<StorageService> newStorage() => StorageService.create();

  group('Solo sessions', () {
    test('a saved session is loaded back unchanged', () async {
      final storage = await newStorage();
      final session = _session();

      expect(await storage.saveSoloSession(session), isTrue);
      final sessions = await storage.getSoloSessions();

      expect(sessions, [session]);
    });

    test('saveSoloSession is idempotent by id', () async {
      final storage = await newStorage();
      final session = _session();

      expect(await storage.saveSoloSession(session), isTrue);
      expect(await storage.saveSoloSession(session), isFalse);

      expect((await storage.getSoloSessions()).length, 1);
    });

    test('sessions are returned most recent first', () async {
      final storage = await newStorage();
      final older = _session(id: 'old', completedAt: DateTime.utc(2026, 5, 1));
      final newer = _session(id: 'new', completedAt: DateTime.utc(2026, 5, 2));

      await storage.saveSoloSession(older);
      await storage.saveSoloSession(newer);

      final sessions = await storage.getSoloSessions();
      expect(sessions.map((s) => s.id).toList(), ['new', 'old']);
    });

    test('sessions without a completedAt sort as oldest', () async {
      final storage = await newStorage();
      final dated = _session(
        id: 'dated',
        completedAt: DateTime.utc(2026, 5, 2),
      );
      final undated = _session(id: 'undated');

      await storage.saveSoloSession(dated);
      await storage.saveSoloSession(undated);

      final sessions = await storage.getSoloSessions();
      expect(sessions.map((s) => s.id).toList(), ['dated', 'undated']);
    });

    test('history is capped at 100 sessions', () async {
      final storage = await newStorage();
      for (var i = 0; i < 102; i++) {
        await storage.saveSoloSession(
          _session(
            id: 's-$i',
            completedAt: DateTime.utc(2026, 5, 1).add(Duration(days: i)),
          ),
        );
      }

      final sessions = await storage.getSoloSessions();
      expect(sessions.length, 100);
      expect(sessions.first.id, 's-101');
    });

    test('deleteSoloSession removes only the requested session', () async {
      final storage = await newStorage();
      await storage.saveSoloSession(_session(id: 'first'));
      await storage.saveSoloSession(_session(id: 'second'));

      await storage.deleteSoloSession('first');
      final sessions = await storage.getSoloSessions();

      expect(sessions.map((s) => s.id).toList(), ['second']);
    });

    test('clearSoloSessions empties the history', () async {
      final storage = await newStorage();
      await storage.saveSoloSession(_session());

      await storage.clearSoloSessions();

      expect(await storage.getSoloSessions(), isEmpty);
    });

    test('missing history loads as an empty list', () async {
      final storage = await newStorage();
      expect(await storage.getSoloSessions(), isEmpty);
    });

    test('unreadable entries are skipped, readable ones are kept', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'solo_sessions': <String>[
          'not json',
          jsonEncode(_session(id: 'valid').toJson()),
        ],
      });
      final storage = await newStorage();

      final sessions = await storage.getSoloSessions();

      expect(sessions.map((s) => s.id).toList(), ['valid']);
    });

    test('a session without an id is not stored', () async {
      final storage = await newStorage();
      final session = _session(id: '')..copyWith(id: '');

      // copyWith(id: '') keeps the empty id; decode rejects empty-id entries.
      await storage.saveSoloSession(session);
      expect(await storage.getSoloSessions(), isEmpty);
    });
  });

  group('Solo question history', () {
    test('records are saved and loaded back', () async {
      final storage = await newStorage();
      final record = _record();

      await storage.saveSoloQuestionHistory(record);
      final history = await storage.getSoloQuestionHistory();

      expect(history, [record]);
    });

    test('records are newest first', () async {
      final storage = await newStorage();
      final older = _record(
        questionId: 'q-old',
        answeredAt: DateTime.utc(2026, 5, 1),
      );
      final newer = _record(
        questionId: 'q-new',
        answeredAt: DateTime.utc(2026, 5, 2),
      );

      await storage.saveSoloQuestionHistory(older);
      await storage.saveSoloQuestionHistory(newer);

      final history = await storage.getSoloQuestionHistory();
      expect(history.map((r) => r.questionId).toList(), ['q-new', 'q-old']);
    });

    test('history is capped at 2000 records', () async {
      final storage = await newStorage();
      for (var i = 0; i < 2002; i++) {
        await storage.saveSoloQuestionHistory(
          _record(
            questionId: 'q-$i',
            answeredAt: DateTime.utc(2026, 5, 1).add(Duration(days: i)),
          ),
        );
      }

      final history = await storage.getSoloQuestionHistory();
      expect(history.length, 2000);
      expect(history.first.questionId, 'q-2001');
    });

    test('corrupt entries are skipped', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'solo_question_history': <String>[
          'not json',
          jsonEncode(_record(questionId: 'kept').toJson()),
        ],
      });
      final storage = await newStorage();

      final history = await storage.getSoloQuestionHistory();

      expect(history.map((r) => r.questionId).toList(), ['kept']);
    });

    test('clearSoloQuestionHistory empties the history', () async {
      final storage = await newStorage();
      await storage.saveSoloQuestionHistory(_record());

      await storage.clearSoloQuestionHistory();

      expect(await storage.getSoloQuestionHistory(), isEmpty);
    });
  });

  group('Solo in-progress session', () {
    test('an in-progress session is saved and loaded back', () async {
      final storage = await newStorage();
      final session = _session().copyWith(status: GameStatus.inProgress);

      await storage.saveSoloInProgress(session);
      final loaded = await storage.getSoloInProgress();

      expect(loaded, session);
    });

    test('missing in-progress returns null', () async {
      final storage = await newStorage();
      expect(await storage.getSoloInProgress(), isNull);
    });

    test(
      'a corrupt in-progress value returns null instead of throwing',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          'solo_in_progress': 'not json at all',
        });
        final storage = await newStorage();

        expect(await storage.getSoloInProgress(), isNull);
      },
    );

    test('saving overwrites the previous in-progress session', () async {
      final storage = await newStorage();
      await storage.saveSoloInProgress(_session(id: 'first'));
      await storage.saveSoloInProgress(_session(id: 'second'));

      expect((await storage.getSoloInProgress())?.id, 'second');
    });

    test('clearSoloInProgress removes it', () async {
      final storage = await newStorage();
      await storage.saveSoloInProgress(_session());

      await storage.clearSoloInProgress();

      expect(await storage.getSoloInProgress(), isNull);
    });
  });
}
