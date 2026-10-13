import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/services/game_engine.dart';
import 'package:knowledge_test/services/session_history_service.dart';
import 'package:knowledge_test/services/storage_service.dart';

/// Local storage, created from SharedPreferences.
final storageServiceProvider = FutureProvider<StorageService>((ref) {
  return StorageService.create();
});

/// Store used by the session history.
///
/// Null when no local storage is reachable (tests, platform without
/// initialization): the game keeps working, it simply saves nothing.
final sessionStoreProvider = FutureProvider<SessionStore?>((ref) async {
  try {
    final storage = await ref.watch(storageServiceProvider.future);
    return StorageSessionStore(storage);
  } catch (_) {
    return null;
  }
});

/// State of the saved sessions.
class SessionHistoryState {
  final List<GameSession> sessions;
  final bool isLoading;
  final bool loadFailed;

  const SessionHistoryState({
    this.sessions = const [],
    this.isLoading = false,
    this.loadFailed = false,
  });

  bool get isEmpty => sessions.isEmpty;

  SessionHistoryState copyWith({
    List<GameSession>? sessions,
    bool? isLoading,
    bool? loadFailed,
  }) {
    return SessionHistoryState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      loadFailed: loadFailed ?? this.loadFailed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionHistoryState &&
          runtimeType == other.runtimeType &&
          _listEquals(sessions, other.sessions) &&
          isLoading == other.isLoading &&
          loadFailed == other.loadFailed;

  @override
  int get hashCode => Object.hash(
        sessions.length,
        sessions.isEmpty ? null : sessions.first,
        isLoading,
        loadFailed,
      );
}

/// Owns the local session history: loading, saving a finished session exactly
/// once, and the list of recently played questions.
///
/// Storage calls are wrapped so a failing or missing store can never interrupt
/// the game: a failed save is retryable and a failed load shows an empty
/// history instead of crashing.
class SessionHistoryNotifier extends StateNotifier<SessionHistoryState> {
  SessionHistoryNotifier(this._storeLoader)
      : super(const SessionHistoryState());

  final Future<SessionStore?> Function() _storeLoader;

  /// Ids already written (or being written) during this session of the app, so
  /// a session completed while navigating is never saved twice.
  final Set<String> _savedSessionIds = <String>{};

  /// Loads the stored sessions. Safe to call more than once.
  Future<void> load() async {
    final store = await _storeLoader();
    if (store == null) {
      state = state.copyWith(isLoading: false, loadFailed: true);
      return;
    }

    if (state.isEmpty) state = state.copyWith(isLoading: true);

    try {
      final sessions = await store.loadSessions();
      state = SessionHistoryState(sessions: sessions);
    } catch (_) {
      state = state.copyWith(isLoading: false, loadFailed: true);
    }
  }

  /// Saves [state] as a completed session, at most once per session.
  ///
  /// Cancelled, abandoned and running sessions are never recorded. Calls made
  /// close together (completion and navigation to the final ranking) result in
  /// a single write, and a storage failure leaves the session retryable.
  Future<void> persistCompleted(GameState state) async {
    if (!state.isCompleted) return;

    final record = SessionHistoryService.recordOf(state);
    if (!_savedSessionIds.add(record.id)) return;

    final store = await _storeLoader();
    if (store == null) return;

    try {
      await store.saveOnce(record);
      await store.trimTo(kMaxStoredSessions);
      await load();
    } catch (_) {
      // The session was not stored: allow a later attempt to write it again.
      _savedSessionIds.remove(record.id);
    }
  }

  /// Question ids of the recent sessions, most recent first.
  ///
  /// Passed to the game engine when a new session is built so the questions of
  /// the previous sessions are played again last.
  List<String> get recentQuestionIds =>
      SessionHistoryService.recentQuestionIdsOf(state.sessions);

  Future<void> deleteSession(String sessionId) async {
    final store = await _storeLoader();
    if (store == null) return;
    try {
      await store.deleteSession(sessionId);
      await load();
    } catch (_) {
      // Deleting is best effort: the in-memory state stays consistent with the
      // last successful load.
    }
  }

  Future<void> clearHistory() async {
    final store = await _storeLoader();
    if (store == null) return;
    try {
      await store.clearSessions();
      state = const SessionHistoryState();
    } catch (_) {
      // Best effort, as above.
    }
  }
}

/// Session history shown on the history screen.
final sessionHistoryProvider =
    StateNotifierProvider<SessionHistoryNotifier, SessionHistoryState>((ref) {
  return SessionHistoryNotifier(() => ref.read(sessionStoreProvider.future));
});

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
