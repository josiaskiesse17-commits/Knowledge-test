import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/features/home/home_screen.dart';
import 'package:knowledge_test/features/solo/solo_game_screen.dart';
import 'package:knowledge_test/features/solo/solo_setup_screen.dart';

import '../helpers/localizations.dart';
import '../helpers/sample_question_bank.dart';
import '../helpers/test_question_repository.dart';

import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
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
Future<void> pumpGame(
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
  await tester.pumpAndSettle();
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
      await tester.pumpAndSettle();

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
      expect(find.textContaining('Devine le pays'), findsNothing);
      expect(find.textContaining('Mets dans l’ordre'), findsNothing);
      expect(find.textContaining('Combien'), findsNothing);
    });

    testWidgets('offers only supported modes', (tester) async {
      await pumpSetup(tester);

      expect(find.textContaining('Lequel en premier'), findsOneWidget);
      expect(find.textContaining('Fait ou Fake'), findsOneWidget);
      expect(find.textContaining('Devine le pays'), findsNothing);
      expect(find.textContaining('Mets dans l’ordre'), findsNothing);
      expect(find.textContaining('Combien'), findsNothing);
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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      expect(find.text('Quitter la partie solo ?'), findsOneWidget);
      expect(find.text('Rester'), findsOneWidget);
      expect(find.text('Quitter'), findsOneWidget);

      await tester.tap(find.text('Rester'));
      await tester.pumpAndSettle();

      expect(find.byType(SoloGameScreen), findsOneWidget);
    });
  });
}
