import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/models/game_enums.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DateTime _createdAt = DateTime.utc(2025, 1, 1);

WhichCameFirstQuestion _wcf({
  String id = 'wcf',
  int correctFirstIndex = 0,
  String factGroupId = 'fg',
}) {
  return WhichCameFirstQuestion(
    id: id,
    category: QuestionCategory.history,
    difficulty: Difficulty.easy,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: factGroupId,
    createdAt: _createdAt,
    events: [
      ChronologyEvent(
        id: '$id-e1',
        label: 'First $id',
        date: DateTime.utc(1900, 1, 1),
      ),
      ChronologyEvent(
        id: '$id-e2',
        label: 'Second $id',
        date: DateTime.utc(2000, 1, 1),
      ),
    ],
    correctFirstIndex: correctFirstIndex,
    correctSecondIndex: 1,
  );
}

GuessTheCountryQuestion _gtc({
  String id = 'gtc',
  String targetCountry = 'Japon',
  List<String> acceptedAnswers = const ['Japon', 'Japan'],
}) {
  return GuessTheCountryQuestion(
    id: id,
    category: QuestionCategory.geography,
    difficulty: Difficulty.easy,
    text: 'text $id',
    explanationFr: 'explanation $id',
    sourceReference: 'source $id',
    factGroupId: 'fg',
    createdAt: _createdAt,
    targetCountry: targetCountry,
    targetCountryCode: 'JP',
    acceptedAnswers: acceptedAnswers,
    capital: 'Tokyo',
    continent: 'Asie',
    clues: const [],
  );
}

Future<StorageService> _storageWithMockPrefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return StorageService.create();
}

void main() {
  group('SoloController', () {
    test('start builds a session and saves it in progress', () async {
      final repository = InMemoryQuestionRepository([
        _wcf(id: 'a', factGroupId: 'fg-a'),
        _wcf(id: 'b', factGroupId: 'fg-b'),
        _wcf(id: 'c', factGroupId: 'fg-c'),
      ]);
      final storage = await _storageWithMockPrefs();
      final controller = SoloController(repository, () async => storage);

      final errors = await controller.start(
        SoloConfig(
          modes: [GameMode.whichCameFirst],
          questionCount: 3,
          shuffle: false,
        ),
      );

      expect(errors, isEmpty);
      expect(controller.state.questions.length, 3);
      expect(controller.state.status, GameStatus.inProgress);
      final saved = await storage.getSoloInProgress();
      expect(saved?.questions.length, 3);
      expect(saved?.status, GameStatus.inProgress);
    });

    test('start reports validation errors', () async {
      final repository = InMemoryQuestionRepository([]);
      final storage = await _storageWithMockPrefs();
      final controller = SoloController(repository, () async => storage);

      final errors = await controller.start(const SoloConfig());
      expect(errors, contains('noMode'));
    });

    test('answer advances, scores and persists in progress', () async {
      final repository = InMemoryQuestionRepository([
        _wcf(id: 'a', correctFirstIndex: 0, factGroupId: 'fg-a'),
        _wcf(id: 'b', correctFirstIndex: 1, factGroupId: 'fg-b'),
      ]);
      final storage = await _storageWithMockPrefs();
      final controller = SoloController(repository, () async => storage);

      await controller.start(
        SoloConfig(
          modes: [GameMode.whichCameFirst],
          questionCount: 2,
          shuffle: false,
        ),
      );

      await controller.answer('0'); // correct, easy: 10 pts, streak 1
      expect(controller.state.score, 10);
      expect(controller.state.streak, 1);
      expect(controller.state.currentIndex, 1);
      expect(controller.state.status, GameStatus.inProgress);

      await controller.answer('0'); // wrong (correctFirstIndex is 1)
      expect(controller.state.score, 10);
      expect(controller.state.streak, 0);
      expect(controller.state.currentIndex, 2);
      expect(controller.state.status, GameStatus.completed);

      final saved = await storage.getSoloInProgress();
      expect(saved, isNull); // cleared on completion

      final sessions = await storage.getSoloSessions();
      expect(sessions.length, 1);
      expect(sessions.single.status, GameStatus.completed);
      expect(sessions.single.score, 10);

      final history = await storage.getSoloQuestionHistory();
      expect(history.length, 2);
      expect(history.where((r) => r.correct).length, 1);
    });

    test(
      'completion saves per-question records with the correct answer',
      () async {
        final repository = InMemoryQuestionRepository([
          _gtc(id: 'g', targetCountry: 'Japon'),
        ]);
        final storage = await _storageWithMockPrefs();
        final controller = SoloController(repository, () async => storage);

        await controller.start(
          SoloConfig(modes: [GameMode.guessTheCountry], questionCount: 1),
        );
        await controller.answer('Chine'); // wrong

        final sessions = await storage.getSoloSessions();
        expect(sessions.length, 1);

        final history = await storage.getSoloQuestionHistory();
        expect(history.length, 1);
        expect(history.single.questionId, 'g');
        expect(history.single.correct, isFalse);
        expect(history.single.correctAnswer, 'Japon');
      },
    );

    test('resume restores the in-progress session', () async {
      final repository = InMemoryQuestionRepository([_wcf(id: 'a')]);
      final storage = await _storageWithMockPrefs();
      final controller = SoloController(repository, () async => storage);

      await storage.saveSoloInProgress(
        SoloSession(
          id: 'resumed',
          config: SoloConfig(modes: [GameMode.whichCameFirst]),
          questions: [_wcf(id: 'a')],
          status: GameStatus.inProgress,
          currentIndex: 0,
        ),
      );

      await controller.resume();

      expect(controller.state.id, 'resumed');
      expect(controller.state.status, GameStatus.inProgress);
      expect(controller.state.questions.length, 1);
    });

    test('without storage the game still works', () async {
      final repository = InMemoryQuestionRepository([_wcf(id: 'a')]);
      final controller = SoloController(repository, () async => null);

      await controller.start(
        SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
      );
      expect(controller.state.status, GameStatus.inProgress);

      await controller.answer('0');
      expect(controller.state.status, GameStatus.completed);

      await controller.abandon();
      expect(controller.state.status, GameStatus.cancelled);
    });

    test('abandon clears the in-progress session', () async {
      final repository = InMemoryQuestionRepository([_wcf(id: 'a')]);
      final storage = await _storageWithMockPrefs();
      final controller = SoloController(repository, () async => storage);

      await controller.start(
        SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
      );
      expect(await storage.getSoloInProgress(), isNotNull);

      await controller.abandon();
      expect(await storage.getSoloInProgress(), isNull);
    });
  });

  group('soloControllerProvider wiring', () {
    test(
      'creates a controller when repository and storage are provided',
      () async {
        final storage = await _storageWithMockPrefs();
        final repository = InMemoryQuestionRepository([_wcf(id: 'a')]);

        final container = ProviderContainer(
          overrides: [
            questionRepositoryProvider.overrideWithValue(repository),
            storageServiceProvider.overrideWith((ref) async => storage),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(soloControllerProvider.notifier);
        expect(controller, isA<SoloController>());

        await controller.start(
          SoloConfig(modes: [GameMode.whichCameFirst], questionCount: 1),
        );
        expect(controller.state.status, GameStatus.inProgress);
      },
    );
  });
}
