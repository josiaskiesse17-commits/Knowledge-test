import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/features/home/home_screen.dart';
import 'package:knowledge_test/features/solo/solo_game_screen.dart';
import 'package:knowledge_test/features/solo/solo_setup_screen.dart';
import 'package:knowledge_test/features/solo/solo_constants.dart';

import '../helpers/localizations.dart';
import '../helpers/sample_question_bank.dart';
import '../helpers/test_question_repository.dart';

import 'package:knowledge_test/core/widgets/index.dart';

import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps the solo setup screen with a fake question repository and storage.
Future<void> pumpSetup(
  WidgetTester tester, {
  bool withInProgress = false,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});

  if (withInProgress) {
    final storage = await StorageService.create();
    await storage.saveSoloInProgress(
      SoloSession(
        id: 'saved-1',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 3),
        questions: SampleQuestionBank.questions
            .whereType<WhichCameFirstQuestion>()
            .take(3)
            .toList(),
        status: GameStatus.inProgress,
      ),
    );
  }

  final container = ProviderContainer(
    overrides: [testQuestionRepositoryOverride],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: kTestLocale,
        localizationsDelegates: kTestLocalizationDelegates,
        supportedLocales: kTestSupportedLocales,
        home: const SoloSetupScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

/// Pumps the solo game screen with an already-started session.
/// Returns the controller so tests can drive answers programmatically.
Future<SoloController> pumpGame(
  WidgetTester tester, {
  required List<BaseQuestion> questions,
  bool shuffle = false,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});

  final storage = await StorageService.create();
  final container = ProviderContainer(
    overrides: [
      testQuestionRepositoryOverride,
      storageServiceProvider.overrideWith((ref) async => storage),
    ],
  );
  addTearDown(container.dispose);

  final controller = container.read(soloControllerProvider.notifier);
  await controller.start(
    SoloConfig(
      modes: questions.map((q) => q.mode).toSet().toList(),
      questionCount: questions.length,
      shuffle: shuffle,
    ),
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: kTestLocale,
        localizationsDelegates: kTestLocalizationDelegates,
        supportedLocales: kTestSupportedLocales,
        home: const SoloGameScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
  return controller;
}

/// Pumps the solo game screen with a session built from exactly [questions].
/// Unlike [pumpGame], this lets the caller pick the [modes], [questionCount]
/// and [difficulty] so a specific question is guaranteed to be shown.
Future<SoloController> pumpGameRepo(
  WidgetTester tester, {
  required List<BaseQuestion> questions,
  List<GameMode>? modes,
  int questionCount = 1,
  Difficulty difficulty = Difficulty.medium,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});

  final storage = await StorageService.create();
  final repo = InMemoryQuestionRepository(questions);
  final container = ProviderContainer(
    overrides: [
      questionRepositoryProvider.overrideWithValue(repo),
      storageServiceProvider.overrideWith((ref) async => storage),
    ],
  );
  addTearDown(container.dispose);

  final controller = container.read(soloControllerProvider.notifier);
  await controller.start(
    SoloConfig(
      modes: modes ?? questions.map((q) => q.mode).toSet().toList(),
      questionCount: questionCount,
      difficulty: difficulty,
      shuffle: false,
    ),
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: kTestLocale,
        localizationsDelegates: kTestLocalizationDelegates,
        supportedLocales: kTestSupportedLocales,
        home: const SoloGameScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
  return controller;
}

void main() {
  group('Solo setup screen', () {
    testWidgets('shows play solo on home screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: kTestLocale,
          localizationsDelegates: kTestLocalizationDelegates,
          supportedLocales: kTestSupportedLocales,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Jouer seul(e)'), findsOneWidget);
      expect(
        find.textContaining('Répondez aux questions vous-même'),
        findsOneWidget,
      );
    });

    testWidgets('renders setup sections', (tester) async {
      await pumpSetup(tester);

      expect(find.text('Configuration solo'), findsOneWidget);
    });

    testWidgets('offers only supported modes', (tester) async {
      await pumpSetup(tester);

      expect(find.textContaining('Lequel en premier'), findsOneWidget);
      expect(find.textContaining('Fait ou Fake'), findsOneWidget);
      expect(find.textContaining('Devine le pays'), findsOneWidget);
      expect(find.textContaining('Mets dans l\'ordre'), findsOneWidget);
      expect(find.textContaining('Combien'), findsOneWidget);
    });

    testWidgets('shows resume card when in-progress session exists', (
      tester,
    ) async {
      await pumpSetup(tester, withInProgress: true);

      expect(find.text('Partie solo en cours'), findsOneWidget);
      expect(find.text('Reprendre'), findsOneWidget);
      expect(find.text('Nouvelle partie'), findsOneWidget);
    });
  });

  group('Solo game screen - WhichCameFirst', () {
    testWidgets('renders question and event cards', (tester) async {
      final wcfQuestions = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .take(2)
          .toList();
      await pumpGame(tester, questions: wcfQuestions);

      expect(find.text('Question 1 / 2'), findsOneWidget);
      expect(find.text('Score : 0'), findsOneWidget);
      expect(find.text('Série : 0'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('correct answer advances and shows feedback', (tester) async {
      final wcfQuestions = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .take(2)
          .toList();
      await pumpGame(tester, questions: wcfQuestions);

      // correctFirstIndex is 1 for wcf-001 (second event came first)
      await tester.tap(find.text('B').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Bonne réponse !'), findsOneWidget);
      expect(find.text('Score : 15'), findsOneWidget);
      expect(find.text('Série : 1'), findsOneWidget);
      expect(find.text('Question suivante'), findsOneWidget);
    });

    testWidgets('wrong answer shows incorrect and resets streak', (
      tester,
    ) async {
      final wcfQuestions = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .take(2)
          .toList();
      await pumpGame(tester, questions: wcfQuestions);

      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Mauvaise réponse.'), findsOneWidget);
      expect(find.text('Score : 0'), findsOneWidget);
      expect(find.text('Série : 0'), findsOneWidget);
    });

    testWidgets('feedback shows correct answer and explanation', (
      tester,
    ) async {
      final wcfQuestions = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .take(2)
          .toList();
      await pumpGame(tester, questions: wcfQuestions);

      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Votre réponse'), findsOneWidget);
      expect(find.text('Bonne réponse'), findsOneWidget);
      expect(find.text('Explication'), findsOneWidget);
      expect(find.textContaining('Source :'), findsOneWidget);
    });
  });

  group('Solo game screen - FactOrCap', () {
    testWidgets('renders true/false buttons', (tester) async {
      final focQuestions = SampleQuestionBank.questions
          .whereType<FactOrCapQuestion>()
          .where(
            (q) => q.lieStatementIndex == null && q.falseStatementIndex == null,
          )
          .take(1)
          .toList();
      await pumpGame(tester, questions: focQuestions);

      expect(find.text('Vrai'), findsOneWidget);
      expect(find.text('Faux'), findsOneWidget);
    });

    testWidgets('correct true/false answer scores points', (tester) async {
      final focQuestions = SampleQuestionBank.questions
          .whereType<FactOrCapQuestion>()
          .where(
            (q) => q.lieStatementIndex == null && q.falseStatementIndex == null,
          )
          .take(2)
          .toList();
      await pumpGame(tester, questions: focQuestions);

      final isTrue = focQuestions.first.statements.first.isTrue;
      await tester.tap(find.text(isTrue ? 'Vrai' : 'Faux').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Bonne réponse !'), findsOneWidget);
      expect(find.text('Score : 15'), findsOneWidget);
    });
  });

  group('Solo game screen - navigation', () {
    testWidgets('quit confirmation dialog', (tester) async {
      final wcfQuestions = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .take(1)
          .toList();
      await pumpGame(tester, questions: wcfQuestions);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Quitter la partie solo ?'), findsOneWidget);
      expect(find.text('Rester'), findsOneWidget);
      expect(find.text('Quitter'), findsOneWidget);

      await tester.tap(find.text('Rester'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(SoloGameScreen), findsOneWidget);
    });
  });

  group('Solo game screen - feedback uses answered question', () {
    testWidgets(
      'shows the first question\'s explanation, not the second\'s, after answering',
      (tester) async {
        final wcfQuestions = SampleQuestionBank.questions
            .whereType<WhichCameFirstQuestion>()
            .take(2)
            .toList();
        await pumpGame(tester, questions: wcfQuestions);

        // Answer the first question (wrong: tap 'A' when correctFirstIndex is 1)
        await tester.tap(find.text('A').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Feedback should show the first question's explanation
        expect(
          find.textContaining('Tereshkova est devenue la première femme'),
          findsOneWidget,
        );
        // And must NOT show the second question's explanation
        expect(find.textContaining('deuxième question'), findsNothing);
        expect(find.text('Question suivante'), findsOneWidget);
      },
    );

    testWidgets(
      'wrong WhichCameFirst shows the chosen event label, not a raw index',
      (tester) async {
        final wcfQuestions = SampleQuestionBank.questions
            .whereType<WhichCameFirstQuestion>()
            .take(1)
            .toList();
        await pumpGame(tester, questions: wcfQuestions);

        await tester.tap(find.text('A').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.textContaining('Votre réponse'), findsOneWidget);
        // Shows the event label 'A', not the raw string '0'
        expect(
          find.textContaining('Premier pas de l\'Homme sur la Lune'),
          findsOneWidget,
        );
        expect(find.text('0'), findsNothing);
      },
    );

    testWidgets(
      'wrong FactOrCap shows the chosen statement text, not a raw index',
      (tester) async {
        SharedPreferences.setMockInitialValues(<String, Object>{});

        final statementQuestions = SampleQuestionBank.questions
            .whereType<FactOrCapQuestion>()
            .where(
              (q) =>
                  q.lieStatementIndex != null || q.falseStatementIndex != null,
            )
            .toList();
        final statementRepo = InMemoryQuestionRepository(statementQuestions);
        final storage = await StorageService.create();
        final container = ProviderContainer(
          overrides: [
            questionRepositoryProvider.overrideWithValue(statementRepo),
            storageServiceProvider.overrideWith((ref) async => storage),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(soloControllerProvider.notifier);
        await controller.start(
          SoloConfig(
            modes: [GameMode.factOrCap],
            questionCount: 1,
            shuffle: false,
          ),
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: kTestLocale,
              localizationsDelegates: kTestLocalizationDelegates,
              supportedLocales: kTestSupportedLocales,
              home: const SoloGameScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify we got a statement-type question (renders A/B/C labels)
        final q = controller.state.currentQuestion as FactOrCapQuestion;
        expect(
          q.lieStatementIndex != null || q.falseStatementIndex != null,
          isTrue,
        );

        // Tap the first statement card (letter 'A')
        await tester.tap(find.text('A').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.textContaining('Votre réponse'), findsOneWidget);
        // Shows the chosen statement text, not the raw string '0'
        final statementText = statementQuestions.first.statements.first.text;
        expect(find.textContaining(statementText), findsOneWidget);
      },
    );

    testWidgets('last question shows feedback with correct explanation', (
      tester,
    ) async {
      final wcfQuestions = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .take(1)
          .toList();
      await pumpGame(tester, questions: wcfQuestions);

      await tester.tap(find.text('B').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Bonne réponse !'), findsOneWidget);
      expect(find.text('Voir les résultats'), findsOneWidget);
      expect(
        find.textContaining('Tereshkova est devenue la première femme'),
        findsOneWidget,
      );
    });
  });

  group('Solo game screen - resume after feedback', () {
    testWidgets('resume goes to next unanswered question, not stale feedback', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      final storage = await StorageService.create();
      final container = ProviderContainer(
        overrides: [
          testQuestionRepositoryOverride,
          storageServiceProvider.overrideWith((ref) async => storage),
        ],
      );
      addTearDown(container.dispose);

      // Start session and answer the first question
      final controller = container.read(soloControllerProvider.notifier);
      await controller.start(
        SoloConfig(
          modes: [GameMode.whichCameFirst],
          questionCount: 2,
          shuffle: false,
        ),
      );
      await controller.answer(
        '0',
      ); // wrong for wcf-001 (correctFirstIndex is 1)

      // Verify the in-progress session was saved with currentIndex advanced
      final saved = await storage.getSoloInProgress();
      expect(saved, isNotNull);
      expect(saved?.currentIndex, 1);
      expect(saved?.status, GameStatus.inProgress);

      // Simulate app restart: resume the session
      await controller.resume();
      expect(controller.state.currentIndex, 1);
      expect(controller.state.status, GameStatus.inProgress);
      expect(controller.state.currentQuestion, isNotNull);
      // The resumed question must be the next unanswered one (index 1),
      // not the one we just answered (index 0).
      expect(
        controller.state.currentQuestion?.id,
        isNot(saved?.answers.last.questionId),
      );
    });
  });

  group('Solo game screen - GuessTheCountry', () {
    testWidgets('renders four multiple-choice options', (tester) async {
      final controller = await pumpGameRepo(
        tester,
        questions: SampleQuestionBank.questions,
        modes: [GameMode.guessTheCountry],
        questionCount: 1,
        difficulty: Difficulty.medium,
      );
      final question =
          controller.state.currentQuestion as GuessTheCountryQuestion;
      expect(find.byType(AppCard), findsNWidgets(4));
      expect(find.text(question.targetCountry), findsOneWidget);
    });

    testWidgets('correct answer shows feedback with the country explanation', (
      tester,
    ) async {
      final controller = await pumpGameRepo(
        tester,
        questions: SampleQuestionBank.questions,
        modes: [GameMode.guessTheCountry],
        questionCount: 1,
        difficulty: Difficulty.medium,
      );
      final question =
          controller.state.currentQuestion as GuessTheCountryQuestion;
      final correctCard = find.text(question.targetCountry).first;
      await tester.ensureVisible(correctCard);
      await tester.tap(correctCard);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Bonne réponse !'), findsOneWidget);
      expect(find.text('Voir les résultats'), findsOneWidget);
      expect(find.textContaining(question.explanationFr), findsOneWidget);
    });

    testWidgets('wrong answer shows feedback', (tester) async {
      final controller = await pumpGameRepo(
        tester,
        questions: SampleQuestionBank.questions,
        modes: [GameMode.guessTheCountry],
        questionCount: 1,
        difficulty: Difficulty.medium,
      );
      final question =
          controller.state.currentQuestion as GuessTheCountryQuestion;
      final optionTexts = <String>[];
      for (final card in tester.widgetList<AppCard>(find.byType(AppCard))) {
        final row = (card.child as Padding).child as Row;
        final text =
            (row.children.lastWhere((c) => c is Expanded) as Expanded).child
                as Text;
        optionTexts.add(text.data!);
      }
      final wrong = optionTexts.firstWhere((t) => t != question.targetCountry);
      final wrongCard = find.text(wrong).first;
      await tester.ensureVisible(wrongCard);
      await tester.tap(wrongCard);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Mauvaise réponse.'), findsOneWidget);
      expect(find.text('Voir les résultats'), findsOneWidget);
    });

    testWidgets(
      'deterministic distractors: correct country once, stable on rebuild',
      (tester) async {
        final controller = await pumpGameRepo(
          tester,
          questions: SampleQuestionBank.questions,
          modes: [GameMode.guessTheCountry],
          questionCount: 1,
          difficulty: Difficulty.medium,
        );
        final question =
            controller.state.currentQuestion as GuessTheCountryQuestion;
        expect(find.byType(AppCard), findsNWidgets(4));
        expect(find.text(question.targetCountry), findsOneWidget);

        await tester.pump();
        expect(find.byType(AppCard), findsNWidgets(4));
        expect(find.text(question.targetCountry), findsOneWidget);
      },
    );

    testWidgets('hard mode: text field correct answer', (tester) async {
      final controller = await pumpGameRepo(
        tester,
        questions: SampleQuestionBank.questions
            .whereType<GuessTheCountryQuestion>()
            .toList(),
        modes: [GameMode.guessTheCountry],
        questionCount: 1,
        difficulty: Difficulty.hard,
      );
      final question =
          controller.state.currentQuestion as GuessTheCountryQuestion;
      final field = find.byType(TextFormField).first;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.enterText(field, question.targetCountry);
      await tester.pump();
      final validate = find.text('Valider').first;
      await tester.ensureVisible(validate);
      await tester.tap(validate);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Bonne réponse !'), findsOneWidget);
    });

    testWidgets('hard mode: text field wrong answer', (tester) async {
      await pumpGameRepo(
        tester,
        questions: SampleQuestionBank.questions
            .whereType<GuessTheCountryQuestion>()
            .toList(),
        modes: [GameMode.guessTheCountry],
        questionCount: 1,
        difficulty: Difficulty.hard,
      );
      final field = find.byType(TextFormField).first;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.enterText(field, 'Japon');
      await tester.pump();
      final validate = find.text('Valider').first;
      await tester.ensureVisible(validate);
      await tester.tap(validate);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Mauvaise réponse.'), findsOneWidget);
    });
  });

  group('Solo game screen - PutInOrder', () {
    final PutInOrderQuestion pio001 = SampleQuestionBank.questions
        .whereType<PutInOrderQuestion>()
        .firstWhere((q) => q.id == 'pio-001');

    testWidgets('renders a reorderable list with drag handles', (tester) async {
      await pumpGameRepo(tester, questions: [pio001]);
      expect(find.byType(ListTile), findsNWidgets(5));
      expect(find.byIcon(Icons.drag_handle), findsNWidgets(5));
      expect(find.text('Valider l\'ordre'), findsOneWidget);
    });

    testWidgets('initial order is never the correct order', (tester) async {
      await pumpGameRepo(tester, questions: [pio001]);
      final correctLabels = pio001.correctOrderIds
          .map((id) => pio001.items.firstWhere((i) => i.id == id).label)
          .toList();
      final displayed = tester
          .widgetList<ListTile>(find.byType(ListTile))
          .map((t) => (t.title as Text).data ?? '')
          .toList();

      expect(displayed, isNot(correctLabels));
    });

    testWidgets('validating the initial shuffled (wrong) order is incorrect', (
      tester,
    ) async {
      await pumpGameRepo(tester, questions: [pio001]);
      final validate = find.text('Valider l\'ordre').first;
      await tester.ensureVisible(validate);
      await tester.tap(validate);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Mauvaise réponse.'), findsOneWidget);
    });
  });

  group('Solo game screen - HowMuch', () {
    final HowMuchQuestion hm001 = SampleQuestionBank.questions
        .whereType<HowMuchQuestion>()
        .firstWhere((q) => q.id == 'hm-001');

    PrimaryButton validateButton(WidgetTester tester) =>
        tester.widget<PrimaryButton>(find.byType(PrimaryButton));

    testWidgets('correct numeric answer', (tester) async {
      await pumpGameRepo(tester, questions: [hm001]);
      final field = find.byType(AppTextField).first;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.enterText(field, hm001.answer.referenceValue.toString());
      await tester.pump();
      final validate = find.text('Valider').first;
      await tester.ensureVisible(validate);
      await tester.tap(validate);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Bonne réponse !'), findsOneWidget);
    });

    testWidgets('wrong numeric answer', (tester) async {
      await pumpGameRepo(tester, questions: [hm001]);
      final field = find.byType(AppTextField).first;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.enterText(find.byType(AppTextField), '999');
      await tester.pump();
      final validate = find.text('Valider').first;
      await tester.ensureVisible(validate);
      await tester.tap(validate);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Mauvaise réponse.'), findsOneWidget);
    });

    testWidgets('invalid input disables Validate and shows a localized error', (
      tester,
    ) async {
      await pumpGameRepo(tester, questions: [hm001]);

      // Validate disabled while the field is empty.
      expect(validateButton(tester).onPressed, isNull);

      // Invalid input shows a localized error and keeps Validate disabled.
      final field = find.byType(AppTextField).first;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.enterText(find.byType(AppTextField), 'abc');
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Nombre invalide'), findsOneWidget);
      expect(validateButton(tester).onPressed, isNull);

      // Valid input enables Validate again.
      await tester.enterText(field, hm001.answer.referenceValue.toString());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(validateButton(tester).onPressed, isNotNull);
    });
  });

  group('Solo game screen - all modes handled', () {
    testWidgets('every GameMode is supported by the solo game screen', (
      tester,
    ) async {
      expect(
        GameMode.values.every((mode) => kSoloSupportedModes.contains(mode)),
        isTrue,
        reason: 'kSoloSupportedModes must cover every GameMode so none hits the fallback',
      );

      // Render each mode once to confirm the screen handles it without crashing.
      for (final mode in GameMode.values) {
        final q = SampleQuestionBank.questions.firstWhere(
          (question) => question.mode == mode,
        );
        await pumpGameRepo(tester, questions: [q]);
        expect(find.byType(SoloGameScreen), findsOneWidget);
      }
    });
  });

  group('Solo game screen - completed session safety', () {
    testWidgets(
      'opened on a completed session does not crash or show an empty screen',
      (tester) async {
        SharedPreferences.setMockInitialValues(<String, Object>{});

        final storage = await StorageService.create();
        final container = ProviderContainer(
          overrides: [
            testQuestionRepositoryOverride,
            storageServiceProvider.overrideWith((ref) async => storage),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(soloControllerProvider.notifier);
        await controller.start(
          SoloConfig(
            modes: [GameMode.whichCameFirst],
            questionCount: 1,
            shuffle: false,
          ),
        );
        // wcf-001 correctFirstIndex is 1, so answering '1' completes the session.
        await controller.answer('1');
        expect(controller.state.isCompleted, isTrue);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: kTestLocale,
              localizationsDelegates: kTestLocalizationDelegates,
              supportedLocales: kTestSupportedLocales,
              home: const SoloGameScreen(),
            ),
          ),
        );
        await tester.pump();
        await tester.pump();

        // No crash, no empty screen: a loading indicator is shown while the
        // screen redirects to /solo-summary (no stale feedback is shown).
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Bonne réponse !'), findsNothing);
        expect(find.text('Voir les résultats'), findsNothing);
      },
    );
  });
}
