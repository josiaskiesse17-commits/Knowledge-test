import 'enums.dart';

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