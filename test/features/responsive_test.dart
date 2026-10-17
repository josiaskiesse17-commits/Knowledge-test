import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/features/game/game_screen.dart';
import 'package:knowledge_test/features/game/widgets/question_body.dart';
import 'package:knowledge_test/features/game_setup/game_setup_screen.dart';
import 'package:knowledge_test/features/home/home_screen.dart';
import 'package:knowledge_test/features/question_library/question_library_screen.dart';
import 'package:knowledge_test/features/session_history/session_history_screen.dart';
import 'package:knowledge_test/features/settings/settings_screen.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

import '../helpers/test_question_repository.dart';

/// Window sizes the app has to work on, from a small Android phone to a wide
/// desktop browser window.
const _sizes = <Size>[
  Size(360, 640), // small Android phone
  Size(395, 845), // Android phone
  Size(600, 900), // large phone / small tablet
  Size(834, 1112), // tablet
  Size(1024, 768), // small desktop window
  Size(1280, 900), // desktop window
  Size(1920, 1080), // wide desktop window
];

/// Pumps a screen at [size]; a layout overflow fails the test.
Future<void> pumpAt(WidgetTester tester, Widget screen, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [testQuestionRepositoryOverride],
      child: MaterialApp(home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Screens fit every window size', () {
    for (final size in _sizes) {
      testWidgets('the home screen at ${size.width}x${size.height}', (
        tester,
      ) async {
        await pumpAt(tester, const HomeScreen(), size);

        expect(find.text('Bienvenue'), findsOneWidget);
        expect(find.text('Nouvelle partie'), findsOneWidget);
        expect(find.text('Paramètres'), findsOneWidget);
      });

      testWidgets('the question library at ${size.width}x${size.height}', (
        tester,
      ) async {
        await pumpAt(tester, const QuestionLibraryScreen(), size);

        expect(find.text('Bibliothèque de questions'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('the settings screen at ${size.width}x${size.height}', (
        tester,
      ) async {
        await pumpAt(tester, const SettingsScreen(), size);

        expect(find.text('Paramètres'), findsOneWidget);
        expect(find.text('Apparence'), findsOneWidget);
      });

      testWidgets('the session history at ${size.width}x${size.height}', (
        tester,
      ) async {
        await pumpAt(tester, const SessionHistoryScreen(), size);

        expect(find.text('Historique des sessions'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
  group('Gameplay fits every window size', () {
    for (final size in _sizes) {
      testWidgets('the game screen at ${size.width}x${size.height}', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final container = ProviderContainer(
          overrides: [testQuestionRepositoryOverride],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: GameScreen()),
          ),
        );

        final controller = container.read(gameControllerProvider.notifier);
        controller.prepare(
          const SessionConfig(
            playerNames: ['Alice', 'Bob', 'Claire'],
            modes: GameMode.values,
            questionCount: 3,
            difficulty: Difficulty.easy,
          ),
        );
        controller.start();
        await tester.pumpAndSettle();

        // The question and the quizmaster controls are both reachable.
        expect(find.byType(QuestionBody), findsOneWidget);
        expect(find.textContaining('Question'), findsWidgets);
        expect(find.textContaining('Scores'), findsWidgets);
        // Every player has a scoring button on the controls.
        expect(find.text('Point'), findsNWidgets(3));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Game setup fits every window size', () {
    for (final size in _sizes) {
      testWidgets('the setup screen at ${size.width}x${size.height}', (
        tester,
      ) async {
        await pumpAt(tester, const GameSetupScreen(), size);

        expect(find.text('Joueurs'), findsOneWidget);
        // The rest of the form scrolls under the first section, so only its
        // presence is checked here; an overflow would fail the pump above.
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Layouts change with the window size', () {
    testWidgets('the home screen is a grid on a desktop window', (
      tester,
    ) async {
      await pumpAt(tester, const HomeScreen(), const Size(1280, 900));

      // The description under a menu entry only exists in the wide layout.
      expect(find.text('Consultez les questions du quiz'), findsOneWidget);
      expect(find.text('Thème clair ou sombre'), findsOneWidget);
    });

    testWidgets('the home screen is a list on a phone', (tester) async {
      await pumpAt(tester, const HomeScreen(), const Size(395, 845));

      expect(find.text('Consultez les questions du quiz'), findsNothing);
      // Every entry stays a full-width row with a chevron.
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
    });

    testWidgets('the library shows its details pane on a desktop window', (
      tester,
    ) async {
      await pumpAt(
        tester,
        const QuestionLibraryScreen(),
        const Size(1280, 900),
      );

      expect(find.text('Sélectionnez une question'), findsOneWidget);
    });

    testWidgets('the library opens a question sheet on a phone', (
      tester,
    ) async {
      await pumpAt(tester, const QuestionLibraryScreen(), const Size(395, 845));

      expect(find.text('Sélectionnez une question'), findsNothing);

      // Tapping a question opens the detail sheet.
      await tester.tap(
        find.textContaining('Lequel est arrivé en premier').first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Bonne réponse'), findsOneWidget);
    });

    testWidgets('the settings screen uses radios on a phone', (tester) async {
      await pumpAt(tester, const SettingsScreen(), const Size(395, 845));

      expect(find.byType(RadioListTile<ThemeMode>), findsNWidgets(3));
      expect(find.byType(SegmentedButton<ThemeMode>), findsNothing);
    });

    testWidgets('the settings screen uses a segmented button on desktop', (
      tester,
    ) async {
      await pumpAt(tester, const SettingsScreen(), const Size(1280, 900));

      expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
      expect(find.byType(RadioListTile<ThemeMode>), findsNothing);
    });

    testWidgets(
      'the game screen shows its scores beside the question on desktop',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final container = ProviderContainer(
          overrides: [testQuestionRepositoryOverride],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: GameScreen()),
          ),
        );
        final controller = container.read(gameControllerProvider.notifier);
        controller.prepare(
          const SessionConfig(
            playerNames: ['Alice', 'Bob'],
            modes: GameMode.values,
            questionCount: 3,
            difficulty: Difficulty.easy,
          ),
        );
        controller.start();
        await tester.pumpAndSettle();

        // The quizmaster bar is only used on a narrow window.
        expect(find.byIcon(Icons.skip_next_outlined), findsOneWidget);
        expect(find.text('Point'), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('the setup screen uses two columns on a desktop window', (
      tester,
    ) async {
      await pumpAt(tester, const GameSetupScreen(), const Size(1280, 900));

      // Both columns are laid out side by side: the players list and the
      // difficulty selector are visible at the same time.
      expect(find.text('Joueurs'), findsOneWidget);
      expect(find.text('Difficulté'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
