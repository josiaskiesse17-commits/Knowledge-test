import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/features/game/final_ranking_screen.dart';
import 'package:knowledge_test/features/game/game_screen.dart';
import 'package:knowledge_test/features/game_setup/game_setup_screen.dart';
import 'package:knowledge_test/features/home/home_screen.dart';
import 'package:knowledge_test/features/question_library/question_library_screen.dart';
import 'package:knowledge_test/features/session_history/session_detail_screen.dart';
import 'package:knowledge_test/features/session_history/session_history_screen.dart';
import 'package:knowledge_test/features/settings/settings_screen.dart';

enum AppRoute {
  home,
  gameSetup,
  game,
  finalRanking,
  questionLibrary,
  sessionHistory,
  sessionDetail,
  settings,
}

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.gameSetup:
        return '/game-setup';
      case AppRoute.game:
        return '/game';
      case AppRoute.finalRanking:
        return '/final-ranking';
      case AppRoute.questionLibrary:
        return '/question-library';
      case AppRoute.sessionHistory:
        return '/session-history';
      case AppRoute.sessionDetail:
        return '/session-history/detail';
      case AppRoute.settings:
        return '/settings';
    }
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoute.gameSetup.path,
      name: AppRoute.gameSetup.name,
      builder: (context, state) => const GameSetupScreen(),
    ),
    GoRoute(
      path: AppRoute.game.path,
      name: AppRoute.game.name,
      builder: (context, state) => const GameScreen(),
    ),
    GoRoute(
      path: AppRoute.finalRanking.path,
      name: AppRoute.finalRanking.name,
      builder: (context, state) => const FinalRankingScreen(),
    ),
    GoRoute(
      path: AppRoute.questionLibrary.path,
      name: AppRoute.questionLibrary.name,
      builder: (context, state) => const QuestionLibraryScreen(),
    ),
    GoRoute(
      path: AppRoute.sessionHistory.path,
      name: AppRoute.sessionHistory.name,
      builder: (context, state) => const SessionHistoryScreen(),
    ),
    GoRoute(
      path: AppRoute.sessionDetail.path,
      name: AppRoute.sessionDetail.name,
      builder: (context, state) => SessionDetailScreen(
        sessionId: state.uri.queryParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoute.settings.path,
      name: AppRoute.settings.name,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Page non trouvée',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.error?.toString() ?? 'Route inconnue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoute.home.path),
            child: const Text('Retour à l\'accueil'),
          ),
        ],
      ),
    ),
  ),
);