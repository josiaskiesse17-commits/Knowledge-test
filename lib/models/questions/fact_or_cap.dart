import 'base_question.dart';
import 'enums.dart';

class FactStatement {
  final String id;
  final String text;
  final bool isTrue;
  final String? explanation;

  const FactStatement({
    required this.id,
    required this.text,
    required this.isTrue,
    this.explanation,
  });

  FactStatement copyWith({
    String? id,
    String? text,
    bool? isTrue,
    String? explanation,
  }) {
    return FactStatement(
      id: id ?? this.id,
      text: text ?? this.text,
      isTrue: isTrue ?? this.isTrue,
      explanation: explanation ?? this.explanation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isTrue': isTrue,
      'explanation': explanation,
    };
  }

  factory FactStatement.fromJson(Map<String, dynamic> json) {
    return FactStatement(
      id: json['id'] as String,
      text: json['text'] as String,
      isTrue: json['isTrue'] as bool,
      explanation: json['explanation'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactStatement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          isTrue == other.isTrue &&
          explanation == other.explanation;

  @override
  int get hashCode => Object.hash(id, text, isTrue, explanation);
}

class FactOrCapQuestion extends BaseQuestion {
  final List<FactStatement> statements;
  final int? falseStatementIndex;
  final int? lieStatementIndex;

  FactOrCapQuestion({
    required super.id,
    required super.category,
    required super.difficulty,
    required super.text,
    required super.explanationFr,
    required super.sourceReference,
    required super.factGroupId,
    required this.statements,
    this.falseStatementIndex,
    this.lieStatementIndex,
    super.imageUrl,
    super.language,
    super.reviewStatus,
    required super.createdAt,
  }) : super(
          mode: GameMode.factOrCap,
          variation: _determineVariation(statements, falseStatementIndex, lieStatementIndex),
        );

  static QuestionVariation _determineVariation(
    List<FactStatement> statements,
    int? falseStatementIndex,
    int? lieStatementIndex,
  ) {
    if (lieStatementIndex != null) {
      return QuestionVariation.factOrCapTwoTruthsOneLie;
    }
    if (falseStatementIndex != null) {
      return QuestionVariation.factOrCapIdentifyFalse;
    }
    return QuestionVariation.factOrCapTrueFalse;
  }

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
      'statements': statements.map((s) => s.toJson()).toList(),
      'falseStatementIndex': falseStatementIndex,
      'lieStatementIndex': lieStatementIndex,
    };
  }

  factory FactOrCapQuestion.fromJson(Map<String, dynamic> json) {
    return FactOrCapQuestion(
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
      statements: (json['statements'] as List<dynamic>)
          .map((s) => FactStatement.fromJson(s as Map<String, dynamic>))
          .toList(),
      falseStatementIndex: json['falseStatementIndex'] as int?,
      lieStatementIndex: json['lieStatementIndex'] as int?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactOrCapQuestion &&
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
          listEqualsByValue(statements, other.statements) &&
          falseStatementIndex == other.falseStatementIndex &&
          lieStatementIndex == other.lieStatementIndex;

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
        listHashCode(statements),
        falseStatementIndex,
        lieStatementIndex,
      );
}