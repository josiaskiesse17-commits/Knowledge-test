import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/json_parsing.dart';
import 'package:knowledge_test/models/questions/index.dart';

class SoloConfig {
  final List<GameMode> modes;
  final List<QuestionCategory> categories;
  final Difficulty difficulty;
  final int questionCount;
  final bool shuffle;

  const SoloConfig({
    this.modes = const [],
    this.categories = const [],
    this.difficulty = Difficulty.medium,
    this.questionCount = 10,
    this.shuffle = true,
  });

  SoloConfig copyWith({
    List<GameMode>? modes,
    List<QuestionCategory>? categories,
    Difficulty? difficulty,
    int? questionCount,
    bool? shuffle,
  }) {
    return SoloConfig(
      modes: modes ?? this.modes,
      categories: categories ?? this.categories,
      difficulty: difficulty ?? this.difficulty,
      questionCount: questionCount ?? this.questionCount,
      shuffle: shuffle ?? this.shuffle,
    );
  }

  List<String> validate() {
    final errors = <String>[];
    if (modes.isEmpty) {
      errors.add('noMode');
    }
    if (questionCount < 1) {
      errors.add('questionCountTooLow');
    }
    return errors;
  }

  bool get isValid => validate().isEmpty;

  Map<String, dynamic> toJson() {
    return {
      'modes': modes.map((m) => m.name).toList(),
      'categories': categories.map((c) => c.name).toList(),
      'difficulty': difficulty.name,
      'questionCount': questionCount,
      'shuffle': shuffle,
    };
  }

  factory SoloConfig.fromJson(Map<String, dynamic> json) {
    final modes = <GameMode>[];
    for (final name in (json['modes'] as List<dynamic>? ?? const <dynamic>[])) {
      final mode = enumByNameOrNull(GameMode.values, name);
      if (mode != null) {
        modes.add(mode);
      }
    }
    final categories = <QuestionCategory>[];
    for (final name
        in (json['categories'] as List<dynamic>? ?? const <dynamic>[])) {
      final category = enumByNameOrNull(QuestionCategory.values, name);
      if (category != null) {
        categories.add(category);
      }
    }
    return SoloConfig(
      modes: modes,
      categories: categories,
      difficulty:
          enumByNameOrNull(Difficulty.values, json['difficulty']) ??
          Difficulty.medium,
      questionCount: (json['questionCount'] as int? ?? 10).clamp(1, 100),
      shuffle: json['shuffle'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloConfig &&
          runtimeType == other.runtimeType &&
          listEqualsByValue(modes, other.modes) &&
          listEqualsByValue(categories, other.categories) &&
          difficulty == other.difficulty &&
          questionCount == other.questionCount &&
          shuffle == other.shuffle;

  @override
  int get hashCode => Object.hash(
    listHashCode(modes),
    listHashCode(categories),
    difficulty,
    questionCount,
    shuffle,
  );

  @override
  String toString() =>
      'SoloConfig(modes: $modes, categories: $categories, difficulty: $difficulty, questionCount: $questionCount, shuffle: $shuffle)';
}

class SoloAnswer {
  final String questionId;
  final String userAnswer;
  final bool isCorrect;
  final int pointsEarned;
  final DateTime answeredAt;

  const SoloAnswer({
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
    required this.pointsEarned,
    required this.answeredAt,
  });

  SoloAnswer copyWith({
    String? questionId,
    String? userAnswer,
    bool? isCorrect,
    int? pointsEarned,
    DateTime? answeredAt,
  }) {
    return SoloAnswer(
      questionId: questionId ?? this.questionId,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'pointsEarned': pointsEarned,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  factory SoloAnswer.fromJson(Map<String, dynamic> json) {
    return SoloAnswer(
      questionId: json['questionId'] as String? ?? '',
      userAnswer: json['userAnswer'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      pointsEarned: json['pointsEarned'] as int? ?? 0,
      answeredAt:
          parseDateOrNull(json['answeredAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloAnswer &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId &&
          userAnswer == other.userAnswer &&
          isCorrect == other.isCorrect &&
          pointsEarned == other.pointsEarned &&
          answeredAt == other.answeredAt;

  @override
  int get hashCode =>
      Object.hash(questionId, userAnswer, isCorrect, pointsEarned, answeredAt);

  @override
  String toString() =>
      'SoloAnswer(questionId: $questionId, isCorrect: $isCorrect, pointsEarned: $pointsEarned)';
}

class SoloCheckResult {
  final bool isCorrect;
  final String canonicalAnswer;

  const SoloCheckResult({
    required this.isCorrect,
    required this.canonicalAnswer,
  });
}

class SoloCategoryAccuracy {
  final QuestionCategory category;
  final int correct;
  final int total;
  final double percentage;

  const SoloCategoryAccuracy({
    required this.category,
    required this.correct,
    required this.total,
    required this.percentage,
  });

  SoloCategoryAccuracy copyWith({
    QuestionCategory? category,
    int? correct,
    int? total,
    double? percentage,
  }) {
    return SoloCategoryAccuracy(
      category: category ?? this.category,
      correct: correct ?? this.correct,
      total: total ?? this.total,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloCategoryAccuracy &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          correct == other.correct &&
          total == other.total &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(category, correct, total, percentage);

  @override
  String toString() =>
      'SoloCategoryAccuracy(category: $category, correct: $correct, total: $total, percentage: $percentage)';
}

class SoloMistake {
  final String questionId;
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final QuestionCategory category;
  final Difficulty difficulty;

  const SoloMistake({
    required this.questionId,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.category,
    required this.difficulty,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloMistake &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId &&
          questionText == other.questionText &&
          userAnswer == other.userAnswer &&
          correctAnswer == other.correctAnswer &&
          category == other.category &&
          difficulty == other.difficulty;

  @override
  int get hashCode => Object.hash(
    questionId,
    questionText,
    userAnswer,
    correctAnswer,
    category,
    difficulty,
  );

  @override
  String toString() =>
      'SoloMistake(questionId: $questionId, userAnswer: $userAnswer, correctAnswer: $correctAnswer)';
}

class SoloSession {
  final SoloConfig config;
  final List<BaseQuestion> questions;
  final List<SoloAnswer> answers;
  final int currentIndex;
  final int score;
  final int streak;
  final int maxStreak;
  final GameStatus status;
  final String id;
  final DateTime? completedAt;

  const SoloSession({
    required this.config,
    this.questions = const [],
    this.answers = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.streak = 0,
    this.maxStreak = 0,
    this.status = GameStatus.pending,
    this.id = '',
    this.completedAt,
  });

  bool get isCompleted => status == GameStatus.completed;
  bool get isInProgress => status == GameStatus.inProgress;
  int get answeredCount => answers.length;
  int get remainingCount =>
      (questions.length - currentIndex).clamp(0, questions.length);
  BaseQuestion? get currentQuestion =>
      (currentIndex >= 0 && currentIndex < questions.length)
      ? questions[currentIndex]
      : null;
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get wrongCount => answers.where((a) => !a.isCorrect).length;
  double get accuracy =>
      answeredCount == 0 ? 0 : correctCount / answeredCount * 100;

  SoloSession copyWith({
    SoloConfig? config,
    List<BaseQuestion>? questions,
    List<SoloAnswer>? answers,
    int? currentIndex,
    int? score,
    int? streak,
    int? maxStreak,
    GameStatus? status,
    String? id,
    DateTime? completedAt,
  }) {
    final nextQuestions = questions ?? this.questions;
    final nextIndex = (currentIndex ?? this.currentIndex).clamp(
      0,
      nextQuestions.length,
    );
    return SoloSession(
      config: config ?? this.config,
      questions: nextQuestions,
      answers: answers ?? this.answers,
      currentIndex: nextIndex,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      maxStreak: maxStreak ?? this.maxStreak,
      status: status ?? this.status,
      id: id ?? this.id,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config': config.toJson(),
      'questions': questions.map((q) => q.toJson()).toList(),
      'answers': answers.map((a) => a.toJson()).toList(),
      'currentIndex': currentIndex,
      'score': score,
      'streak': streak,
      'maxStreak': maxStreak,
      'status': status.name,
      'id': id,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory SoloSession.fromJson(Map<String, dynamic> json) {
    final questions = <BaseQuestion>[];
    for (final entry
        in (json['questions'] as List<dynamic>? ?? const <dynamic>[])) {
      if (entry is! Map<String, dynamic>) continue;
      try {
        questions.add(BaseQuestion.fromJson(entry));
      } catch (_) {}
    }
    final answers = <SoloAnswer>[];
    for (final entry
        in (json['answers'] as List<dynamic>? ?? const <dynamic>[])) {
      if (entry is! Map<String, dynamic>) continue;
      try {
        answers.add(SoloAnswer.fromJson(entry));
      } catch (_) {}
    }
    final configJson = json['config'];
    final config = configJson is Map<String, dynamic>
        ? SoloConfig.fromJson(configJson)
        : const SoloConfig();
    return SoloSession(
      config: config,
      questions: questions,
      answers: answers,
      currentIndex: (json['currentIndex'] as int? ?? 0).clamp(
        0,
        questions.length,
      ),
      score: json['score'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      maxStreak: json['maxStreak'] as int? ?? 0,
      status:
          enumByNameOrNull(GameStatus.values, json['status']) ??
          GameStatus.pending,
      id: json['id'] as String? ?? '',
      completedAt: parseDateOrNull(json['completedAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloSession &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          listEqualsByValue(questions, other.questions) &&
          listEqualsByValue(answers, other.answers) &&
          currentIndex == other.currentIndex &&
          score == other.score &&
          streak == other.streak &&
          maxStreak == other.maxStreak &&
          status == other.status &&
          id == other.id &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hash(
    config,
    listHashCode(questions),
    listHashCode(answers),
    currentIndex,
    score,
    streak,
    maxStreak,
    status,
    id,
    completedAt,
  );

  @override
  String toString() =>
      'SoloSession(status: $status, question: ${currentIndex + 1}/${questions.length}, score: $score, streak: $streak, id: $id, completedAt: $completedAt)';
}

/// One answered question kept for the solo question history.
///
/// Used to avoid repeating recently played questions and to build the
/// end-of-session review. Stored under its own key, separate from the session
/// history.
class SoloQuestionRecord {
  final String questionId;
  final GameMode mode;
  final QuestionCategory category;
  final Difficulty difficulty;
  final bool correct;
  final String userAnswer;
  final String correctAnswer;
  final DateTime answeredAt;

  const SoloQuestionRecord({
    required this.questionId,
    required this.mode,
    required this.category,
    required this.difficulty,
    required this.correct,
    required this.userAnswer,
    required this.correctAnswer,
    required this.answeredAt,
  });

  SoloQuestionRecord copyWith({
    String? questionId,
    GameMode? mode,
    QuestionCategory? category,
    Difficulty? difficulty,
    bool? correct,
    String? userAnswer,
    String? correctAnswer,
    DateTime? answeredAt,
  }) {
    return SoloQuestionRecord(
      questionId: questionId ?? this.questionId,
      mode: mode ?? this.mode,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      correct: correct ?? this.correct,
      userAnswer: userAnswer ?? this.userAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'mode': mode.name,
      'category': category.name,
      'difficulty': difficulty.name,
      'correct': correct,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  factory SoloQuestionRecord.fromJson(Map<String, dynamic> json) {
    return SoloQuestionRecord(
      questionId: json['questionId'] as String? ?? '',
      mode:
          enumByNameOrNull(GameMode.values, json['mode']) ??
          GameMode.whichCameFirst,
      category:
          enumByNameOrNull(QuestionCategory.values, json['category']) ??
          QuestionCategory.general,
      difficulty:
          enumByNameOrNull(Difficulty.values, json['difficulty']) ??
          Difficulty.medium,
      correct: json['correct'] as bool? ?? false,
      userAnswer: json['userAnswer'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? '',
      answeredAt:
          parseDateOrNull(json['answeredAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoloQuestionRecord &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId &&
          mode == other.mode &&
          category == other.category &&
          difficulty == other.difficulty &&
          correct == other.correct &&
          userAnswer == other.userAnswer &&
          correctAnswer == other.correctAnswer &&
          answeredAt == other.answeredAt;

  @override
  int get hashCode => Object.hash(
    questionId,
    mode,
    category,
    difficulty,
    correct,
    userAnswer,
    correctAnswer,
    answeredAt,
  );

  @override
  String toString() =>
      'SoloQuestionRecord(questionId: $questionId, correct: $correct, answeredAt: $answeredAt)';
}
