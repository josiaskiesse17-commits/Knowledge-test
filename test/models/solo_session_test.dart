import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';

final DateTime _createdAt = DateTime.utc(2025, 1, 1);

WhichCameFirstQuestion wcf({String id = 'wcf-001', int correctFirstIndex = 1}) {
  return WhichCameFirstQuestion(
    id: id,
    category: QuestionCategory.history,
    difficulty: Difficulty.medium,
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
    correctFirstIndex: correctFirstIndex,
    correctSecondIndex: 0,
  );
}

SoloSession _session() {
  final q = wcf();
  return SoloSession(
    config: SoloConfig(
      modes: [GameMode.whichCameFirst],
      categories: [QuestionCategory.history],
      difficulty: Difficulty.medium,
      questionCount: 5,
      shuffle: true,
    ),
    questions: [q],
    answers: [
      SoloAnswer(
        questionId: q.id,
        userAnswer: '1',
        isCorrect: true,
        pointsEarned: 15,
        answeredAt: DateTime.utc(2025, 6, 1, 12, 0, 0),
      ),
    ],
    currentIndex: 1,
    score: 15,
    streak: 1,
    maxStreak: 1,
    status: GameStatus.inProgress,
  );
}

void main() {
  group('SoloSession toJson/fromJson round trip', () {
    test('round trip preserves every field', () {
      final session = _session();
      final json = session.toJson();
      final restored = SoloSession.fromJson(json);

      expect(restored, session);
      expect(restored.toJson(), session.toJson());
      expect(restored.runtimeType, session.runtimeType);
      expect(restored.config.modes, [GameMode.whichCameFirst]);
      expect(restored.config.difficulty, Difficulty.medium);
      expect(restored.config.questionCount, 5);
      expect(restored.questions.length, 1);
      expect(restored.questions.first.id, 'wcf-001');
      expect(restored.answers.length, 1);
      expect(restored.answers.first.isCorrect, true);
      expect(restored.answers.first.pointsEarned, 15);
      expect(restored.currentIndex, 1);
      expect(restored.score, 15);
      expect(restored.streak, 1);
      expect(restored.maxStreak, 1);
      expect(restored.status, GameStatus.inProgress);
    });

    test('completed session round trips', () {
      final q = wcf();
      final session = SoloSession(
        config: SoloConfig(modes: [GameMode.howMuch]),
        questions: [q],
        answers: [
          SoloAnswer(
            questionId: q.id,
            userAnswer: '5',
            isCorrect: false,
            pointsEarned: 0,
            answeredAt: DateTime.utc(2026, 1, 1),
          ),
        ],
        currentIndex: 1,
        score: 0,
        streak: 0,
        maxStreak: 0,
        status: GameStatus.completed,
      );
      final restored = SoloSession.fromJson(session.toJson());
      expect(restored, session);
      expect(restored.isCompleted, isTrue);
    });
  });

  group('SoloSession fromJson defensive decoding', () {
    test('missing config defaults to an empty valid config', () {
      final json = <String, dynamic>{
        'questions': [],
        'answers': [],
        'currentIndex': 0,
        'score': 0,
        'streak': 0,
        'maxStreak': 0,
        'status': 'inProgress',
      };
      final session = SoloSession.fromJson(json);
      expect(session.config.modes, isEmpty);
      expect(session.config.isValid, isFalse);
      expect(session.status, GameStatus.inProgress);
    });

    test('unreadable question is skipped instead of throwing', () {
      final q = wcf().toJson();
      final broken = Map<String, dynamic>.from(q)..remove('id');
      final json = <String, dynamic>{
        'config': {},
        'questions': [broken],
        'answers': [],
        'currentIndex': 0,
        'score': 0,
        'streak': 0,
        'maxStreak': 0,
        'status': 'inProgress',
      };
      expect(() => SoloSession.fromJson(json), returnsNormally);
      final session = SoloSession.fromJson(json);
      expect(session.questions, isEmpty);
      expect(session.currentIndex, 0);
    });

    test('corrupt status falls back to pending', () {
      final json = <String, dynamic>{
        'config': {},
        'questions': [],
        'answers': [],
        'currentIndex': 0,
        'score': 0,
        'streak': 0,
        'maxStreak': 0,
        'status': 'not-a-real-status',
      };
      final session = SoloSession.fromJson(json);
      expect(session.status, GameStatus.pending);
      expect(session.isCompleted, isFalse);
    });

    test('currentIndex is clamped to the question count', () {
      final q = wcf().toJson();
      final json = <String, dynamic>{
        'config': {},
        'questions': [q],
        'answers': [],
        'currentIndex': 999,
        'score': 0,
        'streak': 0,
        'maxStreak': 0,
        'status': 'inProgress',
      };
      final session = SoloSession.fromJson(json);
      expect(session.currentIndex, 1);
    });

    test('missing answers and numeric fields default safely', () {
      final json = <String, dynamic>{
        'config': {},
        'questions': [],
        'currentIndex': 0,
      };
      final session = SoloSession.fromJson(json);
      expect(session.answers, isEmpty);
      expect(session.score, 0);
      expect(session.streak, 0);
      expect(session.maxStreak, 0);
    });
  });

  group('SoloAnswer toJson/fromJson', () {
    test('round trip preserves fields', () {
      final answer = SoloAnswer(
        questionId: 'q1',
        userAnswer: '42',
        isCorrect: true,
        pointsEarned: 20,
        answeredAt: DateTime.utc(2025, 3, 3),
      );
      final restored = SoloAnswer.fromJson(answer.toJson());
      expect(restored, answer);
    });
  });
}
