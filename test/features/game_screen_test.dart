import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/features/game/final_ranking_screen.dart';
import 'package:knowledge_test/features/game/game_screen.dart';
import 'package:knowledge_test/features/game/widgets/question_body.dart';
import 'package:knowledge_test/features/game/widgets/scoreboard.dart';
import 'package:knowledge_test/features/game_setup/game_setup_screen.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

import '../helpers/sample_question_bank.dart';
import '../helpers/test_question_repository.dart';

/// Starts a session containing one question of a single mode.
Future<(GameController, ProviderContainer)> pumpMode(
  WidgetTester tester, {
  required GameMode mode,
  int questionCount = 1,
}) async {
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
    SessionConfig(
      playerNames: const ['Alice', 'Bob'],
      modes: [mode],
      questionCount: questionCount,
      difficulty: Difficulty.easy,
      // Deterministic order, so the rendered question does not change from one
      // run to the next.
      shuffleQuestions: false,
    ),
  );
  controller.start();
  await tester.pump();

  return (controller, container);
}

void main() {
  group('Game screen', () {
    testWidgets('renders which came first with its events', (tester) async {
      await pumpMode(tester, mode: GameMode.whichCameFirst);

      expect(find.text('Question 1 / 1'), findsOne);
      expect(find.text('En cours'), findsOne);
      expect(find.text('Révéler la réponse'), findsOne);
      expect(find.text('Bonne réponse'), findsNothing);

      // The chronology question offers several events (letter badges).
      expect(find.text('A'), findsOne);
      expect(find.text('B'), findsOne);
    });

    testWidgets('renders guess the country with progressive clues', (
      tester,
    ) async {
      await pumpMode(tester, mode: GameMode.guessTheCountry);

      expect(find.textContaining('Indices révélés : 0 /'), findsOne);
      expect(find.text('Aucun indice pour le moment.'), findsOne);
      expect(find.textContaining('Indice suivant'), findsOne);

      // One more clue is revealed at a time.
      await tester.tap(find.textContaining('Indice suivant'));
      await tester.pump();

      expect(find.textContaining('Indices révélés : 1 /'), findsOne);
    });

    testWidgets('renders fact or cap statements', (tester) async {
      await pumpMode(tester, mode: GameMode.factOrCap);

      expect(find.textContaining('Vrai ou faux'), findsOne);
      expect(find.text('Bonne réponse'), findsNothing);
    });

    testWidgets('renders ordering items and the sequence on reveal', (
      tester,
    ) async {
      await pumpMode(tester, mode: GameMode.putInOrder);

      expect(find.text('Éléments à classer'), findsOne);
      expect(find.text('Classement complet attendu'), findsNothing);

      final reveal = find.text('Révéler la réponse');
      await tester.ensureVisible(reveal);
      await tester.tap(reveal);
      await tester.pump();

      expect(find.text('Classement complet attendu'), findsOne);
    });

    testWidgets('renders the estimation answer with its unit and range', (
      tester,
    ) async {
      await pumpMode(tester, mode: GameMode.howMuch);

      expect(find.textContaining('Règle de score'), findsOne);
      expect(find.text('Bonne réponse'), findsNothing);

      final reveal = find.text('Révéler la réponse');
      await tester.ensureVisible(reveal);
      await tester.tap(reveal);
      await tester.pump();

      expect(find.text('Bonne réponse'), findsOne);
    });

    testWidgets('awards a point and allows undoing it', (tester) async {
      final (controller, _) = await pumpMode(tester, mode: GameMode.howMuch);

      await tester.tap(find.text('Point').first);
      await tester.pump();

      expect(controller.state.players.first.score, 1);
      expect(controller.state.currentRound!.isScored, isTrue);

      await tester.tap(find.text('Annuler'));
      await tester.pump();

      expect(controller.state.totalScore, 0);
      expect(controller.state.currentRound!.outcome, QuestionOutcome.pending);
    });

    testWidgets('acts on the question with the bottom controls', (
      tester,
    ) async {
      final (controller, container) = await pumpMode(
        tester,
        mode: GameMode.howMuch,
        questionCount: 2,
      );

      await tester.tap(find.text('Passer'));
      await tester.pump();

      expect(controller.state.currentRound!.isComplete, isTrue);

      await tester.tap(find.text('Question suivante'));
      await tester.pump();

      expect(controller.state.currentIndex, 1);
      container.dispose();
    });

    testWidgets('completes the session from the bottom controls', (
      tester,
    ) async {
      final (controller, container) = await pumpMode(
        tester,
        mode: GameMode.howMuch,
      );

      controller.skip();
      await tester.pump();

      await tester.tap(find.text('Terminer la session').last);
      await tester.pump();

      expect(controller.state.isCompleted, isTrue);
      container.dispose();
    });

    testWidgets('shows the remaining time for a timed session', (tester) async {
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
        SessionConfig(
          playerNames: const ['Alice', 'Bob'],
          modes: GameMode.values.toList(),
          questionCount: 3,
          sessionDurationMinutes: 2,
        ),
      );
      controller.start();
      await tester.pump();

      expect(find.textContaining('Temps restant : 02:00'), findsOne);

      controller.endSession();
    });
  });

  group('QuestionBody', () {
    testWidgets('shows the explanation only after it is revealed', (
      tester,
    ) async {
      final question = SampleQuestionBank.questions
          .whereType<HowMuchQuestion>()
          .first;
      var revealedAnswer = false;
      var revealedExplanation = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: QuestionBody(
                  question: question,
                  round: RoundState(
                    questionId: question.id,
                    answerRevealed: revealedAnswer,
                    explanationRevealed: revealedExplanation,
                  ),
                  onRevealAnswer: () => setState(() => revealedAnswer = true),
                  onToggleExplanation: () => setState(
                    () => revealedExplanation = !revealedExplanation,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('Source :'), findsNothing);

      await tester.tap(find.text('Révéler la réponse'));
      await tester.pump();

      await tester.tap(find.text('Voir l\'explication'));
      await tester.pump();

      expect(find.textContaining('Source :'), findsOne);
      expect(find.textContaining(question.explanationFr), findsOne);
    });
  });

  group('Final ranking screen', () {
    testWidgets('marks tied players and ranks by score', (tester) async {
      final container = ProviderContainer(
        overrides: [testQuestionRepositoryOverride],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: FinalRankingScreen()),
        ),
      );

      final controller = container.read(gameControllerProvider.notifier);
      controller.prepare(
        SessionConfig(
          playerNames: const ['Alice', 'Bob', 'Chloé'],
          modes: GameMode.values.toList(),
          questionCount: 2,
        ),
      );
      controller.start();

      controller.awardPoint('p1');
      controller.skip();
      controller.next();
      controller.awardPoint('p2');
      controller.skip();
      controller.next();

      expect(controller.state.isCompleted, isTrue);
      await tester.pump();

      final rankings = controller.rankings;
      expect(rankings[0].player.score, 1);
      expect(rankings[0].isTied, isTrue);
      expect(rankings[1].player.score, 1);
      expect(rankings[1].isTied, isTrue);
      expect(rankings[2].player.score, 0);
      expect(rankings[2].isTied, isFalse);

      expect(find.text('Alice'), findsOne);
      expect(find.text('Bob'), findsOne);
      expect(find.text('Chloé'), findsOne);
      expect(find.text('Partie terminée'), findsOne);
      expect(find.text('À égalité avec un autre joueur'), findsNWidgets(2));
    });
  });

  group('Game setup screen', () {
    testWidgets('shows players, modes and the start button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testQuestionRepositoryOverride],
          child: const MaterialApp(home: GameSetupScreen()),
        ),
      );

      expect(find.text('Joueurs'), findsOne);
      expect(find.text('Modes de jeu'), findsOne);
      expect(find.text('Commencer la partie'), findsOne);

      // Two player rows by default.
      expect(find.text('Nom du joueur 1'), findsOne);
      expect(find.text('Nom du joueur 2'), findsOne);

      // The sections below the fold are scrollable.
      await tester.dragUntilVisible(
        find.text('Difficulté'),
        find.byType(ListView),
        const Offset(0, -60),
      );
      expect(find.text('Difficulté'), findsOne);
    });

    testWidgets('refuses to start with empty player names', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testQuestionRepositoryOverride],
          child: const MaterialApp(home: GameSetupScreen()),
        ),
      );

      await tester.tap(find.text('Commencer la partie'));
      await tester.pump();

      expect(find.textContaining('Ajoutez au moins 2 joueurs'), findsOne);
      expect(find.byType(GameScreen), findsNothing);
    });

    testWidgets('starts the session once names are set', (tester) async {
      // A real router so the screen can navigate to the game.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [testQuestionRepositoryOverride],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );

      await tester.tap(find.text('Nouvelle partie'));
      await tester.pumpAndSettle();
      expect(find.byType(GameSetupScreen), findsOne);

      await tester.enterText(
        find.widgetWithText(TextField, 'Nom du joueur 1'),
        'Alice',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Nom du joueur 2'),
        'Bob',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer la partie'));
      await tester.pumpAndSettle();

      expect(find.byType(GameScreen), findsOne);
      expect(find.text('Alice'), findsOne);
      expect(find.text('Bob'), findsOne);
    });
  });

  group('Scoreboard and QuestionStatusBadge', () {
    testWidgets('the status badge reports the outcome of the question', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuestionStatusBadge(
              round: RoundState(
                questionId: 'q1',
                outcome: QuestionOutcome.skipped,
              ),
              questionNumber: 2,
              questionCount: 5,
              isTimed: false,
              remainingTime: '--:--',
            ),
          ),
        ),
      );

      expect(find.text('Question 2 / 5'), findsOne);
      expect(find.text('Passée'), findsOne);
      expect(find.textContaining('Temps restant'), findsNothing);
    });

    testWidgets('the scoreboard lists every player with its score', (
      tester,
    ) async {
      final (controller, container) = await pumpMode(
        tester,
        mode: GameMode.howMuch,
      );
      controller.awardPoint('p1');
      await tester.pump();

      // Pumped on its own with the real session state.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scoreboard(
              state: controller.state,
              onAward: (playerId) => controller.awardPoint(playerId),
              onUndo: controller.undoAward,
            ),
          ),
        ),
      );

      expect(find.text('Alice'), findsOne);
      expect(find.text('Bob'), findsOne);
      // Alice already has a point: only Bob can still receive one.
      expect(find.text('Point'), findsOne);
      expect(find.text('Scores'), findsOne);
      container.dispose();
    });
  });
}
