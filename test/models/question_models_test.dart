import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/questions/index.dart';

void main() {
  group('BaseQuestion metadata', () {
    test('defaults language to French and review status to approved', () {
      final question = _buildQuestion();
      expect(question.language, Language.french);
      expect(question.reviewStatus, ContentReviewStatus.approved);
      expect(question.imageUrl, isNull);
    });

    test('isPlayable requires text and explanation', () {
      final question = _buildQuestion();
      expect(question.isPlayable, isTrue);
    });

    test('toString exposes id, mode and variation', () {
      final question = _buildQuestion();
      expect(question.toString(), contains('id: wcf-test'));
      expect(question.toString(), contains('mode: whichCameFirst'));
    });
  });

  group('WhichCameFirstQuestion', () {
    final question = WhichCameFirstQuestion(
      id: 'wcf-test',
      category: QuestionCategory.history,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier ?',
      explanationFr: 'Explication.',
      sourceReference: 'Source',
      factGroupId: 'fg-test',
      createdAt: DateTime.utc(2025, 1, 1),
      events: [
        ChronologyEvent(
          id: 'e2',
          label: 'Événement récent',
          date: DateTime.utc(2000, 1, 1),
        ),
        ChronologyEvent(
          id: 'e1',
          label: 'Événement ancien',
          date: DateTime.utc(1900, 1, 1),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    );

    test('exposes its mode and variation', () {
      expect(question.mode, GameMode.whichCameFirst);
      expect(question.variation, QuestionVariation.whichCameFirst);
    });

    test('serializes and deserializes without loss', () {
      final restored = WhichCameFirstQuestion.fromJson(question.toJson());
      expect(restored, question);
      expect(restored.events[1].date, DateTime.utc(1900, 1, 1));
      expect(restored.correctFirstIndex, 1);
    });

    test('answer indexes are within the event list bounds', () {
      expect(question.correctFirstIndex, inInclusiveRange(0, question.events.length - 1));
      expect(question.correctSecondIndex, inInclusiveRange(0, question.events.length - 1));
    });
  });

  group('GuessTheCountryQuestion', () {
    GuessTheCountryQuestion build({
      List<CountryClue>? clues,
      String? flagImageUrl,
      String? silhouetteImageUrl,
    }) {
      return GuessTheCountryQuestion(
        id: 'gtc-test',
        category: QuestionCategory.geography,
        difficulty: Difficulty.medium,
        text: 'Devine le pays.',
        explanationFr: 'Explication.',
        sourceReference: 'Source',
        factGroupId: 'fg-test',
        createdAt: DateTime.utc(2025, 1, 1),
        targetCountry: 'Japon',
        targetCountryCode: 'JP',
        acceptedAnswers: const ['Japon', 'Japan'],
        capital: 'Tokyo',
        continent: 'Asie',
        clues: clues ??
            const [
              CountryClue(text: 'C\'est un archipel', order: 1),
              CountryClue(text: 'Le mont Fuji s\'y trouve', order: 2),
            ],
        flagImageUrl: flagImageUrl,
        silhouetteImageUrl: silhouetteImageUrl,
      );
    }

    test('progressive clues are the default variation', () {
      expect(build().variation, QuestionVariation.guessTheCountryProgressive);
    });

    test('a capital clue selects the capital variation', () {
      final question = build(
        clues: const [CountryClue(text: 'La capitale est Paris', order: 1)],
      );
      expect(question.variation, QuestionVariation.guessTheCountryCapital);
    });

    test('a flag image selects the flag variation', () {
      final question = build(flagImageUrl: 'assets/flags/fr.png');
      expect(question.variation, QuestionVariation.guessTheCountryFlag);
    });

    test('a silhouette image takes precedence over a flag', () {
      final question = build(
        flagImageUrl: 'assets/flags/fr.png',
        silhouetteImageUrl: 'assets/silhouettes/fr.png',
      );
      expect(question.variation, QuestionVariation.guessTheCountrySilhouette);
    });

    test('serializes and deserializes without loss', () {
      final question = build();
      final restored = GuessTheCountryQuestion.fromJson(question.toJson());
      expect(restored, question);
      expect(restored.acceptedAnswers, ['Japon', 'Japan']);
      expect(restored.clues.length, 2);
    });
  });

  group('FactOrCapQuestion', () {
    FactOrCapQuestion build({
      required List<FactStatement> statements,
      int? falseStatementIndex,
      int? lieStatementIndex,
    }) {
      return FactOrCapQuestion(
        id: 'foc-test',
        category: QuestionCategory.science,
        difficulty: Difficulty.easy,
        text: 'Fait ou fake ?',
        explanationFr: 'Explication.',
        sourceReference: 'Source',
        factGroupId: 'fg-test',
        createdAt: DateTime.utc(2025, 1, 1),
        statements: statements,
        falseStatementIndex: falseStatementIndex,
        lieStatementIndex: lieStatementIndex,
      );
    }

    final twoTruthsOneLie = [
      const FactStatement(id: 's1', text: 'Vrai', isTrue: true),
      const FactStatement(id: 's2', text: 'Vrai', isTrue: true),
      const FactStatement(id: 's3', text: 'Faux', isTrue: false),
    ];

    test('a single statement is a true/false question', () {
      final question = build(
        statements: [const FactStatement(id: 's1', text: 'Vrai', isTrue: true)],
      );
      expect(question.variation, QuestionVariation.factOrCapTrueFalse);
    });

    test('a lie index selects the two truths and a lie variation', () {
      final question = build(statements: twoTruthsOneLie, lieStatementIndex: 2);
      expect(question.variation, QuestionVariation.factOrCapTwoTruthsOneLie);
    });

    test('a false index selects the identify-the-false-statement variation', () {
      final question = build(
        statements: [
          ...twoTruthsOneLie,
          const FactStatement(id: 's4', text: 'Vrai', isTrue: true),
        ],
        falseStatementIndex: 2,
      );
      expect(question.variation, QuestionVariation.factOrCapIdentifyFalse);
    });

    test('the statement flagged as a lie is the false one', () {
      final question = build(statements: twoTruthsOneLie, lieStatementIndex: 2);
      expect(question.statements[question.lieStatementIndex!].isTrue, isFalse);
    });

    test('serializes and deserializes without loss', () {
      final question = build(statements: twoTruthsOneLie, lieStatementIndex: 2);
      final restored = FactOrCapQuestion.fromJson(question.toJson());
      expect(restored, question);
      expect(restored.lieStatementIndex, 2);
    });
  });

  group('PutInOrderQuestion', () {
    PutInOrderQuestion build({required List<String> unitLabels}) {
      return PutInOrderQuestion(
        id: 'pio-test',
        category: QuestionCategory.science,
        difficulty: Difficulty.medium,
        text: 'Range ces éléments.',
        explanationFr: 'Explication.',
        sourceReference: 'Source',
        factGroupId: 'fg-test',
        createdAt: DateTime.utc(2025, 1, 1),
        items: [
          for (var i = 0; i < unitLabels.length; i++)
            OrderableItem(
              id: 'item-$i',
              label: 'Élément $i',
              referenceValue: (unitLabels.length - i).toDouble(),
              unit: unitLabels[i],
            ),
        ],
        correctOrderIds: [
          for (var i = 0; i < unitLabels.length; i++) 'item-$i',
        ].reversed.toList(),
      );
    }

    test('year units select the chronological variation', () {
      expect(build(unitLabels: ['année', 'année']).variation,
          QuestionVariation.putInOrderChronological);
    });

    test('other units select the by-property variation', () {
      expect(build(unitLabels: ['m', 'm']).variation, QuestionVariation.putInOrderByProperty);
    });

    test('the stored order is complete: every item id appears exactly once', () {
      final question = build(unitLabels: ['année', 'année', 'année']);
      expect(question.correctOrderIds.length, question.items.length);
      expect(question.correctOrderIds.toSet().length, question.items.length);
      expect(question.correctOrderIds.toSet(), question.items.map((i) => i.id).toSet());
    });

    test('serializes and deserializes without loss', () {
      final question = build(unitLabels: ['km²', 'km²']);
      final restored = PutInOrderQuestion.fromJson(question.toJson());
      expect(restored, question);
      expect(restored.items.first.referenceValue, 2.0);
    });
  });

  group('EstimationAnswer / HowMuchQuestion', () {
    EstimationAnswer buildAnswer({
      String unit = 'pays',
      String? unitFr = 'pays',
      String scoringRuleId = 'exact_match',
      double? acceptedMin,
      double? acceptedMax,
      double referenceValue = 5,
    }) {
      return EstimationAnswer(
        referenceValue: referenceValue,
        unit: unit,
        unitFr: unitFr,
        acceptedMin: acceptedMin,
        acceptedMax: acceptedMax,
        scoringRuleId: scoringRuleId,
      );
    }

    test('a quantity unit gives the quantity variation', () {
      final question = _buildHowMuch(buildAnswer());
      expect(question.variation, QuestionVariation.howMuchQuantity);
    });

    test('a year unit gives the date variation', () {
      final question = _buildHowMuch(buildAnswer(unit: 'année', unitFr: 'année'));
      expect(question.variation, QuestionVariation.howMuchDate);
    });

    test('a km unit gives the distance variation', () {
      final question = _buildHowMuch(
        buildAnswer(unit: 'km', unitFr: 'kilomètres', referenceValue: 5837),
      );
      expect(question.variation, QuestionVariation.howMuchDistance);
    });

    test('a population unit gives the population variation', () {
      final question = _buildHowMuch(
        buildAnswer(
          unit: 'millions d\'habitants',
          unitFr: 'millions d\'habitants',
          referenceValue: 68.4,
        ),
      );
      expect(question.variation, QuestionVariation.howMuchPopulation);
    });

    test('keeps the accepted range and the scoring rule id', () {
      final answer = buildAnswer(
        unit: 'km',
        unitFr: 'kilomètres',
        referenceValue: 5837,
        acceptedMin: 5500,
        acceptedMax: 6200,
        scoringRuleId: 'proximity_range',
      );
      expect(answer.referenceValue, 5837);
      expect(answer.acceptedMin, 5500);
      expect(answer.acceptedMax, 6200);
      expect(answer.scoringRuleId, 'proximity_range');
    });

    test('serializes and deserializes without loss', () {
      final answer = buildAnswer(
        unit: 'km',
        unitFr: 'kilomètres',
        referenceValue: 5837,
        acceptedMin: 5500,
        acceptedMax: 6200,
        scoringRuleId: 'proximity_range',
      );
      final restored = EstimationAnswer.fromJson(answer.toJson());
      expect(restored, answer);
    });

    test('copyWith only replaces the provided fields', () {
      final answer = buildAnswer();
      final updated = answer.copyWith(scoringRuleId: 'proximity_range');
      expect(updated.scoringRuleId, 'proximity_range');
      expect(updated.unit, answer.unit);
      expect(updated.referenceValue, answer.referenceValue);
    });
  });

  group('Enums', () {
    test('game modes have a French label', () {
      for (final mode in GameMode.values) {
        expect(mode.displayNameFr.isNotEmpty, isTrue);
      }
    });

    test('categories have a French label', () {
      for (final category in QuestionCategory.values) {
        expect(category.displayNameFr.isNotEmpty, isTrue);
      }
    });

    test('difficulties have a French label', () {
      for (final difficulty in Difficulty.values) {
        expect(difficulty.displayNameFr.isNotEmpty, isTrue);
      }
    });

    test('enum values are resolvable by name, which the JSON path relies on', () {
      expect(GameMode.values.byName('factOrCap'), GameMode.factOrCap);
      expect(Difficulty.values.byName('hard'), Difficulty.hard);
      expect(QuestionCategory.values.byName('geography'), QuestionCategory.geography);
      expect(QuestionVariation.values.byName('howMuchDistance'),
          QuestionVariation.howMuchDistance);
      expect(Language.values.byName('french'), Language.french);
      expect(ContentReviewStatus.values.byName('approved'), ContentReviewStatus.approved);
    });
  });
}

HowMuchQuestion _buildHowMuch(EstimationAnswer answer) {
  return HowMuchQuestion(
    id: 'hm-test',
    category: QuestionCategory.general,
    difficulty: Difficulty.easy,
    text: 'Combien ?',
    explanationFr: 'Explication.',
    sourceReference: 'Source',
    factGroupId: 'fg-test',
    createdAt: DateTime.utc(2025, 1, 1),
    answer: answer,
  );
}

BaseQuestion _buildQuestion() {
  return WhichCameFirstQuestion(
    id: 'wcf-test',
    category: QuestionCategory.history,
    difficulty: Difficulty.easy,
    text: 'Lequel est arrivé en premier ?',
    explanationFr: 'Explication.',
    sourceReference: 'Source',
    factGroupId: 'fg-test',
    createdAt: DateTime.utc(2025, 1, 1),
    events: [
      ChronologyEvent(id: 'e2', label: 'Récent', date: DateTime.utc(2000)),
      ChronologyEvent(id: 'e1', label: 'Ancien', date: DateTime.utc(1900)),
    ],
    correctFirstIndex: 1,
    correctSecondIndex: 0,
  );
}