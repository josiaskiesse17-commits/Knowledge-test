/// What one player answered for one question, kept with the stored session.
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
      playerId: json['playerId'] as String? ?? '',
      playerName: json['playerName'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      pointsEarned: json['pointsEarned'] as int? ?? 0,
      responseTimeMs: json['responseTimeMs'] as int? ?? 0,
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
