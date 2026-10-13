import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/data/sample_question_bank.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/models/questions/index.dart';

void main() {
  final bank = SampleQuestionBank.questions;

  group('Question library filtering', () {
    test('an empty filter keeps every question', () {
      expect(const QuestionFilter().apply(bank), bank);
    });

    test('filters by mode', () {
      final filter = const QuestionFilter().toggleMode(GameMode.factOrCap);
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(result.every((q) => q.mode == GameMode.factOrCap), isTrue);
    });

    test('filters by difficulty', () {
      final filter = const QuestionFilter().toggleDifficulty(Difficulty.hard);
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(result.every((q) => q.difficulty == Difficulty.hard), isTrue);
    });

    test('filters by category', () {
      final filter = const QuestionFilter().toggleCategory(
        QuestionCategory.sports,
      );
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(
        result.every((q) => q.category == QuestionCategory.sports),
        isTrue,
      );
    });

    test('filters by variation', () {
      final filter = const QuestionFilter().toggleVariation(
        QuestionVariation.howMuchDate,
      );
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(
        result.every((q) => q.variation == QuestionVariation.howMuchDate),
        isTrue,
      );
    });

    test('combines several criteria', () {
      final filter = const QuestionFilter()
          .toggleMode(GameMode.whichCameFirst)
          .toggleDifficulty(Difficulty.easy);
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(
        result.every(
          (q) =>
              q.mode == GameMode.whichCameFirst &&
              q.difficulty == Difficulty.easy,
        ),
        isTrue,
      );
    });

    test('preserves the order of the questions', () {
      final filter = const QuestionFilter()
          .toggleMode(GameMode.whichCameFirst)
          .toggleMode(GameMode.howMuch);
      final result = filter.apply(bank);

      expect(
        result.length,
        bank
            .where(
              (q) =>
                  q.mode == GameMode.whichCameFirst ||
                  q.mode == GameMode.howMuch,
            )
            .length,
      );
      // Relative order of the bank is kept, whatever the filters.
      final bankOrder = <String>[
        for (final q in bank)
          if (q.mode == GameMode.whichCameFirst || q.mode == GameMode.howMuch)
            q.id,
      ];
      expect(result.map((q) => q.id).toList(), bankOrder);
    });

    test('an impossible combination returns nothing', () {
      // No WhichCameFirst question of the sample bank is an arts question.
      final filter = const QuestionFilter()
          .toggleMode(GameMode.whichCameFirst)
          .toggleCategory(QuestionCategory.arts);

      expect(filter.apply(bank), isEmpty);
    });

    test('a filter can be removed again', () {
      const filter = QuestionFilter();
      final active = filter.toggleMode(GameMode.putInOrder);
      expect(active.apply(bank).length, lessThan(bank.length));

      final cleared = active.toggleMode(GameMode.putInOrder);
      expect(cleared.modes, isEmpty);
      expect(cleared.apply(bank), bank);
    });

    test('reports the number of active filters', () {
      const filter = QuestionFilter();
      expect(filter.isActive, isFalse);
      expect(filter.activeCount, 0);

      final active = filter
          .toggleMode(GameMode.putInOrder)
          .toggleDifficulty(Difficulty.easy)
          .withSearch('lune');
      expect(active.isActive, isTrue);
      expect(active.activeCount, 3);
    });

    test('cleared removes every filter', () {
      final active = const QuestionFilter()
          .toggleMode(GameMode.howMuch)
          .toggleDifficulty(Difficulty.easy)
          .toggleCategory(QuestionCategory.nature)
          .withSearch('test');

      final cleared = active.cleared;
      expect(cleared, const QuestionFilter());
      expect(cleared.apply(bank), bank);
    });

    test('dropping a mode drops the variations of that mode', () {
      final filter = const QuestionFilter()
          .toggleMode(GameMode.whichCameFirst)
          .toggleMode(GameMode.howMuch)
          .toggleVariation(QuestionVariation.whichCameFirst)
          .toggleVariation(QuestionVariation.howMuchDate);
      expect(filter.variations.length, 2);

      // Removing the mode makes its variation inconsistent, so it is dropped.
      final switched = filter.toggleMode(GameMode.howMuch);
      expect(switched.variations, {QuestionVariation.whichCameFirst});
    });

    test('an empty mode selection keeps every variation allowed', () {
      final filter = const QuestionFilter()
          .toggleMode(GameMode.howMuch)
          .toggleVariation(QuestionVariation.howMuchDate);

      // No mode selected means every mode is allowed, so no variation is
      // inconsistent.
      final cleared = filter.toggleMode(GameMode.howMuch);
      expect(cleared.variations, {QuestionVariation.howMuchDate});
    });
  });

  group('Question search', () {
    test('finds a question by a word of its text', () {
      final filter = const QuestionFilter().withSearch('Lune');
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(result.any((q) => q.id == 'wcf-001'), isTrue);
    });

    test('is case insensitive', () {
      final result = const QuestionFilter().withSearch('lune').apply(bank);
      expect(result.any((q) => q.id == 'wcf-001'), isTrue);
    });

    test('ignores the accents of the question text', () {
      // The question reads "découverte" and "pénicilline".
      final withoutAccents = const QuestionFilter().withSearch('decouverte');
      final withAccents = const QuestionFilter().withSearch('découverte');

      expect(withoutAccents.apply(bank).any((q) => q.id == 'wcf-003'), isTrue);
      expect(withAccents.apply(bank).any((q) => q.id == 'wcf-003'), isTrue);
    });

    test('finds a question by its id', () {
      final filter = const QuestionFilter().withSearch('wcf-002');
      expect(filter.apply(bank).map((q) => q.id), ['wcf-002']);
    });

    test('an empty search keeps every question', () {
      expect(const QuestionFilter().withSearch('').apply(bank), bank);
    });

    test('a search with no match returns nothing', () {
      final filter = const QuestionFilter().withSearch('zzzz-not-a-word');
      expect(filter.apply(bank), isEmpty);
    });

    test('search and filters combine', () {
      final filter = const QuestionFilter()
          .toggleMode(GameMode.whichCameFirst)
          .withSearch('Berlin');
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(result.every((q) => q.mode == GameMode.whichCameFirst), isTrue);
    });
  });

  group('Question variation metadata', () {
    test('every variation maps to the mode that plays it', () {
      for (final variation in QuestionVariation.values) {
        expect(variation.mode, isA<GameMode>());
      }
    });

    test('every variation has a French label', () {
      for (final variation in QuestionVariation.values) {
        expect(variation.labelFr.isNotEmpty, isTrue);
      }
    });

    test('variation labels describe the gameplay', () {
      expect(QuestionVariation.factOrCapTrueFalse.labelFr, 'Vrai ou faux');
      expect(QuestionVariation.howMuchPopulation.labelFr, 'Population');
    });

    test('the library exposes all five modes', () {
      expect(bank.map((q) => q.mode).toSet(), GameMode.values.toSet());
    });

    test('the library exposes several variations', () {
      expect(bank.map((q) => q.variation).toSet().length, greaterThan(5));
    });

    test('each used variation belongs to its own mode', () {
      for (final question in bank) {
        expect(question.variation.mode, question.mode);
      }
    });
  });
}
