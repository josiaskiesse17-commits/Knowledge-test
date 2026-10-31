import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/repositories/question_repository.dart';
import 'package:knowledge_test/services/solo_rules.dart';
import 'package:knowledge_test/services/storage_service.dart';

/// Solo game session controller.
///
/// Owns the running [SoloSession] and persists it: after every answer the
/// in-progress session is saved; on completion the session and its per-question
/// records are saved and the in-progress slot is cleared. When storage is
/// unreachable, the game still works without saving anything.
class SoloController extends StateNotifier<SoloSession> {
  SoloController(this._repository, this._storageLoader)
    : super(
        SoloSession(config: const SoloConfig(), status: GameStatus.pending),
      );

  final QuestionRepository _repository;
  final Future<StorageService?> Function() _storageLoader;

  /// Starts a solo session from [config].
  ///
  /// Returns the validation errors of the draft, empty when the session is
  /// ready to be played. Recent question ids come from the stored solo history
  /// so previously played questions are deferred.
  Future<List<String>> start(SoloConfig config) async {
    final errors = config.validate();
    final recent = await _recentQuestionIds();
    state = SoloRules.buildSession(
      config: config,
      allQuestions: _repository.getAllQuestions(),
      recentQuestionIds: recent,
    );
    await _saveInProgress(state);
    return errors;
  }

  /// Records [userAnswer] for the current question, advances to the next one,
  /// and persists the result. Completes the session after the last question.
  Future<void> answer(String userAnswer) async {
    if (state.isCompleted) return;
    final question = state.currentQuestion;
    if (question == null) return;
    final next = SoloRules.recordAnswer(state, userAnswer);
    state = next;
    await _saveInProgress(next);
    if (next.isCompleted) {
      await _persistCompleted(next);
      await clearInProgress();
    }
  }

  /// Abandons the in-progress session: nothing is stored as completed.
  Future<void> abandon() async {
    await clearInProgress();
    state = state.copyWith(status: GameStatus.cancelled);
  }

  /// Resumes the stored in-progress session, if any.
  Future<void> resume() async {
    final storage = await _storageLoader();
    if (storage == null) return;
    final saved = await storage.getSoloInProgress();
    if (saved != null) {
      state = saved;
    }
  }

  /// Whether a session is currently in progress.
  bool get hasInProgress => state.status == GameStatus.inProgress;

  Future<List<String>> _recentQuestionIds() async {
    final storage = await _storageLoader();
    if (storage == null) return <String>[];
    final history = await storage.getSoloQuestionHistory();
    return history.map((r) => r.questionId).toList();
  }

  Future<void> _saveInProgress(SoloSession session) async {
    final storage = await _storageLoader();
    if (storage == null) return;
    await storage.saveSoloInProgress(session);
  }

  Future<void> _persistCompleted(SoloSession session) async {
    final storage = await _storageLoader();
    if (storage == null) return;
    final completed = session.copyWith(
      id: session.id.isEmpty ? _sessionId(session) : session.id,
      completedAt: DateTime.now(),
    );
    await storage.saveSoloSession(completed);
    final questionsById = {for (final q in session.questions) q.id: q};
    for (final answer in session.answers) {
      final question = questionsById[answer.questionId];
      if (question == null) continue;
      await storage.saveSoloQuestionHistory(
        SoloQuestionRecord(
          questionId: answer.questionId,
          mode: question.mode,
          category: question.category,
          difficulty: question.difficulty,
          correct: answer.isCorrect,
          userAnswer: answer.userAnswer,
          correctAnswer: SoloRules.checkAnswer(
            question,
            answer.userAnswer,
          ).canonicalAnswer,
          answeredAt: answer.answeredAt,
        ),
      );
    }
  }

  Future<void> clearInProgress() async {
    final storage = await _storageLoader();
    if (storage == null) return;
    await storage.clearSoloInProgress();
  }

  static String _sessionId(SoloSession session) {
    final identity = [
      for (final question in session.questions) question.id,
      session.score.toString(),
    ].join('|');
    return 'solo_${_stableHash(identity)}';
  }

  static String _stableHash(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(36);
  }
}

/// Stored completed solo sessions, most recent first.
///
/// Loads automatically; returns an empty list when storage is unreachable.
final soloSessionsProvider = FutureProvider<List<SoloSession>>((ref) async {
  try {
    final storage = await ref.read(storageServiceProvider.future);
    return await storage.getSoloSessions();
  } catch (_) {
    return const <SoloSession>[];
  }
});

/// The unfinished solo session, or null when none is stored.
final soloInProgressProvider = FutureProvider<SoloSession?>((ref) async {
  try {
    final storage = await ref.read(storageServiceProvider.future);
    return await storage.getSoloInProgress();
  } catch (_) {
    return null;
  }
});

/// Number of in-progress solo sessions (0 or 1).
final soloInProgressCountProvider = Provider<int>((ref) {
  final session = ref.watch(soloInProgressProvider).valueOrNull;
  return session == null ? 0 : 1;
});

/// Creates a [SoloController] wired to the question repository and storage.
final soloControllerProvider =
    StateNotifierProvider<SoloController, SoloSession>((ref) {
      final repository = ref.watch(questionRepositoryProvider);
      return SoloController(repository, () async {
        try {
          return await ref.read(storageServiceProvider.future);
        } catch (_) {
          return null;
        }
      });
    });
