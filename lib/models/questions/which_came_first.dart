import 'base_question.dart';
import 'enums.dart';

class ChronologyEvent {
  final String id;
  final String label;
  final DateTime date;
  final String? description;

  const ChronologyEvent({
    required this.id,
    required this.label,
    required this.date,
    this.description,
  });

  ChronologyEvent copyWith({
    String? id,
    String? label,
    DateTime? date,
    String? description,
  }) {
    return ChronologyEvent(
      id: id ?? this.id,
      label: label ?? this.label,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory ChronologyEvent.fromJson(Map<String, dynamic> json) {
    return ChronologyEvent(
      id: json['id'] as String,
      label: json['label'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChronologyEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          date == other.date &&
          description == other.description;

  @override
  int get hashCode => Object.hash(id, label, date, description);
}

class WhichCameFirstQuestion extends BaseQuestion {
  final List<ChronologyEvent> events;
  final int correctFirstIndex;
  final int correctSecondIndex;

  const WhichCameFirstQuestion({
    required super.id,
    required super.category,
    required super.difficulty,
    required super.text,
    required super.explanationFr,
    required super.sourceReference,
    required super.factGroupId,
    required this.events,
    required this.correctFirstIndex,
    required this.correctSecondIndex,
    super.imageUrl,
    super.language,
    super.reviewStatus,
    required super.createdAt,
  }) : super(
          mode: GameMode.whichCameFirst,
          variation: QuestionVariation.whichCameFirst,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode.name,
      'variation': variation.name,
      'category': category.name,
      'difficulty': difficulty.name,
      'text': text,
      'explanationFr': explanationFr,
      'imageUrl': imageUrl,
      'sourceReference': sourceReference,
      'factGroupId': factGroupId,
      'language': language.name,
      'reviewStatus': reviewStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'events': events.map((e) => e.toJson()).toList(),
      'correctFirstIndex': correctFirstIndex,
      'correctSecondIndex': correctSecondIndex,
    };
  }

  factory WhichCameFirstQuestion.fromJson(Map<String, dynamic> json) {
    return WhichCameFirstQuestion(
      id: json['id'] as String,
      category: QuestionCategory.values.byName(json['category'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      text: json['text'] as String,
      explanationFr: json['explanationFr'] as String,
      sourceReference: json['sourceReference'] as String,
      factGroupId: json['factGroupId'] as String,
      imageUrl: json['imageUrl'] as String?,
      language: Language.values.byName(json['language'] as String? ?? 'french'),
      reviewStatus: ContentReviewStatus.values.byName(json['reviewStatus'] as String? ?? 'approved'),
      createdAt: DateTime.parse(json['createdAt'] as String),
      events: (json['events'] as List<dynamic>)
          .map((e) => ChronologyEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctFirstIndex: json['correctFirstIndex'] as int,
      correctSecondIndex: json['correctSecondIndex'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WhichCameFirstQuestion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          mode == other.mode &&
          variation == other.variation &&
          category == other.category &&
          difficulty == other.difficulty &&
          text == other.text &&
          explanationFr == other.explanationFr &&
          imageUrl == other.imageUrl &&
          sourceReference == other.sourceReference &&
          factGroupId == other.factGroupId &&
          language == other.language &&
          reviewStatus == other.reviewStatus &&
          createdAt == other.createdAt &&
          listEqualsByValue(events, other.events) &&
          correctFirstIndex == other.correctFirstIndex &&
          correctSecondIndex == other.correctSecondIndex;

  @override
  int get hashCode => Object.hash(
        id,
        mode,
        variation,
        category,
        difficulty,
        text,
        explanationFr,
        imageUrl,
        sourceReference,
        factGroupId,
        language,
        reviewStatus,
        createdAt,
        listHashCode(events),
        correctFirstIndex,
        correctSecondIndex,
      );
}