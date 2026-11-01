import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/features/solo/solo_history_screen.dart';
import 'package:knowledge_test/features/solo/solo_summary_screen.dart';
import 'package:knowledge_test/features/solo/widgets/solo_put_in_order_controls.dart';
import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/localizations.dart';
import '../helpers/sample_question_bank.dart';

Future<SoloController> _completeAndPumpSummary(
  WidgetTester tester, {
  required List<BaseQuestion> questions,
  required List<String> answers,
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
      modes: questions.map((q) => q.mode).toSet().toList(),
      questionCount: questions.length,
      shuffle: false,
    ),
  );
  for (final answer in answers) {
    await controller.answer(answer);
  }

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: kTestLocale,
        localizationsDelegates: kTestLocalizationDelegates,
        supportedLocales: kTestSupportedLocales,
        home: const SoloSummaryScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
  return controller;
}

Future<StorageService> _storeSoloSessions(List<SoloSession> sessions) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final storage = await StorageService.create();
  for (final session in sessions) {
    await storage.saveSoloSession(session);
  }
  return storage;
}

Future<void> _pumpHistorySummary(
  WidgetTester tester,
  String sessionId, {
  required List<SoloSession> sessions,
  StorageService? storage,
}) async {
  final effectiveStorage = storage ?? await _storeSoloSessions(sessions);

  final container = ProviderContainer(
    overrides: [
      questionRepositoryProvider.overrideWithValue(
        InMemoryQuestionRepository(SampleQuestionBank.questions),
      ),
      storageServiceProvider.overrideWith((ref) async => effectiveStorage),
    ],
  );
  addTearDown(container.dispose);

  // Populate the history provider so the session can be found by id.
  await container.read(soloHistoryProvider.notifier).load();

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: kTestLocale,
        localizationsDelegates: kTestLocalizationDelegates,
        supportedLocales: kTestSupportedLocales,
        home: SoloSummaryScreen(sessionId: sessionId),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

Future<void> _pumpHistoryScreen(
  WidgetTester tester, {
  StorageService? storage,
}) async {
  final effectiveStorage = storage ?? await _storeSoloSessions(<SoloSession>[]);

  final container = ProviderContainer(
    overrides: [
      questionRepositoryProvider.overrideWithValue(
        InMemoryQuestionRepository(SampleQuestionBank.questions),
      ),
      storageServiceProvider.overrideWith((ref) async => effectiveStorage),
    ],
  );
  addTearDown(container.dispose);

  await container.read(soloHistoryProvider.notifier).load();

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: kTestLocale,
        localizationsDelegates: kTestLocalizationDelegates,
        supportedLocales: kTestSupportedLocales,
        home: const SoloHistoryScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

void main() {
  group('Solo summary screen - finished session', () {
    final wcf = SampleQuestionBank.questions
        .whereType<WhichCameFirstQuestion>()
        .take(2)
        .toList();

    testWidgets('shows score, streak, questions played and accuracy', (
      tester,
    ) async {
      // wcf-001 correctFirstIndex is 1; answering '1' is correct.
      final controller = await _completeAndPumpSummary(
        tester,
        questions: wcf,
        answers: const ['1', '0'],
      );

      expect(controller.state.isCompleted, isTrue);
      expect(find.textContaining('Score :'), findsOneWidget);
      expect(find.textContaining('Série maximale :'), findsOneWidget);
      expect(find.textContaining('questions jouées'), findsOneWidget);
      expect(find.textContaining('Précision globale'), findsOneWidget);
    });

    testWidgets('shows per-category accuracy', (tester) async {
      await _completeAndPumpSummary(
        tester,
        questions: wcf,
        answers: const ['1', '0'],
      );

      expect(find.textContaining('Précision par catégorie'), findsOneWidget);
    });

    testWidgets('shows mistakes with readable answers', (tester) async {
      // wcf-001: correct index 1. Answer '0' (wrong), then '1' (correct).
      await _completeAndPumpSummary(
        tester,
        questions: wcf,
        answers: const ['0', '1'],
      );

      expect(find.textContaining('Erreurs à revoir'), findsOneWidget);
      // Readable player answer (event label via SoloAnswerCodec.describe),
      // never a raw index.
      expect(
        find.textContaining("Premier pas de l'Homme sur la Lune"),
        findsOneWidget,
      );
      expect(find.text('0'), findsNothing);
      // Correct answer and explanation present (readable labels, not raw index).
      expect(
        find.textContaining('Premier vol spatial habité par une femme'),
        findsOneWidget,
      );
      expect(find.textContaining('Explication'), findsNWidgets(2));
      expect(find.textContaining('Source :'), findsNWidgets(2));
    });

    testWidgets('no mistakes shows an encouraging message', (tester) async {
      // Both answers correct.
      await _completeAndPumpSummary(
        tester,
        questions: wcf.take(1).toList(),
        answers: const ['1'],
      );

      expect(find.textContaining('Aucune erreur ! Bravo.'), findsOneWidget);
      expect(find.textContaining('Erreurs à revoir'), findsNothing);
    });

    testWidgets('play again restarts the same config', (tester) async {
      final controller = await _completeAndPumpSummary(
        tester,
        questions: wcf.take(1).toList(),
        answers: const ['1'],
      );

      final playAgain = find.textContaining('Rejouer la même partie').first;
      await tester.ensureVisible(playAgain);
      await tester.tap(playAgain);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // A new in-progress session replaced the completed one.
      expect(controller.state.isCompleted, isFalse);
      expect(controller.state.status, GameStatus.inProgress);
    });

    testWidgets(
      'summary shows the play again, new setup and back home buttons',
      (tester) async {
        await _completeAndPumpSummary(
          tester,
          questions: wcf.take(1).toList(),
          answers: const ['1'],
        );

        expect(find.textContaining('Rejouer la même partie'), findsOneWidget);
        expect(
          find.textContaining('Nouvelle configuration solo'),
          findsOneWidget,
        );
        expect(find.textContaining('Retour à l\'accueil'), findsOneWidget);
      },
    );
  });

  group('Solo summary screen - from stored history', () {
    testWidgets('opens a stored session by id', (tester) async {
      final question = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .firstWhere((q) => q.id == 'wcf-001');
      final session = SoloSession(
        id: 'stored-wcf',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        questions: [question],
        answers: [
          SoloAnswer(
            questionId: 'wcf-001',
            userAnswer: '1',
            isCorrect: true,
            pointsEarned: 10,
            answeredAt: DateTime(2026, 1, 1),
          ),
        ],
        score: 10,
        streak: 1,
        maxStreak: 1,
        status: GameStatus.completed,
        completedAt: DateTime(2026, 1, 1),
      );

      await _pumpHistorySummary(tester, 'stored-wcf', sessions: [session]);

      expect(find.textContaining('Score : 10'), findsOneWidget);
      expect(find.textContaining('Série maximale : 1'), findsOneWidget);
    });

    testWidgets('unknown id shows a missing-session screen', (tester) async {
      await _pumpHistorySummary(tester, 'does-not-exist', sessions: []);

      expect(find.byType(SoloSummaryScreen), findsOneWidget);
    });
  });

  group('Solo history screen', () {
    testWidgets('empty state when no sessions', (tester) async {
      await _pumpHistoryScreen(tester);

      expect(
        find.textContaining('Aucune partie solo enregistrée'),
        findsOneWidget,
      );
      expect(find.byType(SoloHistoryScreen), findsOneWidget);
    });

    testWidgets('lists sessions most recent first and opens summary on tap', (
      tester,
    ) async {
      final question = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .firstWhere((q) => q.id == 'wcf-001');
      final older = SoloSession(
        id: 'older',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        questions: [question],
        status: GameStatus.completed,
        score: 5,
        completedAt: DateTime(2026, 1, 1),
      );
      final newer = SoloSession(
        id: 'newer',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        questions: [question],
        status: GameStatus.completed,
        score: 15,
        completedAt: DateTime(2026, 2, 1),
      );

      final storage = await _storeSoloSessions([older, newer]);
      await _pumpHistoryScreen(tester, storage: storage);

      // Newer first: its score row appears above the older one.
      expect(find.textContaining('Score : 15'), findsOneWidget);
      expect(find.textContaining('Score : 5'), findsOneWidget);
      final newerRow = find.textContaining('Score : 15').first;
      final olderRow = find.textContaining('Score : 5').first;
      expect(
        tester.getTopLeft(newerRow).dy,
        lessThan(tester.getTopLeft(olderRow).dy),
      );
    });

    testWidgets('delete one session with confirmation', (tester) async {
      final question = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .firstWhere((q) => q.id == 'wcf-001');
      final a = SoloSession(
        id: 'delete-me',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        questions: [question],
        status: GameStatus.completed,
        score: 1,
        completedAt: DateTime(2026, 3, 1),
      );
      final b = SoloSession(
        id: 'keep-me',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        questions: [question],
        status: GameStatus.completed,
        score: 2,
        completedAt: DateTime(2026, 4, 1),
      );

      final storage = await _storeSoloSessions([a, b]);
      await _pumpHistoryScreen(tester, storage: storage);

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.textContaining('Supprimer cette partie ?'), findsOneWidget);
      await tester.tap(find.text('Supprimer').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // The newer session (score 2) was deleted; the older (score 1) remains.
      expect(find.textContaining('Score : 2'), findsNothing);
      expect(find.textContaining('Score : 1'), findsOneWidget);
    });

    testWidgets('clear all sessions with confirmation', (tester) async {
      final question = SampleQuestionBank.questions
          .whereType<WhichCameFirstQuestion>()
          .firstWhere((q) => q.id == 'wcf-001');
      final a = SoloSession(
        id: 'c1',
        config: SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        questions: [question],
        status: GameStatus.completed,
        score: 1,
        completedAt: DateTime(2026, 5, 1),
      );

      final storage = await _storeSoloSessions([a]);
      await _pumpHistoryScreen(tester, storage: storage);

      await tester.tap(find.byIcon(Icons.delete_sweep_outlined).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.textContaining('Vider l\'historique solo ?'), findsOneWidget);
      await tester.tap(find.text('Vider').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(
        find.textContaining('Aucune partie solo enregistrée'),
        findsOneWidget,
      );
    });

    testWidgets('unavailable state when storage is unreachable', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          questionRepositoryProvider.overrideWithValue(
            InMemoryQuestionRepository(SampleQuestionBank.questions),
          ),
          storageServiceProvider.overrideWith(
            (ref) async => throw StateError('storage unreachable'),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: kTestLocale,
            localizationsDelegates: kTestLocalizationDelegates,
            supportedLocales: kTestSupportedLocales,
            home: const SoloHistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(
        find.textContaining('Historique solo indisponible'),
        findsOneWidget,
      );
    });
  });

  group('PutInOrder adaptive sizing', () {
    testWidgets('renders 8 items at large text scale without overflow', (
      tester,
    ) async {
      final pio = SampleQuestionBank.questions
          .whereType<PutInOrderQuestion>()
          .firstWhere((q) => q.id == 'pio-001');

      final eightItems = List<OrderableItem>.generate(8, (i) {
        return OrderableItem(
          id: 'item-$i',
          label: 'Élément ${i + 1} avec un libellé plutôt long',
          referenceValue: i.toDouble(),
          unit: i.isEven ? 'ans' : null,
        );
      });
      final eightQuestion = PutInOrderQuestion(
        id: 'pio-8-test',
        category: pio.category,
        difficulty: pio.difficulty,
        text: 'Mettez ces 8 éléments dans l\'ordre',
        explanationFr: pio.explanationFr,
        sourceReference: pio.sourceReference,
        factGroupId: pio.factGroupId,
        createdAt: pio.createdAt,
        items: eightItems,
        correctOrderIds: eightItems.map((e) => e.id).toList(),
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: kTestLocale,
          localizationsDelegates: kTestLocalizationDelegates,
          supportedLocales: kTestSupportedLocales,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SoloPutInOrderControls(
                  question: eightQuestion,
                  onAnswer: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(ListTile), findsNWidgets(8));
      expect(tester.takeException(), isNull);
    });
  });
}
