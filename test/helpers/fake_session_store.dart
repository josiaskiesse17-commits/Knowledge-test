import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/services/session_history_service.dart';

/// In-memory [SessionStore] used by tests.
///
/// It can be told to fail, so the resilience of the session history can be
/// tested without touching SharedPreferences.
class FakeSessionStore implements SessionStore {
  final List<GameSession> stored = [];
  int saveCalls = 0;
  int trimCalls = 0;
  bool failSave = false;
  bool failLoad = false;

  @override
  Future<bool> saveOnce(GameSession session) async {
    saveCalls++;
    if (failSave) throw StateError('storage unavailable');
    if (stored.any((s) => s.id == session.id)) return false;
    stored.add(session);
    return true;
  }

  @override
  Future<List<GameSession>> loadSessions() async {
    if (failLoad) throw StateError('storage unreadable');
    final ordered = [...stored]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return ordered;
  }

  @override
  Future<void> trimTo(int maxSessions) async {
    trimCalls = maxSessions;
    if (stored.length <= maxSessions) return;
    final ordered = [...stored]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    stored
      ..clear()
      ..addAll(ordered.sublist(0, maxSessions));
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    stored.removeWhere((s) => s.id == sessionId);
  }

  @override
  Future<void> clearSessions() async {
    stored.clear();
  }
}
