import 'base_question.dart';
import 'enums.dart';

class EstimationAnswer {
  final double referenceValue;
  final String unit;
  final String? unitFr;
  final double? acceptedMin;
  final double? acceptedMax;
  final String scoringRuleId;
  final int? significantFigures;

  const EstimationAnswer({
    required this.referenceValue,
    required this.unit,
    this.unitFr,
    this.acceptedMin,
    this.acceptedMax,
    required this.scoringRuleId,
    this.significantFigures,
  });

  EstimationAnswer copyWith({
    double? referenceValue,
    String? unit,
    String? unitFr,
    double? acceptedMin,
    double? acceptedMax,
    String? scoringRuleId,
    int? significantFigures,
  }) {
    return EstimationAnswer(
      referenceValue: referenceValue ?? this.referenceValue,
      unit: unit ?? this.unit,
      unitFr: unitFr ?? this.unitFr,
      acceptedMin: acceptedMin ?? this.acceptedMin,
      acceptedMax: acceptedMax ?? this.acceptedMax,
      scoringRuleId: scoringRuleId ?? this.scoringRuleId,
      significantFigures: significantFigures ?? this.significantFigures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceValue': referenceValue,
      'unit': unit,
      'unitFr': unitFr,
      'acceptedMin': acceptedMin,
      'acceptedMax': acceptedMax,
      'scoringRuleId': scoringRuleId,
      'significantFigures': significantFigures,
    };
  }

  factory EstimationAnswer.fromJson(Map<String, dynamic> json) {
    return EstimationAnswer(
      referenceValue: (json['referenceValue'] as num).toDouble(),
      unit: json['unit'] as String,
      unitFr: json['unitFr'] as String?,
      acceptedMin: json['acceptedMin'] != null ? (json['acceptedMin'] as num).toDouble() : null,
      acceptedMax: json['acceptedMax'] != null ? (json['acceptedMax'] as num).toDouble() : null,
      scoringRuleId: json['scoringRuleId'] as String,
      significantFigures: json['significantFigures'] as int?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstimationAnswer &&
          runtimeType == other.runtimeType &&
          referenceValue == other.referenceValue &&
          unit == other.unit &&
          unitFr == other.unitFr &&
          acceptedMin == other.acceptedMin &&
          acceptedMax == other.acceptedMax &&
          scoringRuleId == other.scoringRuleId &&
          significantFigures == other.significantFigures;

  @override
  int get hashCode => Object.hash(
        referenceValue,
        unit,
        unitFr,
        acceptedMin,
        acceptedMax,
        scoringRuleId,
        significantFigures,
      );
}

class HowMuchQuestion extends BaseQuestion {
  final EstimationAnswer answer;

  HowMuchQuestion({
    required super.id,
    required super.category,
    required super.difficulty,
    required super.text,
    required super.explanationFr,
    required super.sourceReference,
    required super.factGroupId,
    required this.answer,
    super.imageUrl,
    super.language,
    super.reviewStatus,
    required super.createdAt,
  }) : super(
          mode: GameMode.howMuch,
          variation: _determineVariation(answer),
        );

  static QuestionVariation _determineVariation(EstimationAnswer answer) {
    final unit = answer.unit.toLowerCase();
    final unitFr = answer.unitFr?.toLowerCase() ?? '';
    
    if (unit.contains('date') || unit.contains('year') || unit.contains('année') || 
        unitFr.contains('date') || unitFr.contains('année')) {
      return QuestionVariation.howMuchDate;
    }
    if (unit.contains('km') || unit.contains('distance') || unit.contains('mètre') ||
        unitFr.contains('km') || unitFr.contains('distance') || unitFr.contains('mètre')) {
      return QuestionVariation.howMuchDistance;
    }
    if (unit.contains('population') || unit.contains('habitant') || unitFr.contains('population') || unitFr.contains('habitant')) {
      return QuestionVariation.howMuchPopulation;
    }
    return QuestionVariation.howMuchQuantity;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'howMuch',
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
      'answer': answer.toJson(),
    };
  }

  factory HowMuchQuestion.fromJson(Map<String, dynamic> json) {
    return HowMuchQuestion(
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
      answer: EstimationAnswer.fromJson(json['answer'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HowMuchQuestion &&
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
          answer == other.answer;

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
        answer,
      );
}