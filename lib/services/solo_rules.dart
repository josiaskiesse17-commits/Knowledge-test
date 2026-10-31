import 'dart:math';

import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';

const int kSoloBasePointsEasy = 10;
const int kSoloBasePointsMedium = 15;
const int kSoloBasePointsHard = 20;

const double kSoloHowMuchToleranceEasy = 0.20;
const double kSoloHowMuchToleranceMedium = 0.10;
const double kSoloHowMuchToleranceHard = 0.05;

class SoloRules {
  const SoloRules._();

  static SoloSession buildSession({
    required SoloConfig config,
    required List<BaseQuestion> allQuestions,
    List<String> recentQuestionIds = const [],
    Random? random,
  }) {
    final rng = random ?? Random();
    final modes = config.modes.isEmpty
        ? GameMode.values.toList()
        : config.modes;

    var pool = allQuestions.where((q) => modes.contains(q.mode)).toList();
    if (config.categories.isNotEmpty) {
      final byCategory = pool
          .where((q) => config.categories.contains(q.category))
          .toList();
      pool = byCategory.isNotEmpty ? byCategory : pool;
    }
    if (pool.isEmpty) {
      pool = allQuestions;
    }

    final preferred = pool
        .where((q) => q.difficulty == config.difficulty)
        .toList();
    final others = pool
        .where((q) => q.difficulty != config.difficulty)
        .toList();
    final recentSet = recentQuestionIds.toSet();
    final fresh = [
      ...preferred,
      ...others,
    ].where((q) => !recentSet.contains(q.id)).toList();
    final stale = [
      ...preferred,
      ...others,
    ].where((q) => recentSet.contains(q.id)).toList()..shuffle(rng);

    final picked = <BaseQuestion>[];
    final usedFactGroups = <String>{};

    void takeFrom(List<BaseQuestion> candidates) {
      if (picked.length >= config.questionCount) {
        return;
      }
      final buckets = <GameMode, List<BaseQuestion>>{};
      for (final question in candidates) {
        buckets.putIfAbsent(question.mode, () => []).add(question);
      }
      final modeOrder = modes.isEmpty
          ? buckets.keys.toList()
          : [
              ...modes.where((m) => buckets.containsKey(m)),
              ...buckets.keys.where((m) => !modes.contains(m)),
            ];
      for (final mode in modeOrder) {
        for (final question in buckets[mode]!) {
          if (picked.length >= config.questionCount) {
            return;
          }
          if (usedFactGroups.contains(question.factGroupId)) {
            continue;
          }
          usedFactGroups.add(question.factGroupId);
          picked.add(question);
        }
      }
    }

    takeFrom(fresh);
    takeFrom(stale);

    if (config.shuffle) {
      picked.shuffle(rng);
    }

    return SoloSession(
      config: config,
      questions: picked,
      status: GameStatus.inProgress,
    );
  }

  static SoloCheckResult checkAnswer(BaseQuestion question, String userAnswer) {
    switch (question) {
      case WhichCameFirstQuestion():
        return _checkWhichCameFirst(question, userAnswer);
      case GuessTheCountryQuestion():
        return _checkGuessTheCountry(question, userAnswer);
      case FactOrCapQuestion():
        return _checkFactOrCap(question, userAnswer);
      case PutInOrderQuestion():
        return _checkPutInOrder(question, userAnswer);
      case HowMuchQuestion():
        return _checkHowMuch(question, userAnswer);
      default:
        throw ArgumentError(
          'Unsupported question type: ${question.runtimeType}',
        );
    }
  }

  static SoloSession recordAnswer(
    SoloSession session,
    String userAnswer, {
    DateTime? now,
  }) {
    if (session.isCompleted) {
      return session;
    }
    final question = session.currentQuestion;
    if (question == null) {
      return session;
    }
    final result = checkAnswer(question, userAnswer);
    final answeredAt = now ?? DateTime.now();

    int pointsEarned = 0;
    int newStreak = session.streak;
    int newMaxStreak = session.maxStreak;

    if (result.isCorrect) {
      newStreak = session.streak + 1;
      if (newStreak > newMaxStreak) {
        newMaxStreak = newStreak;
      }
      final base = _basePoints(question.difficulty);
      final bonus = newStreak > 1 ? newStreak - 1 : 0;
      pointsEarned = base + bonus;
    } else {
      newStreak = 0;
    }

    final answer = SoloAnswer(
      questionId: question.id,
      userAnswer: userAnswer,
      isCorrect: result.isCorrect,
      pointsEarned: pointsEarned,
      answeredAt: answeredAt,
    );
    final answers = [...session.answers, answer];
    final nextIndex = session.currentIndex + 1;
    final status = nextIndex >= session.questions.length
        ? GameStatus.completed
        : GameStatus.inProgress;

    return session.copyWith(
      answers: answers,
      currentIndex: nextIndex,
      score: session.score + pointsEarned,
      streak: newStreak,
      maxStreak: newMaxStreak,
      status: status,
    );
  }

  static double overallAccuracy(SoloSession session) {
    if (session.answeredCount == 0) {
      return 0;
    }
    return session.correctCount / session.answeredCount * 100;
  }

  static Map<QuestionCategory, SoloCategoryAccuracy> accuracyByCategory(
    SoloSession session,
  ) {
    final correctByCategory = <QuestionCategory, int>{};
    final totalByCategory = <QuestionCategory, int>{};
    for (var i = 0; i < session.answers.length; i++) {
      if (i >= session.questions.length) {
        break;
      }
      final category = session.questions[i].category;
      totalByCategory[category] = (totalByCategory[category] ?? 0) + 1;
      if (session.answers[i].isCorrect) {
        correctByCategory[category] = (correctByCategory[category] ?? 0) + 1;
      }
    }
    return <QuestionCategory, SoloCategoryAccuracy>{
      for (final category in totalByCategory.keys)
        category: SoloCategoryAccuracy(
          category: category,
          correct: correctByCategory[category] ?? 0,
          total: totalByCategory[category]!,
          percentage: totalByCategory[category] == 0
              ? 0
              : (correctByCategory[category] ?? 0) /
                    totalByCategory[category]! *
                    100,
        ),
    };
  }

  static List<SoloMistake> mistakes(SoloSession session) {
    final mistakes = <SoloMistake>[];
    for (var i = 0; i < session.answers.length; i++) {
      if (i >= session.questions.length) {
        break;
      }
      final answer = session.answers[i];
      if (answer.isCorrect) {
        continue;
      }
      final question = session.questions[i];
      final canonical = checkAnswer(
        question,
        answer.userAnswer,
      ).canonicalAnswer;
      mistakes.add(
        SoloMistake(
          questionId: question.id,
          questionText: question.text,
          userAnswer: answer.userAnswer,
          correctAnswer: canonical,
          category: question.category,
          difficulty: question.difficulty,
        ),
      );
    }
    return mistakes;
  }

  static SoloCheckResult _checkWhichCameFirst(
    WhichCameFirstQuestion question,
    String userAnswer,
  ) {
    final index = int.tryParse(userAnswer.trim());
    final isCorrect = index != null && index == question.correctFirstIndex;
    final canonical = question.events[question.correctFirstIndex].label;
    return SoloCheckResult(isCorrect: isCorrect, canonicalAnswer: canonical);
  }

  static SoloCheckResult _checkGuessTheCountry(
    GuessTheCountryQuestion question,
    String userAnswer,
  ) {
    final normalized = _normalize(userAnswer);
    final accepted = question.acceptedAnswers
        .where((a) => a.isNotEmpty)
        .map(_normalize)
        .toSet();
    final isCorrect = accepted.contains(normalized);
    return SoloCheckResult(
      isCorrect: isCorrect,
      canonicalAnswer: question.targetCountry,
    );
  }

  static SoloCheckResult _checkFactOrCap(
    FactOrCapQuestion question,
    String userAnswer,
  ) {
    final index = int.tryParse(userAnswer.trim());
    final lieIndex = question.lieStatementIndex;
    final falseIndex = question.falseStatementIndex;

    bool isCorrect;
    String canonical;
    if (lieIndex != null) {
      isCorrect = index != null && index == lieIndex;
      canonical = question.statements[lieIndex].text;
    } else if (falseIndex != null) {
      isCorrect = index != null && index == falseIndex;
      canonical = question.statements[falseIndex].text;
    } else {
      final statement = question.statements.isNotEmpty
          ? question.statements.first
          : null;
      final isTrue = statement?.isTrue ?? false;
      final user = userAnswer.trim().toLowerCase();
      isCorrect = (user == 'true') == isTrue;
      canonical = statement?.text ?? '';
    }
    return SoloCheckResult(isCorrect: isCorrect, canonicalAnswer: canonical);
  }

  static SoloCheckResult _checkPutInOrder(
    PutInOrderQuestion question,
    String userAnswer,
  ) {
    final ordered = userAnswer
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final correct = question.correctOrderIds;
    final isCorrect =
        ordered.length == correct.length &&
        ordered.asMap().entries.every((e) => e.value == correct[e.key]);
    final byId = {for (final item in question.items) item.id: item};
    final canonical = correct
        .map((id) => byId[id]?.label ?? id)
        .join(' \u2192 ');
    return SoloCheckResult(isCorrect: isCorrect, canonicalAnswer: canonical);
  }

  static SoloCheckResult _checkHowMuch(
    HowMuchQuestion question,
    String userAnswer,
  ) {
    final answer = question.answer;
    final value = double.tryParse(userAnswer.trim());
    if (value == null) {
      return SoloCheckResult(
        isCorrect: false,
        canonicalAnswer:
            '${_formatValue(answer.referenceValue)} ${answer.unitFr ?? answer.unit}',
      );
    }

    double reference = answer.referenceValue;
    final significantFigures = answer.significantFigures;
    if (significantFigures != null && significantFigures > 0) {
      reference = _roundToSignificantFigures(reference, significantFigures);
      final rounded = _roundToSignificantFigures(value, significantFigures);
      return _evaluateHowMuch(rounded, reference, answer, question.difficulty);
    }
    return _evaluateHowMuch(value, reference, answer, question.difficulty);
  }

  static SoloCheckResult _evaluateHowMuch(
    double value,
    double reference,
    EstimationAnswer answer,
    Difficulty difficulty,
  ) {
    final canonical =
        '${_formatValue(reference)} ${answer.unitFr ?? answer.unit}';
    bool isCorrect;
    if (answer.acceptedMin != null && answer.acceptedMax != null) {
      isCorrect = value >= answer.acceptedMin! && value <= answer.acceptedMax!;
    } else {
      final tolerance = _howMuchTolerance(difficulty);
      if (reference == 0) {
        isCorrect = value == 0;
      } else {
        isCorrect = (value - reference).abs() <= reference.abs() * tolerance;
      }
    }
    return SoloCheckResult(isCorrect: isCorrect, canonicalAnswer: canonical);
  }

  static double _howMuchTolerance(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return kSoloHowMuchToleranceEasy;
      case Difficulty.medium:
        return kSoloHowMuchToleranceMedium;
      case Difficulty.hard:
        return kSoloHowMuchToleranceHard;
    }
  }

  static int _basePoints(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return kSoloBasePointsEasy;
      case Difficulty.medium:
        return kSoloBasePointsMedium;
      case Difficulty.hard:
        return kSoloBasePointsHard;
    }
  }

  static String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  static double _roundToSignificantFigures(
    double value,
    int significantFigures,
  ) {
    if (value == 0 || !value.isFinite) {
      return value;
    }
    final exponent = (log(value.abs()) / ln10).floor();
    final scale = pow(10, exponent - significantFigures + 1).toDouble();
    return ((value / scale).round() * scale).toDouble();
  }

  static String _normalize(String s) {
    final out = StringBuffer();
    final lowered = s.toLowerCase();
    for (var i = 0; i < lowered.length; i++) {
      final ch = lowered[i];
      final base = _foldDiacritics[ch];
      final folded = base ?? ch;
      if (folded.contains(RegExp(r'[a-z0-9]'))) {
        out.write(folded);
      }
    }
    return out.toString();
  }
}

final Map<String, String> _foldDiacritics = _buildFoldDiacritics();

Map<String, String> _buildFoldDiacritics() {
  final map = <String, String>{};
  _addGroup(map, 'a', 'àáâãäå');
  _addGroup(map, 'c', 'ç');
  _addGroup(map, 'e', 'èéêë');
  _addGroup(map, 'i', 'ìíîï');
  _addGroup(map, 'n', 'ñ');
  _addGroup(map, 'o', 'òóôõöø');
  _addGroup(map, 'u', 'ùúûü');
  _addGroup(map, 'y', 'ýÿ');
  return map;
}

void _addGroup(Map<String, String> map, String base, String accented) {
  for (var i = 0; i < accented.length; i++) {
    map[accented[i]] = base;
  }
}
