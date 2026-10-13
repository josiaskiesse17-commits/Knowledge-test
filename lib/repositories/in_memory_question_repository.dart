import 'package:knowledge_test/data/sample_question_bank.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/repositories/question_repository.dart';

/// In-memory [QuestionRepository] backed by [questions].
///
/// Works offline and needs no Firebase. When a persistent question library is
/// added later, the same interface can be implemented by another class without
/// touching the callers.
class InMemoryQuestionRepository implements QuestionRepository {
  final List<BaseQuestion> _questions;
  late final Map<GameMode, List<BaseQuestion>> _byMode;
  late final Map<QuestionCategory, List<BaseQuestion>> _byCategory;
  late final Map<Difficulty, List<BaseQuestion>> _byDifficulty;
  late final Map<String, List<BaseQuestion>> _byFactGroupId;

  InMemoryQuestionRepository(this._questions) {
    _byMode = {};
    for (final question in _questions) {
      _byMode.putIfAbsent(question.mode, () => []).add(question);
    }

    _byCategory = {};
    for (final question in _questions) {
      _byCategory.putIfAbsent(question.category, () => []).add(question);
    }

    _byDifficulty = {};
    for (final question in _questions) {
      _byDifficulty.putIfAbsent(question.difficulty, () => []).add(question);
    }

    _byFactGroupId = {};
    for (final question in _questions) {
      _byFactGroupId.putIfAbsent(question.factGroupId, () => []).add(question);
    }
  }

  @override
  List<BaseQuestion> getAllQuestions() => List.unmodifiable(_questions);

  @override
  List<BaseQuestion> getQuestionsByMode(GameMode mode) =>
      List.unmodifiable(_byMode[mode] ?? const []);

  @override
  List<BaseQuestion> getQuestionsByCategory(QuestionCategory category) =>
      List.unmodifiable(_byCategory[category] ?? const []);

  @override
  List<BaseQuestion> getQuestionsByDifficulty(Difficulty difficulty) =>
      List.unmodifiable(_byDifficulty[difficulty] ?? const []);

  @override
  BaseQuestion? getQuestionById(String id) {
    for (final question in _questions) {
      if (question.id == id) return question;
    }
    return null;
  }

  @override
  List<String> getAllFactGroupIds() => List.unmodifiable(_byFactGroupId.keys);

  @override
  List<BaseQuestion> getQuestionsByFactGroupId(String factGroupId) =>
      List.unmodifiable(_byFactGroupId[factGroupId] ?? const []);
}

/// Shared sample-bank repository instance for the app.
final QuestionRepository sampleQuestionRepository =
    InMemoryQuestionRepository(SampleQuestionBank.questions);