import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:knowledge_test/models/game_models.dart';

class StorageService {
  static const String _keySessions = 'game_sessions';
  static const String _keySettings = 'game_settings';
  static const String _keyPlayerNames = 'recent_player_names';

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

  Future<void> updateSession(GameSession session) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      await _saveSessions(sessions);
    }
  }

  Future<List<GameSession>> getSessions() async {
    final jsonList = _prefs.getStringList(_keySessions) ?? [];
    return jsonList
        .map((json) => GameSession.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deleteSession(String sessionId) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    await _saveSessions(sessions);
  }

  Future<void> clearAllSessions() async {
    await _prefs.remove(_keySessions);
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
    if (jsonString != null) {
      return GameSettings.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    }
    return const GameSettings();
  }

  Future<void> saveRecentPlayerNames(List<String> names) async {
    await _prefs.setStringList(_keyPlayerNames, names.take(10).toList());
  }

  Future<List<String>> getRecentPlayerNames() async {
    return _prefs.getStringList(_keyPlayerNames) ?? [];
  }
}