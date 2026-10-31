import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/solo_session.dart';

/// Local, offline-only storage of the finished sessions, settings, and preferences.
///
/// Every read is defensive: a session saved by an older version, or a corrupted
/// entry, is ignored instead of throwing, so a damaged store can never crash
/// the game.
class StorageService {
  static const String _keySessions = 'game_sessions';
  static const String _keySettings = 'game_settings';
  static const String _keyPlayerNames = 'recent_player_names';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLocale = 'app_locale';

  static const String _keySoloSessions = 'solo_sessions';
  static const String _keySoloQuestionHistory = 'solo_question_history';
  static const String _keySoloInProgress = 'solo_in_progress';

  static const int _maxSoloSessions = 100;
  static const int _maxSoloQuestionHistory = 2000;

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveSession(GameSession session) async {
    final sessions = await getSessions();
    sessions.add(session);
    await _saveSessions(sessions);
  }

  /// Saves [session] only when its id is not already stored.
  ///
  /// A session that completes while the app is navigating to the final ranking
  /// can be reported more than once; the id makes the write idempotent so the
  /// history never gains a duplicate entry for the same session.
  Future<bool> saveSessionOnce(GameSession session) async {
    final sessions = await getSessions();
    if (sessions.any((s) => s.id == session.id)) return false;

    sessions.add(session);
    await _saveSessions(sessions);
    return true;
  }

  Future<void> updateSession(GameSession session) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      await _saveSessions(sessions);
    }
  }

  /// Stored sessions, most recent first.
  ///
  /// Entries that cannot be decoded are skipped; the readable ones are still
  /// returned so a single damaged entry never hides the whole history.
  Future<List<GameSession>> getSessions() async {
    final jsonList = _prefs.getStringList(_keySessions) ?? const <String>[];
    final sessions = <GameSession>[];
    for (final json in jsonList) {
      final session = _decodeSession(json);
      if (session != null) sessions.add(session);
    }
    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions;
  }

  Future<void> deleteSession(String sessionId) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    await _saveSessions(sessions);
  }

  Future<void> clearAllSessions() async {
    await _prefs.remove(_keySessions);
  }

  // ---------------------------------------------------------------------------
  // Solo sessions (completed), separate from the quizmaster session history.
  // ---------------------------------------------------------------------------

  /// Saves [session] only when its id is not already stored.
  ///
  /// Idempotent by id: completing the same session again (for instance while
  /// navigating to the summary) writes nothing a second time and returns false.
  Future<bool> saveSoloSession(SoloSession session) async {
    final sessions = await getSoloSessions();
    if (sessions.any((s) => s.id == session.id)) return false;
    sessions.add(session);
    await _saveSoloSessions(sessions);
    return true;
  }

  /// Completed solo sessions, most recent first, capped at [_maxSoloSessions].
  ///
  /// Entries that cannot be decoded are skipped; the readable ones are still
  /// returned so a single damaged entry never hides the whole history.
  Future<List<SoloSession>> getSoloSessions() async {
    final jsonList = _prefs.getStringList(_keySoloSessions) ?? const <String>[];
    final sessions = <SoloSession>[];
    for (final json in jsonList) {
      final session = _decodeSoloSession(json);
      if (session != null) sessions.add(session);
    }
    sessions.sort((a, b) {
      final aTime = a.completedAt?.millisecondsSinceEpoch ?? 0;
      final bTime = b.completedAt?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });
    return sessions.take(_maxSoloSessions).toList();
  }

  Future<void> deleteSoloSession(String sessionId) async {
    final sessions = await getSoloSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    await _saveSoloSessions(sessions);
  }

  Future<void> clearSoloSessions() async {
    await _prefs.remove(_keySoloSessions);
  }

  Future<void> _saveSoloSessions(List<SoloSession> sessions) async {
    sessions.sort((a, b) {
      final aTime = a.completedAt?.millisecondsSinceEpoch ?? 0;
      final bTime = b.completedAt?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });
    sessions = sessions.take(_maxSoloSessions).toList();
    final jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_keySoloSessions, jsonList);
  }

  /// Decodes one stored solo session, returning null when the entry is
  /// unreadable or carries no id.
  static SoloSession? _decodeSoloSession(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) return null;
      final session = SoloSession.fromJson(decoded);
      if (session.id.isEmpty) return null;
      return session;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Solo question history (per-question results), under its own key.
  // ---------------------------------------------------------------------------

  /// Appends [record] to the solo question history, newest first, capped at
  /// [_maxSoloQuestionHistory] records (the oldest are dropped).
  Future<void> saveSoloQuestionHistory(SoloQuestionRecord record) async {
    final history = await getSoloQuestionHistory();
    history.add(record);
    history.sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    if (history.length > _maxSoloQuestionHistory) {
      history.length = _maxSoloQuestionHistory;
    }
    await _prefs.setStringList(
      _keySoloQuestionHistory,
      history.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }

  /// Solo question records, most recent first. Corrupt entries are skipped.
  Future<List<SoloQuestionRecord>> getSoloQuestionHistory() async {
    final jsonList =
        _prefs.getStringList(_keySoloQuestionHistory) ?? const <String>[];
    final records = <SoloQuestionRecord>[];
    for (final json in jsonList) {
      try {
        final decoded = jsonDecode(json);
        if (decoded is! Map<String, dynamic>) continue;
        records.add(SoloQuestionRecord.fromJson(decoded));
      } catch (_) {}
    }
    records.sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    return records;
  }

  Future<void> clearSoloQuestionHistory() async {
    await _prefs.remove(_keySoloQuestionHistory);
  }

  // ---------------------------------------------------------------------------
  // Solo in-progress session, so it can be resumed later.
  // ---------------------------------------------------------------------------

  /// Saves the unfinished session, overwriting any previously stored one.
  Future<void> saveSoloInProgress(SoloSession session) async {
    await _prefs.setString(_keySoloInProgress, jsonEncode(session.toJson()));
  }

  /// The unfinished session, or null when none is stored.
  ///
  /// A corrupt value returns null instead of throwing.
  Future<SoloSession?> getSoloInProgress() async {
    final jsonString = _prefs.getString(_keySoloInProgress);
    if (jsonString == null) return null;
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) return null;
      return SoloSession.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSoloInProgress() async {
    await _prefs.remove(_keySoloInProgress);
  }

  /// Keeps only the [maxSessions] most recent sessions, so the history cannot
  /// grow without bound.
  Future<void> trimHistory(int maxSessions) async {
    if (maxSessions <= 0) return;
    final sessions = await getSessions();
    if (sessions.length <= maxSessions) return;
    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _saveSessions(sessions.sublist(0, maxSessions));
  }

  Future<void> _saveSessions(List<GameSession> sessions) async {
    final jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(_keySessions, jsonList);
  }

  Future<void> saveSettings(GameSettings settings) async {
    await _prefs.setString(_keySettings, jsonEncode(settings.toJson()));
  }

  Future<GameSettings> getSettings() async {
    final jsonString = _prefs.getString(_keySettings);
    if (jsonString == null) return const GameSettings();

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return GameSettings.fromJson(decoded);
      }
    } catch (_) {
      // Damaged settings are replaced by the defaults rather than thrown.
    }
    return const GameSettings();
  }

  Future<void> saveRecentPlayerNames(List<String> names) async {
    await _prefs.setStringList(_keyPlayerNames, names.take(10).toList());
  }

  Future<List<String>> getRecentPlayerNames() async {
    return _prefs.getStringList(_keyPlayerNames) ?? [];
  }

  /// Saves the user's theme preference (light, dark, system).
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, mode.name);
  }

  /// Loads the user's theme preference, defaulting to system.
  ///
  /// A value written by another version of the app, or a corrupted value, falls
  /// back to the system theme instead of throwing.
  Future<ThemeMode> getThemeMode() async {
    final value = _prefs.getString(_keyThemeMode);
    if (value == null) return ThemeMode.system;
    for (final mode in ThemeMode.values) {
      if (mode.name == value) return mode;
    }
    return ThemeMode.system;
  }

  /// Saves the user's language preference (fr, en).
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_keyLocale, locale.languageCode);
  }

  /// Loads the user's language preference, defaulting to French.
  ///
  /// A language the app does not support, or a corrupted value, falls back to
  /// French instead of throwing.
  Future<Locale> getLocale() async {
    final value = _prefs.getString(_keyLocale);
    if (value == 'en') return const Locale('en');
    return const Locale('fr');
  }

  /// Decodes one stored session, returning null when the entry is unreadable.
  static GameSession? _decodeSession(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) return null;
      final session = GameSession.fromJson(decoded);
      // An entry with neither an id nor any content is not a session at all:
      // dropping it keeps a stray empty object out of the history.
      if (session.id.isEmpty &&
          session.players.isEmpty &&
          session.rounds.isEmpty) {
        return null;
      }
      return session;
    } catch (_) {
      return null;
    }
  }
}
