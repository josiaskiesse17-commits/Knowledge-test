/// Settings recorded with a session.
///
/// [SessionConfig] holds the quizmaster's draft, with mixed modes, categories
/// and a duration; these settings are the flattened form stored in the history.
class GameSettings {
  final int questionCount;
  final int timePerQuestion;
  final bool randomizeQuestions;
  final bool showCorrectAnswer;
  final String category;
  final String difficulty;

  const GameSettings({
    this.questionCount = 10,
    this.timePerQuestion = 30,
    this.randomizeQuestions = false,
    this.showCorrectAnswer = false,
    this.category = 'general',
    this.difficulty = 'medium',
  });

  GameSettings copyWith({
    int? questionCount,
    int? timePerQuestion,
    bool? randomizeQuestions,
    bool? showCorrectAnswer,
    String? category,
    String? difficulty,
  }) {
    return GameSettings(
      questionCount: questionCount ?? this.questionCount,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      randomizeQuestions: randomizeQuestions ?? this.randomizeQuestions,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionCount': questionCount,
      'timePerQuestion': timePerQuestion,
      'randomizeQuestions': randomizeQuestions,
      'showCorrectAnswer': showCorrectAnswer,
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      questionCount: json['questionCount'] as int? ?? 10,
      timePerQuestion: json['timePerQuestion'] as int? ?? 30,
      randomizeQuestions: json['randomizeQuestions'] as bool? ?? false,
      showCorrectAnswer: json['showCorrectAnswer'] as bool? ?? false,
      category: json['category'] as String? ?? 'general',
      difficulty: json['difficulty'] as String? ?? 'medium',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSettings &&
          runtimeType == other.runtimeType &&
          questionCount == other.questionCount &&
          timePerQuestion == other.timePerQuestion &&
          randomizeQuestions == other.randomizeQuestions &&
          showCorrectAnswer == other.showCorrectAnswer &&
          category == other.category &&
          difficulty == other.difficulty;

  @override
  int get hashCode => Object.hash(
        questionCount,
        timePerQuestion,
        randomizeQuestions,
        showCorrectAnswer,
        category,
        difficulty,
      );

  @override
  String toString() =>
      'GameSettings(questionCount: $questionCount, timePerQuestion: $timePerQuestion, randomizeQuestions: $randomizeQuestions, showCorrectAnswer: $showCorrectAnswer, category: $category, difficulty: $difficulty)';
}
