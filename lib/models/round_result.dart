import 'package:knowledge_test/models/json_parsing.dart';
import 'package:knowledge_test/models/player_answer.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';

/// Outcome of one question inside a stored session.
class RoundResult {
  final int roundNumber;
  final String questionId;
  final String questionText;
  final List<PlayerAnswer> answers;
  final String correctAnswer;
  final DateTime answeredAt;

  /// How the round ended. Stored so skipped and invalidated questions stay
  /// distinguishable in the history; older entries that predate the field are
  /// treated as pending.
  final QuestionOutcome outcome;

  /// Players who earned the point for this question, so the history can show
  /// who scored without re-reading the question. Older entries that predate the
  /// field are treated as unanswered.
  final Set<String> awardedPlayerIds;

  const RoundResult({
    required this.roundNumber,
    required this.questionId,
    required this.questionText,
    required this.answers,
    required this.correctAnswer,
    required this.answeredAt,
    this.outcome = QuestionOutcome.pending,
    this.awardedPlayerIds = const {},
  });

  RoundResult copyWith({
    int? roundNumber,
    String? questionId,
    String? questionText,
    List<PlayerAnswer>? answers,
    String? correctAnswer,
    DateTime? answeredAt,
    QuestionOutcome? outcome,
    Set<String>? awardedPlayerIds,
  }) {
    return RoundResult(
      roundNumber: roundNumber ?? this.roundNumber,
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      answeredAt: answeredAt ?? this.answeredAt,
      outcome: outcome ?? this.outcome,
      awardedPlayerIds: awardedPlayerIds ?? this.awardedPlayerIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'questionId': questionId,
      'questionText': questionText,
      'answers': answers.map((a) => a.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'answeredAt': answeredAt.toIso8601String(),
      'outcome': outcome.name,
      'awardedPlayerIds': awardedPlayerIds.toList(),
    };
  }

  factory RoundResult.fromJson(Map<String, dynamic> json) {
    return RoundResult(
      roundNumber: json['roundNumber'] as int? ?? 0,
      questionId: json['questionId'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      answers: (json['answers'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(PlayerAnswer.fromJson)
          .toList(),
      correctAnswer: json['correctAnswer'] as String? ?? '',
      answeredAt: parseDateOrNull(json['answeredAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      outcome:
          enumByNameOrNull(QuestionOutcome.values, json['outcome']) ?? QuestionOutcome.pending,
      awardedPlayerIds: {
        for (final id in (json['awardedPlayerIds'] as List<dynamic>? ?? const [])
            .whereType<String>())
          id,
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundResult &&
          runtimeType == other.runtimeType &&
          roundNumber == other.roundNumber &&
          questionId == other.questionId &&
          questionText == other.questionText &&
          listEqualsByValue(answers, other.answers) &&
          correctAnswer == other.correctAnswer &&
          answeredAt == other.answeredAt &&
          outcome == other.outcome &&
          setEqualsByValue(awardedPlayerIds, other.awardedPlayerIds);

  @override
  int get hashCode => Object.hash(
        roundNumber,
        questionId,
        questionText,
        listHashCode(answers),
        correctAnswer,
        answeredAt,
        outcome,
        setHashCode(awardedPlayerIds),
      );

  @override
  String toString() =>
      'RoundResult(roundNumber: $roundNumber, questionId: $questionId, questionText: $questionText, answers: $answers, correctAnswer: $correctAnswer, answeredAt: $answeredAt, outcome: ${outcome.name})';
}
