/// A multiple-choice question of the stored session records.
///
/// The questions played in a session come from the library models
/// (`BaseQuestion` and its subclasses); this is the flat form stored with a
/// session record.
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
