import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

import '../helpers/test_question_repository.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [testQuestionRepositoryOverride],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Prepares a timed session through the controller, as the setup screen does.
  void startTimedSession(
    ProviderContainer container, {
    int minutes = 1,
    int questionCount = 3,
  }) {
    final controller = container.read(gameControllerProvider.notifier);
    final errors = controller.prepare(
      SessionConfig(
        playerNames: const ['Alice', 'Bob'],
        modes: GameMode.values.toList(),
        questionCount: questionCount,
        sessionDurationMinutes: minutes,
      ),
    );
    expect(errors, isEmpty);
    controller.start();
  }

  testWidgets('a timed session counts down while active', (tester) async {
    final container = makeContainer();
    startTimedSession(container, minutes: 1);

    final controller = container.read(gameControllerProvider.notifier);
    expect(controller.state.remainingSeconds, 60);

    await tester.pump(const Duration(seconds: 3));

    expect(controller.state.remainingSeconds, 57);
    expect(controller.state.isActive, isTrue);

    // Stops the countdown so the test does not leave a pending timer.
    controller.endSession();
  });

  testWidgets('pause stops the countdown and resume restarts it', (
    tester,
  ) async {
    final container = makeContainer();
    startTimedSession(container, minutes: 1);

    final controller = container.read(gameControllerProvider.notifier);

    await tester.pump(const Duration(seconds: 5));
    expect(controller.state.remainingSeconds, 55);

    controller.pause();
    final paused = controller.state.remainingSeconds;

    // The clock must not move while the session is paused.
    await tester.pump(const Duration(seconds: 10));
    expect(controller.state.isPaused, isTrue);
    expect(controller.state.remainingSeconds, paused);

    controller.resume();
    await tester.pump(const Duration(seconds: 2));
    expect(controller.state.remainingSeconds, paused! - 2);

    controller.endSession();
  });

  testWidgets('only one countdown runs after pause and resume', (tester) async {
    final container = makeContainer();
    startTimedSession(container, minutes: 5);

    final controller = container.read(gameControllerProvider.notifier);

    await tester.pump(const Duration(seconds: 4));
    expect(controller.state.remainingSeconds, 296);

    controller.pause();
    controller.resume();
    controller.pause();
    controller.resume();

    await tester.pump(const Duration(seconds: 6));

    // A single tick per second: 5 minutes - 4 seconds - 6 seconds.
    expect(controller.state.remainingSeconds, 290);

    controller.endSession();
  });

  testWidgets('the countdown keeps running when the question changes', (
    tester,
  ) async {
    final container = makeContainer();
    startTimedSession(container, minutes: 1, questionCount: 2);

    final controller = container.read(gameControllerProvider.notifier);

    await tester.pump(const Duration(seconds: 2));
    controller.skip();
    expect(controller.next(), NextResult.advanced);

    await tester.pump(const Duration(seconds: 2));
    expect(controller.state.currentIndex, 1);
    expect(controller.state.remainingSeconds, 56);

    controller.endSession();
  });

  testWidgets('the countdown stops on completion and is disposed', (
    tester,
  ) async {
    final container = makeContainer();
    startTimedSession(container, minutes: 1);

    final controller = container.read(gameControllerProvider.notifier);

    await tester.pump(const Duration(seconds: 2));
    controller.skip();
    controller.endSession();

    final stopped = controller.state.remainingSeconds;
    expect(controller.state.isCompleted, isTrue);

    await tester.pump(const Duration(seconds: 5));
    expect(controller.state.remainingSeconds, stopped);

    container.dispose();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets(
    'an expired session does not end before the question is resolved',
    (tester) async {
      final container = makeContainer();
      startTimedSession(container, minutes: 1, questionCount: 3);

      final controller = container.read(gameControllerProvider.notifier);

      await tester.pump(const Duration(seconds: 60));
      expect(controller.state.timeExpired, isTrue);
      expect(controller.state.isActive, isTrue);
      expect(controller.state.currentIndex, 0);

      // The current question must be resolved first.
      expect(controller.next(), NextResult.roundIncomplete);
      expect(controller.state.isCompleted, isFalse);

      controller.skip();
      expect(controller.next(), NextResult.sessionCompleted);
      expect(controller.state.isCompleted, isTrue);
    },
  );

  testWidgets('a question-count session has no countdown', (tester) async {
    final container = makeContainer();

    final controller = container.read(gameControllerProvider.notifier);
    final errors = controller.prepare(
      SessionConfig(
        playerNames: const ['Alice', 'Bob'],
        modes: GameMode.values.toList(),
        questionCount: 2,
      ),
    );
    expect(errors, isEmpty);
    controller.start();

    await tester.pump(const Duration(seconds: 5));

    expect(controller.state.isTimedSession, isFalse);
    expect(controller.state.remainingSeconds, isNull);
  });

  test('prepare reports the validation errors of the draft', () {
    final container = makeContainer();
    final controller = container.read(gameControllerProvider.notifier);

    final errors = controller.prepare(
      const SessionConfig(playerNames: ['Solo']),
    );

    expect(errors, isNotEmpty);
  });

  test('prepare replaces the previous session with the new one', () {
    final container = makeContainer();
    final controller = container.read(gameControllerProvider.notifier);

    controller.prepare(
      SessionConfig(
        playerNames: const ['A', 'B'],
        modes: GameMode.values.toList(),
        questionCount: 4,
      ),
    );
    controller.awardPoint('p1');

    controller.prepare(
      SessionConfig(
        playerNames: const ['C', 'D'],
        modes: GameMode.values.toList(),
        questionCount: 2,
      ),
    );

    expect(controller.state.players.map((p) => p.name).toList(), ['C', 'D']);
    expect(controller.state.questions.length, 2);
    expect(controller.state.totalScore, 0);
    expect(controller.state.status, GameStatus.pending);
  });

  test('awardPoint reports duplicate awards through the controller', () {
    final container = makeContainer();
    final controller = container.read(gameControllerProvider.notifier);

    controller.prepare(
      SessionConfig(
        playerNames: const ['A', 'B'],
        modes: GameMode.values.toList(),
        questionCount: 2,
      ),
    );
    controller.start();

    expect(controller.awardPoint('p1'), AwardResult.awarded);
    expect(controller.awardPoint('p1'), AwardResult.alreadyAwarded);
    expect(controller.undoAward('p1'), isTrue);
    expect(controller.awardPoint('p1'), AwardResult.awarded);
    expect(controller.state.players.first.score, 1);
  });

  test('the order verification dialog result drives the award', () {
    final container = makeContainer();
    final controller = container.read(gameControllerProvider.notifier);

    controller.prepare(
      SessionConfig(
        playerNames: const ['A', 'B'],
        modes: const [GameMode.putInOrder],
        questionCount: 1,
      ),
    );
    controller.start();

    expect(
      controller.isSequenceCorrect(
        controller.state.questions.isEmpty
            ? const []
            : (controller.state.currentQuestion as PutInOrderQuestion)
                  .correctOrderIds,
      ),
      isTrue,
    );

    expect(controller.awardPoint('p1'), isA<AwardResult>());
    expect(controller.next(), NextResult.roundIncomplete);
  });

  test('the ranking is exposed by the controller', () {
    final container = makeContainer();
    final controller = container.read(gameControllerProvider.notifier);

    controller.prepare(
      SessionConfig(
        playerNames: const ['A', 'B'],
        modes: GameMode.values.toList(),
        questionCount: 1,
      ),
    );
    controller.start();
    controller.awardPoint('p2');

    final rankings = controller.rankings;
    expect(rankings.first.player.name, 'B');
    expect(rankings.first.rank, 1);
    expect(rankings.last.rank, 2);
  });

  test('the remaining time is formatted for the UI', () {
    final container = makeContainer();
    final controller = container.read(gameControllerProvider.notifier);

    controller.prepare(
      SessionConfig(
        playerNames: const ['A', 'B'],
        modes: GameMode.values.toList(),
        questionCount: 1,
        sessionDurationMinutes: 2,
      ),
    );

    expect(controller.formatRemainingTime(), '02:00');
  });

  group('SessionSetupNotifier', () {
    test('defaults to two empty players and all modes', () {
      final container = makeContainer();
      final config = container.read(sessionSetupProvider);

      expect(config.playerNames.length, 2);
      expect(config.modes.length, GameMode.values.length);
      expect(config.categories, isEmpty);
      expect(config.isTimed, isFalse);
      expect(config.questionCount, 10);
    });

    test('adds and removes players within the 2 to 8 range', () {
      final container = makeContainer();
      final notifier = container.read(sessionSetupProvider.notifier);

      notifier.addPlayer();
      expect(container.read(sessionSetupProvider).playerNames.length, 3);

      for (var i = 0; i < 10; i++) {
        notifier.addPlayer();
      }
      expect(container.read(sessionSetupProvider).playerNames.length, 8);

      for (var i = 0; i < 10; i++) {
        notifier.removePlayer(0);
      }
      expect(container.read(sessionSetupProvider).playerNames.length, 2);
    });

    test('edits a player name in place', () {
      final container = makeContainer();
      final notifier = container.read(sessionSetupProvider.notifier);

      notifier.updatePlayerName(1, 'Chloé');

      expect(container.read(sessionSetupProvider).playerNames, ['', 'Chloé']);
    });

    test('toggles modes and categories', () {
      final container = makeContainer();
      final notifier = container.read(sessionSetupProvider.notifier);

      notifier.toggleMode(GameMode.howMuch);
      expect(
        container.read(sessionSetupProvider).modes,
        isNot(contains(GameMode.howMuch)),
      );

      notifier.toggleCategory(QuestionCategory.science);
      expect(
        container.read(sessionSetupProvider).categories,
        contains(QuestionCategory.science),
      );

      notifier.toggleCategory(QuestionCategory.science);
      expect(
        container.read(sessionSetupProvider).categories,
        isNot(contains(QuestionCategory.science)),
      );
    });

    test('switches between question count and duration', () {
      final container = makeContainer();
      final notifier = container.read(sessionSetupProvider.notifier);

      notifier.setSessionDurationMinutes(15);
      expect(container.read(sessionSetupProvider).isTimed, isTrue);
      expect(container.read(sessionSetupProvider).sessionDurationMinutes, 15);

      notifier.setSessionDurationMinutes(null);
      expect(container.read(sessionSetupProvider).isTimed, isFalse);

      notifier.setQuestionCount(20);
      expect(container.read(sessionSetupProvider).questionCount, 20);
    });

    test('reset restores the defaults', () {
      final container = makeContainer();
      final notifier = container.read(sessionSetupProvider.notifier);

      notifier.addPlayer();
      notifier.setQuestionCount(25);
      notifier.reset();

      expect(container.read(sessionSetupProvider).questionCount, 10);
      expect(container.read(sessionSetupProvider).playerNames.length, 2);
    });
  });
}
