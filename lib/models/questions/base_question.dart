import 'package:knowledge_test/models/json_parsing.dart';
import 'enums.dart';
import 'fact_or_cap.dart';
import 'guess_the_country.dart';
import 'how_much.dart';
import 'put_in_order.dart';
import 'which_came_first.dart';

/// Shared metadata for every question, whatever the game mode.
///
/// Mode-specific answer data lives in the subclasses, so that each mode keeps a
/// structure that actually matches the way it is played.
abstract class BaseQuestion {
  final String id;
  final GameMode mode;
  final QuestionVariation variation;
  final QuestionCategory category;
  final Difficulty difficulty;
  final String text;
  final String explanationFr;
  final String? imageUrl;
  final String sourceReference;
  final String factGroupId;
  final Language language;
  final ContentReviewStatus reviewStatus;
  final DateTime createdAt;

  const BaseQuestion({
    required this.id,
    required this.mode,
    required this.variation,
    required this.category,
    required this.difficulty,
    required this.text,
    required this.explanationFr,
    this.imageUrl,
    required this.sourceReference,
    required this.factGroupId,
    this.language = Language.french,
    this.reviewStatus = ContentReviewStatus.approved,
    required this.createdAt,
  });

  Map<String, dynamic> toJson();

  /// Rebuilds a question from its stored [json], using its `type` discriminator.
  ///
  /// [GameMode] is used as a fallback for entries written before the `type`
  /// field existed, so a question bank saved by an older version still loads.
  factory BaseQuestion.fromJson(Map<String, dynamic> json) {
    final type = enumByNameOrNull(QuestionType.values, json['type'] ??
        json['mode'] as String? ??
        GameMode.values.first.name);

    switch (type!) {
      case QuestionType.whichCameFirst:
        return WhichCameFirstQuestion.fromJson(json);
      case QuestionType.guessTheCountry:
        return GuessTheCountryQuestion.fromJson(json);
      case QuestionType.factOrCap:
        return FactOrCapQuestion.fromJson(json);
      case QuestionType.putInOrder:
        return PutInOrderQuestion.fromJson(json);
      case QuestionType.howMuch:
        return HowMuchQuestion.fromJson(json);
    }
  }

  /// True when the question can be played: every subclass validates its own
  /// answer structure and that at least one answer is available.
  bool get isPlayable => text.isNotEmpty && explanationFr.isNotEmpty;

  @override
  String toString() => '$runtimeType(id: $id, mode: ${mode.name}, variation: ${variation.name})';
}

/// Element-wise list comparison, so questions and answer structures compare by
/// value instead of by identity.
bool listEqualsByValue<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Hash code consistent with [listEqualsByValue].
int listHashCode<T>(List<T>? list) => list == null ? 0 : Object.hashAll(list);