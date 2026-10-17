import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/features/game_setup/game_setup_screen.dart';
import 'package:knowledge_test/features/question_library/question_library_screen.dart';
import 'package:knowledge_test/features/session_history/session_history_screen.dart';
import 'package:knowledge_test/features/settings/settings_screen.dart';
import 'package:knowledge_test/main.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_session_store.dart';
import '../helpers/test_question_repository.dart';

/// Pumps the real app with the router, at the given window size.
///
/// [store] replaces the local storage of the session history, which lets a
/// saved session from a previous run be part of the test.
Future<void> pumpApp(
  WidgetTester tester,
  Size size, {
  FakeSessionStore? store,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final storage = await StorageService.create();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        testQuestionRepositoryOverride,
        storageServiceProvider.overrideWith((ref) async => storage),
        if (store != null)
          sessionStoreProvider.overrideWith((ref) async => store),
      ],
      child: const MainApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// One finished session of three questions between Alice and Claire.
FakeSessionStore sessionStoreWithOneSession() {
  return FakeSessionStore()
    ..stored.add(
      GameSession(
        id: 'sess-1',
        createdAt: DateTime.utc(2026, 5, 4, 20),
        players: const [
          Player(id: 'p1', name: 'Alice', score: 3),
          Player(id: 'p2', name: 'Bob', score: 1),
        ],
        settings: const GameSettings(questionCount: 3),
        rounds: [
          for (var i = 0; i < 3; i++)
            RoundResult(
              roundNumber: i + 1,
              questionId: 'wcf-00${i + 1}',
              questionText: '',
              answers: const [],
              correctAnswer: '',
              answeredAt: DateTime.utc(2026, 5, 4, 20, 15 + i),
            ),
        ],
        status: GameStatus.completed,
        completedAt: DateTime.utc(2026, 5, 4, 20, 45),
      ),
    );
}

void main() {
  group('Home navigation', () {
    testWidgets('the home screen offers the four destinations', (tester) async {
      await pumpApp(tester, const Size(395, 845));

      expect(find.text('Nouvelle partie'), findsOneWidget);
      expect(find.text('Bibliothèque de questions'), findsOneWidget);
      expect(find.text('Historique des sessions'), findsOneWidget);
      expect(find.text('Paramètres'), findsOneWidget);
    });

    testWidgets('the library opens and returns home', (tester) async {
      await pumpApp(tester, const Size(395, 845));

      await tester.tap(find.text('Bibliothèque de questions'));
      await tester.pumpAndSettle();
      expect(find.byType(QuestionLibraryScreen), findsOneWidget);
      expect(find.text('Bibliothèque de questions'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.byType(QuestionLibraryScreen), findsNothing);
    });

    testWidgets('the settings screen opens and returns home', (tester) async {
      await pumpApp(tester, const Size(395, 845));

      await tester.tap(find.text('Paramètres'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.byType(SettingsScreen), findsNothing);
    });

    testWidgets('the session history opens and returns home', (tester) async {
      await pumpApp(tester, const Size(395, 845));

      await tester.tap(find.text('Historique des sessions'));
      await tester.pumpAndSettle();
      expect(find.byType(SessionHistoryScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.byType(SessionHistoryScreen), findsNothing);
    });

    testWidgets('the game setup opens and returns home', (tester) async {
      await pumpApp(tester, const Size(395, 845));

      await tester.tap(find.text('Nouvelle partie'));
      await tester.pumpAndSettle();
      expect(find.byType(GameSetupScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.byType(GameSetupScreen), findsNothing);
    });
  });

  group('History navigation', () {
    testWidgets('a stored session is listed with its date and winner', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const Size(395, 845),
        store: sessionStoreWithOneSession(),
      );

      await tester.tap(find.text('Historique des sessions'));
      await tester.pumpAndSettle();

      expect(find.text('04/05/2026 20:00'), findsOneWidget);
      expect(find.text('Alice — 3 pts • 2 joueurs'), findsOneWidget);
      // The badge shows how many questions the session holds.
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('an empty history shows its empty state', (tester) async {
      await pumpApp(tester, const Size(395, 845));

      await tester.tap(find.text('Historique des sessions'));
      await tester.pumpAndSettle();

      expect(find.text('Aucune session enregistrée'), findsOneWidget);
    });

    testWidgets('a stored session opens its details and returns', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const Size(395, 845),
        store: sessionStoreWithOneSession(),
      );

      await tester.tap(find.text('Historique des sessions'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('04/05/2026 20:00'));
      await tester.pumpAndSettle();

      // The detail screen shows the settings, the ranking and the questions.
      expect(find.text('Détail de la session'), findsOneWidget);
      expect(find.text('Classement final'), findsOneWidget);
      expect(find.text('Questions jouées'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('3 pts'), findsOneWidget);
      // The stored question ids are resolved back to their text.
      expect(
        find.textContaining('premier pas de l\'Homme sur la Lune'),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();
      expect(find.text('Historique des sessions'), findsOneWidget);
    });
  });
}
