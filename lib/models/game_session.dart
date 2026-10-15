import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/game_settings.dart';
import 'package:knowledge_test/models/json_parsing.dart';
import 'package:knowledge_test/models/player.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/round_result.dart';

/// A session stored in the history, with its players, settings and rounds.
class GameSession {
  final String id;
  final DateTime createdAt;
  final List<Player> players;
  final GameSettings settings;
  final List<RoundResult> rounds;
  final GameStatus status;
  final DateTime? completedAt;

  const GameSession({
    required this.id,
    required this.createdAt,
    required this.players,
    required this.settings,
    this.rounds = const [],
    this.status = GameStatus.pending,
    this.completedAt,
  });

  GameSession copyWith({
    String? id,
    DateTime? createdAt,
    List<Player>? players,
    GameSettings? settings,
    List<RoundResult>? rounds,
    GameStatus? status,
    DateTime? completedAt,
  }) {
    return GameSession(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      players: players ?? this.players,
      settings: settings ?? this.settings,
      rounds: rounds ?? this.rounds,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'players': players.map((p) => p.toJson()).toList(),
      'settings': settings.toJson(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'status': status.name,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory GameSession.fromJson(Map<String, dynamic> json) {
    final players = (json['players'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(Player.fromJson)
        .toList();

    return GameSession(
      id: json['id'] as String? ?? '',
      // Sessions saved by an older version may not carry a parseable date.
      createdAt: parseDateOrNull(json['createdAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      players: players,
      settings: json['settings'] is Map<String, dynamic>
          ? GameSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : const GameSettings(),
      rounds: (json['rounds'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(RoundResult.fromJson)
          .toList(),
      status: enumByNameOrNull(GameStatus.values, json['status']) ?? GameStatus.pending,
      completedAt: parseDateOrNull(json['completedAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt &&
          listEqualsByValue(players, other.players) &&
          settings == other.settings &&
          listEqualsByValue(rounds, other.rounds) &&
          status == other.status &&
          completedAt == other.completedAt;

  @override
  int get hashCode => Object.hash(
        id,
        createdAt,
        listHashCode(players),
        settings,
        listHashCode(rounds),
        status,
        completedAt,
      );

  @override
  String toString() =>
      'GameSession(id: $id, createdAt: $createdAt, players: $players, settings: $settings, rounds: $rounds, status: $status, completedAt: $completedAt)';
}
