import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/main.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';
import 'package:knowledge_test/repositories/question_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/load_question_bank.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('StartupApp widget', () {
    testWidgets('shows loading indicator while loader is in progress', (tester) async {
      final completer = Completer<QuestionRepository>();

      await tester.pumpWidget(
        StartupApp(
          loader: () => completer.future,
        ),
      );

      // Pump a single frame: CircularProgressIndicator should be visible
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete future and pump
      completer.complete(InMemoryQuestionRepository(const []));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Nouvelle partie'), findsOneWidget);
    });

    testWidgets('shows home screen when repository loads successfully', (tester) async {
      final repo = InMemoryQuestionRepository(const []);

      await tester.pumpWidget(
        StartupApp(
          loader: () async => repo,
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(MainApp), findsOneWidget);
      expect(find.text('Nouvelle partie'), findsOneWidget);
      expect(find.text('Bibliothèque de questions'), findsOneWidget);
    });

    testWidgets('shows error screen and retries when loader throws', (tester) async {
      var callCount = 0;
      final successfulRepo = InMemoryQuestionRepository(const []);

      Future<QuestionRepository> fakeLoader() async {
        callCount++;
        if (callCount == 1) {
          throw Exception('Asset bundle failed');
        }
        return successfulRepo;
      }

      await tester.pumpWidget(
        StartupApp(
          loader: fakeLoader,
        ),
      );

      // Let the error snapshot propagate
      await tester.pump();
      await tester.pump();

      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.textContaining('Impossible de charger la banque de questions'), findsOneWidget);
      expect(find.byType(MainApp), findsNothing);
      expect(callCount, 1);

      // Tap retry
      await tester.tap(find.text('Réessayer'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(callCount, 2);
      expect(find.byType(MainApp), findsOneWidget);
      expect(find.text('Nouvelle partie'), findsOneWidget);
    });
  });

  group('Question repository provider override with assets', () {
    test('serves the full 117 JSON-loaded questions when overridden', () async {
      final questions = await loadQuestionBank();
      expect(questions.length, 117);

      final assetRepo = InMemoryQuestionRepository(questions);

      final container = ProviderContainer(
        overrides: [
          questionRepositoryProvider.overrideWithValue(assetRepo),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(questionRepositoryProvider);
      expect(repo.getAllQuestions().length, 117);

      for (final mode in GameMode.values) {
        expect(repo.getQuestionsByMode(mode).isNotEmpty, isTrue);
      }
    });
  });
}
