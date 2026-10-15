/// A player of a session, with the score recorded so far.
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
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Joueur',
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
