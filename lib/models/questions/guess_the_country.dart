import 'base_question.dart';
import 'enums.dart';

class CountryClue {
  final String text;
  final int order;
  final String? imageUrl;

  const CountryClue({
    required this.text,
    required this.order,
    this.imageUrl,
  });

  CountryClue copyWith({
    String? text,
    int? order,
    String? imageUrl,
  }) {
    return CountryClue(
      text: text ?? this.text,
      order: order ?? this.order,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'order': order,
      'imageUrl': imageUrl,
    };
  }

  factory CountryClue.fromJson(Map<String, dynamic> json) {
    return CountryClue(
      text: json['text'] as String,
      order: json['order'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryClue &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          order == other.order &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => Object.hash(text, order, imageUrl);
}

class GuessTheCountryQuestion extends BaseQuestion {
  final String targetCountry;
  final String targetCountryCode;
  final List<String> acceptedAnswers;
  final List<CountryClue> clues;
  final String? flagImageUrl;
  final String? silhouetteImageUrl;
  final String capital;
  final String continent;

  GuessTheCountryQuestion({
    required super.id,
    required super.category,
    required super.difficulty,
    required super.text,
    required super.explanationFr,
    required super.sourceReference,
    required super.factGroupId,
    required this.targetCountry,
    required this.targetCountryCode,
    required this.acceptedAnswers,
    required this.clues,
    required this.capital,
    required this.continent,
    this.flagImageUrl,
    this.silhouetteImageUrl,
    super.imageUrl,
    super.language,
    super.reviewStatus,
    required super.createdAt,
  }) : super(
          mode: GameMode.guessTheCountry,
          variation: _determineVariation(clues, flagImageUrl, silhouetteImageUrl),
        );

  static QuestionVariation _determineVariation(
    List<CountryClue> clues,
    String? flagImageUrl,
    String? silhouetteImageUrl,
  ) {
    if (silhouetteImageUrl != null) return QuestionVariation.guessTheCountrySilhouette;
    if (flagImageUrl != null) return QuestionVariation.guessTheCountryFlag;
    if (clues.any((c) => c.text.toLowerCase().contains('capitale') || c.text.toLowerCase().contains('capital'))) {
      return QuestionVariation.guessTheCountryCapital;
    }
    return QuestionVariation.guessTheCountryProgressive;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'guessTheCountry',
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
      'targetCountry': targetCountry,
      'targetCountryCode': targetCountryCode,
      'acceptedAnswers': acceptedAnswers,
      'clues': clues.map((c) => c.toJson()).toList(),
      'flagImageUrl': flagImageUrl,
      'silhouetteImageUrl': silhouetteImageUrl,
      'capital': capital,
      'continent': continent,
    };
  }

  factory GuessTheCountryQuestion.fromJson(Map<String, dynamic> json) {
    return GuessTheCountryQuestion(
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
      targetCountry: json['targetCountry'] as String,
      targetCountryCode: json['targetCountryCode'] as String,
      acceptedAnswers: (json['acceptedAnswers'] as List<dynamic>).map((e) => e as String).toList(),
      clues: (json['clues'] as List<dynamic>)
          .map((c) => CountryClue.fromJson(c as Map<String, dynamic>))
          .toList(),
      flagImageUrl: json['flagImageUrl'] as String?,
      silhouetteImageUrl: json['silhouetteImageUrl'] as String?,
      capital: json['capital'] as String,
      continent: json['continent'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuessTheCountryQuestion &&
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
          targetCountry == other.targetCountry &&
          targetCountryCode == other.targetCountryCode &&
          listEqualsByValue(acceptedAnswers, other.acceptedAnswers) &&
          listEqualsByValue(clues, other.clues) &&
          flagImageUrl == other.flagImageUrl &&
          silhouetteImageUrl == other.silhouetteImageUrl &&
          capital == other.capital &&
          continent == other.continent;

  @override
  int get hashCode => Object.hashAll([
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
        targetCountry,
        targetCountryCode,
        listHashCode(acceptedAnswers),
        listHashCode(clues),
        flagImageUrl,
        silhouetteImageUrl,
        capital,
        continent,
      ]);
}