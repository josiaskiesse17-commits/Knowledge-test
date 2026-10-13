import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/services/game_engine.dart';
import 'package:knowledge_test/services/storage_service.dart';

/// Maximum number of sessions kept in the local history.
const int kMaxStoredSessions = 100;

/// Default number of recent sessions inspected to avoid repeating questions.
const int kDefaultRecentSessions = 20;

/// Default cap on the number of question ids remembered across sessions.
const int kDefaultRecentQuestionIds = 200;

/// Translates between the running session and the stored [GameSession].
///
/// The mapping is pure so it can be unit tested without Flutter or storage.
class SessionHistoryService {
  const SessionHistoryService._();

  /// Builds the storable record of a finished session.
  ///
  /// The question bank ships with the app, so only the question ids, the
  /// outcomes and the awarded players are stored: duplicating the question text
  /// or the answer structures would grow the history without adding anything.
  /// The text is resolved from the repository when the history is displayed.
  static GameSession recordOf(GameState state, {DateTime? now}) {
    final completedAt = state.completedAt ?? now ?? DateTime.now();
    final rounds = <RoundResult>[];
    for (var i = 0; i < state.rounds.length; i++) {
      final round = state.rounds[i];
      rounds.add(
        RoundResult(
          roundNumber: i + 1,
          questionId: round.questionId,
          questionText: '',
          answers: const [],
          correctAnswer: '',
          answeredAt: completedAt,
          outcome: round.outcome,
          awardedPlayerIds: Set<String>.from(round.awardedPlayerIds),
        ),
      );
    }

    return GameSession(
      id: sessionIdOf(state, completedAt: completedAt),
      createdAt: state.startedAt ?? completedAt,
      players: state.players,
      settings: state.config.toGameSettings(),
      rounds: rounds,
      status: GameStatus.completed,
      completedAt: completedAt,
    );
  }

  /// Deterministic id of a finished session.
  ///
  /// The same session always produces the same id, so saving it again (for
  /// instance when the app navigates to the final ranking right after the
  /// session was completed) updates nothing instead of adding a duplicate.
  static String sessionIdOf(GameState state, {required DateTime completedAt}) {
    final identity = [
      state.startedAt?.toIso8601String() ?? 'unstarted',
      for (final question in state.questions) question.id,
    ].join('|');
    return 's_${_stableHash('$identity|${completedAt.toIso8601String()}')}';
  }

  /// Question ids of the stored sessions, most recently played first.
  ///
  /// [sessions] may come from storage in any order; the result is ordered from
  /// the newest session to the oldest, and from the last question played to the
  /// first inside each session, so index 0 is the most recent question.
  static List<String> recentQuestionIdsOf(
    List<GameSession> sessions, {
    int maxSessions = kDefaultRecentSessions,
    int maxIds = kDefaultRecentQuestionIds,
  }) {
    final ordered = [...sessions]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final ids = <String>[];
    final limit = maxSessions <= 0 ? ordered.length : maxSessions;

    for (final session in ordered.take(limit)) {
      // The last question of a session is the most recently played one.
      for (final round in session.rounds.reversed) {
        if (round.questionId.isEmpty) continue;
        if (ids.contains(round.questionId)) continue;
        ids.add(round.questionId);
        if (ids.length >= maxIds) return ids;
      }
    }
    return ids;
  }

  /// Formats a stored date as dd/MM/yyyy HH:mm.
  static String formatSessionDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} ${two(date.hour)}:${two(date.minute)}';
  }

  /// Short 32-bit FNV-1a hash, so ids are stable across app runs.
  static String _stableHash(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(36);
  }
}

/// Storage operations needed by the session history.
///
/// Kept as an interface so the history logic can be tested without
/// SharedPreferences, and so another storage backend can replace
/// [StorageSessionStore] later.
abstract class SessionStore {
  /// Stores [session] unless its id is already present; true when written.
  Future<bool> saveOnce(GameSession session);

  Future<List<GameSession>> loadSessions();

  Future<void> trimTo(int maxSessions);

  Future<void> deleteSession(String sessionId);

  Future<void> clearSessions();
}

/// [SessionStore] backed by the existing [StorageService] and SharedPreferences.
class StorageSessionStore implements SessionStore {
  const StorageSessionStore(this._storage);

  final StorageService _storage;

  @override
  Future<bool> saveOnce(GameSession session) => _storage.saveSessionOnce(session);

  @override
  Future<List<GameSession>> loadSessions() => _storage.getSessions();

  @override
  Future<void> trimTo(int maxSessions) => _storage.trimHistory(maxSessions);

  @override
  Future<void> deleteSession(String sessionId) =>
      _storage.deleteSession(sessionId);

  @override
  Future<void> clearSessions() => _storage.clearAllSessions();
}
