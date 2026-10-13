class Player {
  final String id;
  final String name;
  final int score;
  final bool isActive;

  const Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.isActive = false,
  });

  Player copyWith({
    String? id,
    String? name,
    int? score,
    bool? isActive,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'isActive': isActive,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      score: json['score'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          score == other.score &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(id, name, score, isActive);

  @override
  String toString() => 'Player(id: $id, name: $name, score: $score, isActive: $isActive)';
}

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

class GameSession {
  final String id;
  final DateTime createdAt;
  final List<Player> players;
  final GameSettings settings;
  final List<RoundResult> rounds;
  final GameStatus status;
  final DateTime? completedAt;

  const GameSession({
    required this.id,
    required this.createdAt,
    required this.players,
    required this.settings,
    this.rounds = const [],
    this.status = GameStatus.pending,
    this.completedAt,
  });

  GameSession copyWith({
    String? id,
    DateTime? createdAt,
    List<Player>? players,
    GameSettings? settings,
    List<RoundResult>? rounds,
    GameStatus? status,
    DateTime? completedAt,
  }) {
    return GameSession(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      players: players ?? this.players,
      settings: settings ?? this.settings,
      rounds: rounds ?? this.rounds,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'players': players.map((p) => p.toJson()).toList(),
      'settings': settings.toJson(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'status': status.name,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      players: (json['players'] as List<dynamic>)
          .map((p) => Player.fromJson(p as Map<String, dynamic>))
          .toList(),
      settings: GameSettings.fromJson(json['settings'] as Map<String, dynamic>),
      rounds: (json['rounds'] as List<dynamic>? ?? [])
          .map((r) => RoundResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      status: GameStatus.values.byName(json['status'] as String? ?? 'pending'),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt &&
          players == other.players &&
          settings == other.settings &&
          rounds == other.rounds &&
          status == other.status &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hash(
        id,
        createdAt,
        players,
        settings,
        rounds,
        status,
        completedAt,
      );

  @override
  String toString() =>
      'GameSession(id: $id, createdAt: $createdAt, players: $players, settings: $settings, rounds: $rounds, status: $status, completedAt: $completedAt)';
}

class RoundResult {
  final int roundNumber;
  final String questionId;
  final String questionText;
  final List<PlayerAnswer> answers;
  final String correctAnswer;
  final DateTime answeredAt;

  const RoundResult({
    required this.roundNumber,
    required this.questionId,
    required this.questionText,
    required this.answers,
    required this.correctAnswer,
    required this.answeredAt,
  });

  RoundResult copyWith({
    int? roundNumber,
    String? questionId,
    String? questionText,
    List<PlayerAnswer>? answers,
    String? correctAnswer,
    DateTime? answeredAt,
  }) {
    return RoundResult(
      roundNumber: roundNumber ?? this.roundNumber,
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'questionId': questionId,
      'questionText': questionText,
      'answers': answers.map((a) => a.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  factory RoundResult.fromJson(Map<String, dynamic> json) {
    return RoundResult(
      roundNumber: json['roundNumber'] as int,
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((a) => PlayerAnswer.fromJson(a as Map<String, dynamic>))
          .toList(),
      correctAnswer: json['correctAnswer'] as String,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundResult &&
          runtimeType == other.runtimeType &&
          roundNumber == other.roundNumber &&
          questionId == other.questionId &&
          questionText == other.questionText &&
          answers == other.answers &&
          correctAnswer == other.correctAnswer &&
          answeredAt == other.answeredAt;

  @override
  int get hashCode => Object.hash(
        roundNumber,
        questionId,
        questionText,
        answers,
        correctAnswer,
        answeredAt,
      );

  @override
  String toString() =>
      'RoundResult(roundNumber: $roundNumber, questionId: $questionId, questionText: $questionText, answers: $answers, correctAnswer: $correctAnswer, answeredAt: $answeredAt)';
}

class PlayerAnswer {
  final String playerId;
  final String playerName;
  final String answer;
  final bool isCorrect;
  final int pointsEarned;
  final int responseTimeMs;

  const PlayerAnswer({
    required this.playerId,
    required this.playerName,
    required this.answer,
    required this.isCorrect,
    required this.pointsEarned,
    required this.responseTimeMs,
  });

  PlayerAnswer copyWith({
    String? playerId,
    String? playerName,
    String? answer,
    bool? isCorrect,
    int? pointsEarned,
    int? responseTimeMs,
  }) {
    return PlayerAnswer(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'answer': answer,
      'isCorrect': isCorrect,
      'pointsEarned': pointsEarned,
      'responseTimeMs': responseTimeMs,
    };
  }

  factory PlayerAnswer.fromJson(Map<String, dynamic> json) {
    return PlayerAnswer(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      answer: json['answer'] as String,
      isCorrect: json['isCorrect'] as bool,
      pointsEarned: json['pointsEarned'] as int,
      responseTimeMs: json['responseTimeMs'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAnswer &&
          runtimeType == other.runtimeType &&
          playerId == other.playerId &&
          playerName == other.playerName &&
          answer == other.answer &&
          isCorrect == other.isCorrect &&
          pointsEarned == other.pointsEarned &&
          responseTimeMs == other.responseTimeMs;

  @override
  int get hashCode => Object.hash(
        playerId,
        playerName,
        answer,
        isCorrect,
        pointsEarned,
        responseTimeMs,
      );

  @override
  String toString() =>
      'PlayerAnswer(playerId: $playerId, playerName: $playerName, answer: $answer, isCorrect: $isCorrect, pointsEarned: $pointsEarned, responseTimeMs: $responseTimeMs)';
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String category;
  final String difficulty;
  final String? explanation;
  final String? imageUrl;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.category,
    required this.difficulty,
    this.explanation,
    this.imageUrl,
  });

  Question copyWith({
    String? id,
    String? text,
    List<String>? options,
    int? correctIndex,
    String? category,
    String? difficulty,
    String? explanation,
    String? imageUrl,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      explanation: explanation ?? this.explanation,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctIndex': correctIndex,
      'category': category,
      'difficulty': difficulty,
      'explanation': explanation,
      'imageUrl': imageUrl,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctIndex: json['correctIndex'] as int,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      explanation: json['explanation'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          options == other.options &&
          correctIndex == other.correctIndex &&
          category == other.category &&
          difficulty == other.difficulty &&
          explanation == other.explanation &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => Object.hash(
        id,
        text,
        options,
        correctIndex,
        category,
        difficulty,
        explanation,
        imageUrl,
      );

  @override
  String toString() =>
      'Question(id: $id, text: $text, options: $options, correctIndex: $correctIndex, category: $category, difficulty: $difficulty, explanation: $explanation, imageUrl: $imageUrl)';
}

enum GameStatus {
  pending,
  inProgress,
  paused,
  completed,
  cancelled,
}