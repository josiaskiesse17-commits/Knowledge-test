import 'base_question.dart';
import 'enums.dart';

class OrderableItem {
  final String id;
  final String label;
  final String? description;
  final double referenceValue;
  final String? unit;

  const OrderableItem({
    required this.id,
    required this.label,
    this.description,
    required this.referenceValue,
    this.unit,
  });

  OrderableItem copyWith({
    String? id,
    String? label,
    String? description,
    double? referenceValue,
    String? unit,
  }) {
    return OrderableItem(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      referenceValue: referenceValue ?? this.referenceValue,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'referenceValue': referenceValue,
      'unit': unit,
    };
  }

  factory OrderableItem.fromJson(Map<String, dynamic> json) {
    return OrderableItem(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
      referenceValue: (json['referenceValue'] as num).toDouble(),
      unit: json['unit'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderableItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          description == other.description &&
          referenceValue == other.referenceValue &&
          unit == other.unit;

  @override
  int get hashCode => Object.hash(id, label, description, referenceValue, unit);
}

class PutInOrderQuestion extends BaseQuestion {
  final List<OrderableItem> items;
  final List<String> correctOrderIds;

  PutInOrderQuestion({
    required super.id,
    required super.category,
    required super.difficulty,
    required super.text,
    required super.explanationFr,
    required super.sourceReference,
    required super.factGroupId,
    required this.items,
    required this.correctOrderIds,
    super.imageUrl,
    super.language,
    super.reviewStatus,
    required super.createdAt,
  }) : super(
          mode: GameMode.putInOrder,
          variation: _determineVariation(items),
        );

  static QuestionVariation _determineVariation(List<OrderableItem> items) {
    final hasDates = items.any((item) => item.unit?.toLowerCase() == 'date' || 
        item.unit?.toLowerCase() == 'year' ||
        item.unit?.toLowerCase() == 'année');
    return hasDates 
        ? QuestionVariation.putInOrderChronological 
        : QuestionVariation.putInOrderByProperty;
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
      'items': items.map((i) => i.toJson()).toList(),
      'correctOrderIds': correctOrderIds,
    };
  }

  factory PutInOrderQuestion.fromJson(Map<String, dynamic> json) {
    return PutInOrderQuestion(
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
      items: (json['items'] as List<dynamic>)
          .map((i) => OrderableItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      correctOrderIds: (json['correctOrderIds'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PutInOrderQuestion &&
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
          listEqualsByValue(items, other.items) &&
          listEqualsByValue(correctOrderIds, other.correctOrderIds);

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
        listHashCode(items),
        listHashCode(correctOrderIds),
      );
}