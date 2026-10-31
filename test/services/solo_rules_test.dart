import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/services/solo_rules.dart';

final DateTime _createdAt = DateTime.utc(2025, 1, 1);

WhichCameFirstQuestion wcf({
  String id = 'wcf',
  QuestionCategory category = QuestionCategory.history,
  Difficulty difficulty = Difficulty.easy,
  String factGroupId = 'fg',
  int correctFirstIndex = 0,
  int correctSecondIndex = 1,
}) {
  return WhichCameFirstQuestion(
    id: id,
    category: category,
    difficulty: difficulty,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: factGroupId,
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
    correctSecondIndex: correctSecondIndex,
  );
}

GuessTheCountryQuestion gtc({
  String id = 'gtc',
  QuestionCategory category = QuestionCategory.geography,
  Difficulty difficulty = Difficulty.easy,
  String factGroupId = 'fg',
  String targetCountry = 'Japon',
  List<String> acceptedAnswers = const ['Japon', 'japon', 'Japan'],
}) {
  return GuessTheCountryQuestion(
    id: id,
    category: category,
    difficulty: difficulty,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: factGroupId,
    createdAt: _createdAt,
    targetCountry: targetCountry,
    targetCountryCode: 'JP',
    acceptedAnswers: acceptedAnswers,
    capital: 'Tokyo',
    continent: 'Asie',
    clues: const [],
  );
}

FactStatement _fs(String id, bool isTrue) =>
    FactStatement(id: id, text: 'statement $id', isTrue: isTrue);

FactOrCapQuestion foc({
  String id = 'foc',
  QuestionCategory category = QuestionCategory.science,
  Difficulty difficulty = Difficulty.easy,
  String factGroupId = 'fg',
  List<FactStatement> statements = const [],
  int? falseStatementIndex,
  int? lieStatementIndex,
}) {
  return FactOrCapQuestion(
    id: id,
    category: category,
    difficulty: difficulty,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: factGroupId,
    createdAt: _createdAt,
    statements: statements,
    falseStatementIndex: falseStatementIndex,
    lieStatementIndex: lieStatementIndex,
  );
}

PutInOrderQuestion pio({
  String id = 'pio',
  QuestionCategory category = QuestionCategory.science,
  Difficulty difficulty = Difficulty.easy,
  String factGroupId = 'fg',
  List<OrderableItem> items = const [],
  List<String> correctOrderIds = const [],
}) {
  return PutInOrderQuestion(
    id: id,
    category: category,
    difficulty: difficulty,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: factGroupId,
    createdAt: _createdAt,
    items: items,
    correctOrderIds: correctOrderIds,
  );
}

OrderableItem _oi(String id, String label, double value) =>
    OrderableItem(id: id, label: label, referenceValue: value, unit: 'u');

HowMuchQuestion hm({
  String id = 'hm',
  QuestionCategory category = QuestionCategory.general,
  Difficulty difficulty = Difficulty.easy,
  String factGroupId = 'fg',
  double referenceValue = 100,
  String unit = 'unit',
  double? acceptedMin,
  double? acceptedMax,
  int? significantFigures,
}) {
  return HowMuchQuestion(
    id: id,
    category: category,
    difficulty: difficulty,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: factGroupId,
    createdAt: _createdAt,
    answer: EstimationAnswer(
      referenceValue: referenceValue,
      unit: unit,
      unitFr: unit,
      acceptedMin: acceptedMin,
      acceptedMax: acceptedMax,
      scoringRuleId: 'rule',
      significantFigures: significantFigures,
    ),
  );
}

SoloSession _sessionWith(
  List<BaseQuestion> questions, {
  SoloConfig? config,
  int score = 0,
  int streak = 0,
  int maxStreak = 0,
}) {
  return SoloSession(
    config: config ?? SoloConfig(modes: GameMode.values.toList()),
    questions: questions,
    status: GameStatus.inProgress,
    score: score,
    streak: streak,
    maxStreak: maxStreak,
  );
}
SoloSession _answered(SoloSession session, String userAnswer,
    {DateTime? now}) {
  return SoloRules.recordAnswer(session, userAnswer, now: now);
}

void main() {
  group('SoloConfig', () {
    test('validate rejects empty modes and low questionCount', () {
      expect(
        SoloConfig(modes: const [], questionCount: 0).validate(),
        containsAll(['noMode', 'questionCountTooLow']),
      );
    });
    test('validate passes with modes and positive count', () {
      expect(
        SoloConfig(
          modes: [GameMode.whichCameFirst],
          questionCount: 5,
        ).validate(),
        isEmpty,
      );
    });
  });

  group('checkAnswer - WhichCameFirst', () {
    test('correct index is correct', () {
      final q = wcf(correctFirstIndex: 1, correctSecondIndex: 0);
      expect(SoloRules.checkAnswer(q, '1').isCorrect, isTrue);
    });
    test('wrong index is incorrect', () {
      final q = wcf(correctFirstIndex: 0, correctSecondIndex: 1);
      expect(SoloRules.checkAnswer(q, '1').isCorrect, isFalse);
    });
    test('non-numeric answer is incorrect', () {
      final q = wcf();
      expect(SoloRules.checkAnswer(q, 'first').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, '').isCorrect, isFalse);
    });
    test('canonical answer is the first event label', () {
      final q = wcf(correctFirstIndex: 1);
      expect(SoloRules.checkAnswer(q, '0').canonicalAnswer, 'Second wcf');
    });
  });

  group('checkAnswer - GuessTheCountry', () {
    test('exact accepted answer is correct', () {
      final q = gtc();
      expect(SoloRules.checkAnswer(q, 'Japon').isCorrect, isTrue);
    });
    test('case and accents are folded', () {
      final q = gtc();
      expect(SoloRules.checkAnswer(q, 'JAPON').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, 'japon').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, 'Japon!').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, 'J ap on').isCorrect, isTrue);
    });
    test('english accepted answer is correct', () {
      final q = gtc();
      expect(SoloRules.checkAnswer(q, 'Japan').isCorrect, isTrue);
    });
    test('wrong country is incorrect', () {
      final q = gtc();
      expect(SoloRules.checkAnswer(q, 'Chine').isCorrect, isFalse);
    });
    test('canonical answer is targetCountry', () {
      final q = gtc(targetCountry: 'Japon');
      expect(SoloRules.checkAnswer(q, 'Chine').canonicalAnswer, 'Japon');
    });
  });

  group('checkAnswer - FactOrCap', () {
    test('trueFalse true statement with true is correct', () {
      final q = foc(
        statements: [_fs('s1', true)],
        falseStatementIndex: null,
        lieStatementIndex: null,
      );
      expect(SoloRules.checkAnswer(q, 'true').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, 'false').isCorrect, isFalse);
    });
    test('trueFalse false statement with false is correct', () {
      final q = foc(
        statements: [_fs('s1', false)],
        falseStatementIndex: null,
        lieStatementIndex: null,
      );
      expect(SoloRules.checkAnswer(q, 'false').isCorrect, isTrue);
    });
    test('identifyFalse picks the false index', () {
      final q = foc(
        statements: [_fs('s1', true), _fs('s2', false), _fs('s3', true)],
        falseStatementIndex: 1,
        lieStatementIndex: null,
      );
      expect(SoloRules.checkAnswer(q, '1').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '0').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, '2').isCorrect, isFalse);
    });
    test('twoTruthsOneLie picks the lie index', () {
      final q = foc(
        statements: [_fs('s1', true), _fs('s2', true), _fs('s3', false)],
        falseStatementIndex: null,
        lieStatementIndex: 2,
      );
      expect(SoloRules.checkAnswer(q, '2').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '0').isCorrect, isFalse);
    });
    test('non-numeric index for statement mode is incorrect', () {
      final q = foc(
        statements: [_fs('s1', true), _fs('s2', false)],
        falseStatementIndex: 1,
        lieStatementIndex: null,
      );
      expect(SoloRules.checkAnswer(q, 'one').isCorrect, isFalse);
    });
  });

  group('checkAnswer - PutInOrder', () {
    test('exact correct order is correct', () {
      final q = pio(
        items: [_oi('a', 'A', 1), _oi('b', 'B', 2), _oi('c', 'C', 3)],
        correctOrderIds: ['a', 'b', 'c'],
      );
      expect(SoloRules.checkAnswer(q, 'a,b,c').isCorrect, isTrue);
    });
    test('wrong order is incorrect', () {
      final q = pio(
        items: [_oi('a', 'A', 1), _oi('b', 'B', 2)],
        correctOrderIds: ['a', 'b'],
      );
      expect(SoloRules.checkAnswer(q, 'b,a').isCorrect, isFalse);
    });
    test('missing or extra id is incorrect', () {
      final q = pio(
        items: [_oi('a', 'A', 1), _oi('b', 'B', 2)],
        correctOrderIds: ['a', 'b'],
      );
      expect(SoloRules.checkAnswer(q, 'a').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, 'a,b,c').isCorrect, isFalse);
    });
    test('canonical answer lists labels in correct order', () {
      final q = pio(
        items: [_oi('a', 'Alpha', 1), _oi('b', 'Beta', 2)],
        correctOrderIds: ['a', 'b'],
      );
      expect(
        SoloRules.checkAnswer(q, 'b,a').canonicalAnswer,
        'Alpha \u2192 Beta',
      );
    });
  });

  group('checkAnswer - HowMuch', () {
    test('accepted range inclusive boundaries are correct', () {
      final q = hm(referenceValue: 5837, acceptedMin: 5500, acceptedMax: 6200);
      expect(SoloRules.checkAnswer(q, '5500').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '6200').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '5837').isCorrect, isTrue);
    });
    test('accepted range outside is incorrect', () {
      final q = hm(referenceValue: 5837, acceptedMin: 5500, acceptedMax: 6200);
      expect(SoloRules.checkAnswer(q, '5499').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, '6201').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, 'abc').isCorrect, isFalse);
    });
    test('easy tolerance is 20 percent around reference', () {
      final q = hm(referenceValue: 100, difficulty: Difficulty.easy);
      expect(SoloRules.checkAnswer(q, '80').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '120').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '79').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, '121').isCorrect, isFalse);
    });
    test('medium tolerance is 10 percent around reference', () {
      final q = hm(referenceValue: 100, difficulty: Difficulty.medium);
      expect(SoloRules.checkAnswer(q, '90').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '110').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '89').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, '111').isCorrect, isFalse);
    });
    test('hard tolerance is 5 percent around reference', () {
      final q = hm(referenceValue: 100, difficulty: Difficulty.hard);
      expect(SoloRules.checkAnswer(q, '95').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '105').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '94').isCorrect, isFalse);
      expect(SoloRules.checkAnswer(q, '106').isCorrect, isFalse);
    });
    test('reference zero requires exact zero', () {
      final q = hm(referenceValue: 0, difficulty: Difficulty.easy);
      expect(SoloRules.checkAnswer(q, '0').isCorrect, isTrue);
      expect(SoloRules.checkAnswer(q, '1').isCorrect, isFalse);
    });
    test('canonical answer shows reference and unit', () {
      final q = hm(referenceValue: 5, unit: 'unit');
      expect(SoloRules.checkAnswer(q, '999').canonicalAnswer, '5 unit');
    });
  });

  group('recordAnswer scoring and streak', () {
    test('first correct easy answer awards 10 points, streak 1', () {
      final session = _sessionWith([wcf(difficulty: Difficulty.easy)]);
      final next = _answered(session, '0');
      expect(next.score, 10);
      expect(next.streak, 1);
      expect(next.maxStreak, 1);
      expect(next.answers.first.isCorrect, isTrue);
      expect(next.answers.first.pointsEarned, 10);
    });
    test('second consecutive correct adds streak bonus', () {
      final session = _sessionWith([
        wcf(difficulty: Difficulty.easy),
        wcf(difficulty: Difficulty.easy, id: 'wcf2'),
      ]);
      final first = _answered(session, '0');
      final second = _answered(first, '0');
      expect(second.score, 10 + 11);
      expect(second.streak, 2);
      expect(second.maxStreak, 2);
      expect(second.answers.last.pointsEarned, 11);
    });
    test('medium correct awards 15 plus streak bonus', () {
      final session = _sessionWith([
        wcf(difficulty: Difficulty.medium),
        wcf(difficulty: Difficulty.medium, id: 'wcf2'),
      ]);
      final first = _answered(session, '0');
      final second = _answered(first, '0');
      expect(first.score, 15);
      expect(second.score, 15 + 16);
    });
    test('hard correct awards 20', () {
      final session = _sessionWith([wcf(difficulty: Difficulty.hard)]);
      final next = _answered(session, '0');
      expect(next.score, 20);
    });
    test('wrong answer awards zero and resets streak', () {
      final session = _sessionWith([
        wcf(difficulty: Difficulty.easy),
        wcf(difficulty: Difficulty.easy, id: 'wcf2'),
      ]);
      final first = _answered(session, '0');
      expect(first.streak, 1);
      final second = _answered(first, '1');
      expect(second.score, 10);
      expect(second.streak, 0);
      expect(second.answers.last.pointsEarned, 0);
    });
    test('streak resumes after a wrong answer', () {
      final session = _sessionWith([
        wcf(id: 'a'),
        wcf(id: 'b'),
        wcf(id: 'c'),
        wcf(id: 'd'),
      ]);
      var s = _answered(session, '0');
      s = _answered(s, '1');
      s = _answered(s, '0');
      s = _answered(s, '0');
      expect(s.score, 10 + 0 + 10 + 11);
      expect(s.streak, 2);
      expect(s.maxStreak, 2);
    });
  });

  group('recordAnswer session completion', () {
    test('session completes after the last question', () {
      final session = _sessionWith([wcf(id: 'a')]);
      final next = _answered(session, '0');
      expect(next.isCompleted, isTrue);
      expect(next.status, GameStatus.completed);
      expect(next.currentIndex, 1);
    });
    test('session is not completed before the last question', () {
      final session = _sessionWith([wcf(id: 'a'), wcf(id: 'b')]);
      final next = _answered(session, '0');
      expect(next.isCompleted, isFalse);
      expect(next.status, GameStatus.inProgress);
      expect(next.currentIndex, 1);
    });
    test('recording on a completed session is a no-op', () {
      final session = _sessionWith([wcf(id: 'a')]);
      final completed = _answered(session, '0');
      final again = _answered(completed, '0');
      expect(again, completed);
      expect(again.answers.length, 1);
    });
  });

  group('buildSession', () {
    test('filters by mode', () {
      final session = SoloRules.buildSession(
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 5),
        allQuestions: [
          wcf(id: 'a'),
          gtc(id: 'b'),
        ],
      );
      expect(session.questions.length, 1);
      expect(session.questions.first.id, 'a');
    });
    test('filters by category', () {
      final session = SoloRules.buildSession(
        config: SoloConfig(
          modes: GameMode.values.toList(),
          categories: [QuestionCategory.history],
          questionCount: 5,
        ),
        allQuestions: [
          wcf(category: QuestionCategory.history),
          gtc(),
        ],
      );
      expect(
        session.questions.every((q) => q.category == QuestionCategory.history),
        isTrue,
      );
    });
    test('prefers the requested difficulty', () {
      final easy = wcf(id: 'e', difficulty: Difficulty.easy, factGroupId: 'fg-e');
      final hard = wcf(id: 'h', difficulty: Difficulty.hard, factGroupId: 'fg-h');
      final session = SoloRules.buildSession(
        config: SoloConfig(
          modes: GameMode.values.toList(),
          difficulty: Difficulty.hard,
          questionCount: 2,
          shuffle: false,
        ),
        allQuestions: [easy, hard],
      );
      expect(session.questions.map((q) => q.id), ['h', 'e']);
    });
    test('does not repeat a factGroupId when enough others exist', () {
      final a = wcf(id: 'a', factGroupId: 'shared');
      final b = wcf(id: 'b', factGroupId: 'shared');
      final c = wcf(id: 'c', factGroupId: 'other');
      final d = wcf(id: 'd', factGroupId: 'other2');
      final session = SoloRules.buildSession(
        config: SoloConfig(questionCount: 4, shuffle: false),
        allQuestions: [a, b, c, d],
      );
      final ids = session.questions.map((q) => q.id).toSet();
      expect(ids.contains('a') ^ ids.contains('b'), isTrue);
      expect(session.questions.length, 3);
    });
    test('recent questions are deferred until fresh pool is exhausted', () {
      final fresh = wcf(id: 'fresh', factGroupId: 'g1');
      final stale = wcf(id: 'stale', factGroupId: 'g2');
      final session = SoloRules.buildSession(
        config: SoloConfig(questionCount: 2, shuffle: false),
        allQuestions: [fresh, stale],
        recentQuestionIds: ['stale'],
      );
      expect(session.questions.map((q) => q.id), ['fresh', 'stale']);
    });
  });

  group('summary helpers', () {
    test('overall accuracy', () {
      final session = _sessionWith([wcf(id: 'a'), wcf(id: 'b'), wcf(id: 'c')]);
      var s = _answered(session, '0');
      s = _answered(s, '1');
      s = _answered(s, '0');
      expect(SoloRules.overallAccuracy(s), 2 / 3 * 100);
    });
    test('accuracy by category', () {
      final session = _sessionWith([
        wcf(id: 'a', category: QuestionCategory.history),
        wcf(id: 'b', category: QuestionCategory.history),
        wcf(id: 'c', category: QuestionCategory.science),
      ]);
      var s = _answered(session, '0');
      s = _answered(s, '1');
      s = _answered(s, '0');
      final byCat = SoloRules.accuracyByCategory(s);
      expect(byCat[QuestionCategory.history]?.correct, 1);
      expect(byCat[QuestionCategory.history]?.total, 2);
      expect(byCat[QuestionCategory.history]?.percentage, 50);
      expect(byCat[QuestionCategory.science]?.correct, 1);
      expect(byCat[QuestionCategory.science]?.total, 1);
      expect(byCat[QuestionCategory.science]?.percentage, 100);
    });
    test('mistakes list question and correct answer', () {
      final session = _sessionWith([
        wcf(id: 'a', correctFirstIndex: 1),
        gtc(id: 'b', targetCountry: 'Japon'),
      ]);
      var s = _answered(session, '1');
      s = _answered(s, 'Chine');
      final mistakes = SoloRules.mistakes(s);
      expect(mistakes.length, 1);
      expect(mistakes.first.questionId, 'b');
      expect(mistakes.first.userAnswer, 'Chine');
      expect(mistakes.first.correctAnswer, 'Japon');
    });
  });
}
