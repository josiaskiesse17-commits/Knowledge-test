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
        QuestionVariation.whichCameFirst,
      );
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(
        result.every((q) => q.variation == QuestionVariation.whichCameFirst),
        isTrue,
      );
    });

    test('combining filters narrows results', () {
      final filter = const QuestionFilter()
          .toggleMode(GameMode.whichCameFirst)
          .toggleDifficulty(Difficulty.easy);
      final result = filter.apply(bank);

      expect(result, isNotEmpty);
      expect(
        result.every((q) => q.mode == GameMode.whichCameFirst), isTrue);
      expect(
        result.every((q) => q.difficulty == Difficulty.easy), isTrue);
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

  group('Afrique category', () {
    test('the Africa category is part of the filters', () {
      final filter = const QuestionFilter().toggleCategory(QuestionCategory.africa);
      expect(filter.categories, {QuestionCategory.africa});
      expect(QuestionCategory.africa.displayNameFr, 'Afrique');
    });

    test('filtering by Africa returns only African questions', () {
      final result = const QuestionFilter()
          .toggleCategory(QuestionCategory.africa)
          .apply(bank);

      expect(result, isNotEmpty);
      expect(
        result.every((q) => q.category == QuestionCategory.africa),
        isTrue,
      );
    });

    test('Africa appears in every game mode', () {
      final african = const QuestionFilter()
          .toggleCategory(QuestionCategory.africa)
          .apply(bank);

      for (final mode in GameMode.values) {
        expect(
          african.where((q) => q.mode == mode),
          isNotEmpty,
          reason: 'aucune question africaine pour le mode ${mode.name}',
        );
      }
    });

    test('Africa covers several modes and difficulties', () {
      final african = const QuestionFilter()
          .toggleCategory(QuestionCategory.africa)
          .apply(bank);

      expect(african.map((q) => q.mode).toSet().length, GameMode.values.length);
      expect(african.map((q) => q.difficulty).toSet().length, greaterThan(1));
    });

    test('African questions are found by text search', () {
      // "Tanzanie" only appears in African questions; "Kilimandjaro" also appears
      // in a nature question (pio-004) which is not in the Africa category.
      final result = const QuestionFilter().withSearch('Tanzanie').apply(bank);
      expect(result, isNotEmpty);
      expect(
        result.every((q) => q.category == QuestionCategory.africa),
        isTrue,
      );
    });
  });
}