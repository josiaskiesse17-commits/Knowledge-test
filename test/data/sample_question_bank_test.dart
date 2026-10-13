import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/data/sample_question_bank.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';

void main() {
  final questions = SampleQuestionBank.questions;

  group('Sample question bank completeness', () {
    test('every mode has at least five questions', () {
      for (final mode in GameMode.values) {
        final count = questions.where((q) => q.mode == mode).length;
        expect(count, greaterThanOrEqualTo(5),
            reason: 'Le mode ${mode.name} doit contenir au moins 5 questions (trouvé : $count)');
      }
    });

    test('the bank holds at least 25 questions', () {
      expect(questions.length, greaterThanOrEqualTo(25));
    });

    test('ids are unique and non-empty', () {
      final ids = questions.map((q) => q.id).toList();
      expect(ids.toSet().length, ids.length);
      expect(ids.every((id) => id.isNotEmpty), isTrue);
    });

    test('nested ids (events, clues, statements, items) are unique', () {
      final ids = <String>{};
      void collect(String id, String scope) {
        expect(ids.add(id), isTrue,
            reason: 'Identifiant dupliqué dans $scope : $id');
      }

      for (final question in questions) {
        collect(question.id, 'question');
        if (question is WhichCameFirstQuestion) {
          for (final event in question.events) {
            collect(event.id, 'WhichCameFirst events');
          }
        } else if (question is GuessTheCountryQuestion) {
          for (final clue in question.clues) {
            collect('${question.id}:${clue.order}', 'GuessTheCountry clues');
          }
        } else if (question is FactOrCapQuestion) {
          for (final statement in question.statements) {
            collect(statement.id, 'FactOrCap statements');
          }
        } else if (question is PutInOrderQuestion) {
          for (final item in question.items) {
            collect(item.id, 'PutInOrder items');
          }
        }
      }
    });
  });

  group('Shared question metadata', () {
    test('every question has a French text and explanation', () {
      for (final question in questions) {
        expect(question.text.trim().isNotEmpty, isTrue, reason: '${question.id} sans texte');
        expect(question.explanationFr.trim().isNotEmpty, isTrue,
            reason: '${question.id} sans explication');
      }
    });

    test('every question carries a source reference', () {
      for (final question in questions) {
        expect(question.sourceReference.trim().isNotEmpty, isTrue,
            reason: '${question.id} sans source');
      }
    });

    test('every question has a non-empty fact group id', () {
      for (final question in questions) {
        expect(question.factGroupId.trim().isNotEmpty, isTrue,
            reason: '${question.id} sans factGroupId');
      }
    });

    test('the bank covers several categories and all difficulties', () {
      expect(questions.map((q) => q.category).toSet().length, greaterThanOrEqualTo(5));
      expect(questions.map((q) => q.difficulty).toSet().length, Difficulty.values.length);
    });

    test('every question language is French', () {
      expect(questions.every((q) => q.language == Language.french), isTrue);
    });

    test('every question is marked playable', () {
      expect(questions.every((q) => q.isPlayable), isTrue);
    });

    test('no image references point at missing assets', () {
      // No image assets ship with the app yet, so the sample bank must stay
      // image-free while the models keep supporting images.
      expect(questions.every((q) => q.imageUrl == null), isTrue);
    });
  });

  group('Answer structures', () {
    test('Which Came First answer indexes match the event dates', () {
      final chronology = questions.whereType<WhichCameFirstQuestion>();
      expect(chronology.length, greaterThanOrEqualTo(5));

      for (final question in chronology) {
        expect(question.events.length, greaterThanOrEqualTo(2),
            reason: '${question.id} doit proposer au moins deux événements');
        expect(question.correctFirstIndex != question.correctSecondIndex, isTrue);

        final first = question.events[question.correctFirstIndex];
        final second = question.events[question.correctSecondIndex];
        expect(first.date.isBefore(second.date) || first.date.isAtSameMomentAs(second.date),
            isTrue,
            reason: '${question.id} : le premier indiqué (${first.date}) doit précéder le second');
        expect(question.events.map((e) => e.id).toSet().length, question.events.length);
      }
    });

    test('Guess the Country has clues, accepted answers, capital and continent', () {
      final countries = questions.whereType<GuessTheCountryQuestion>();
      expect(countries.length, greaterThanOrEqualTo(5));

      for (final question in countries) {
        expect(question.clues.length, greaterThanOrEqualTo(2),
            reason: '${question.id} doit fournir des indices progressifs');
        expect(question.acceptedAnswers.isNotEmpty, isTrue);
        expect(question.acceptedAnswers.contains(question.targetCountry), isTrue,
            reason: '${question.id} doit accepter son nom officiel');
        expect(question.capital.isNotEmpty, isTrue);
        expect(question.continent.isNotEmpty, isTrue);
        expect(question.targetCountryCode.length, 2);
      }
    });

    test('Guess the Country clues are ordered progressively without gaps', () {
      for (final question in questions.whereType<GuessTheCountryQuestion>()) {
        final orders = question.clues.map((c) => c.order).toList()..sort();
        expect(orders.first, 1, reason: '${question.id} : le premier indice vaut 1');
        for (var i = 1; i < orders.length; i++) {
          expect(orders[i], orders[i - 1] + 1,
              reason: '${question.id} : les indices doivent se suivre');
        }
      }
    });

    test('Fact or Cap tracks the false statements it declares', () {
      final factOrCap = questions.whereType<FactOrCapQuestion>();
      expect(factOrCap.length, greaterThanOrEqualTo(5));

      for (final question in factOrCap) {
        final falseCount = question.statements.where((s) => !s.isTrue).length;

        switch (question.variation) {
          case QuestionVariation.factOrCapTrueFalse:
            expect(question.statements.length, 1,
                reason: '${question.id} : une affirmation unique');
            expect(question.lieStatementIndex, isNull);
            expect(question.falseStatementIndex, isNull);
          case QuestionVariation.factOrCapTwoTruthsOneLie:
            expect(question.statements.length, 3,
                reason: '${question.id} : deux vérités et un mensonge');
            expect(falseCount, 1);
            expect(question.lieStatementIndex, isNotNull);
            expect(question.statements[question.lieStatementIndex!].isTrue, isFalse,
                reason: '${question.id} : l\'index du mensonge pointe le faux');
          case QuestionVariation.factOrCapIdentifyFalse:
            expect(question.statements.length, greaterThanOrEqualTo(3),
                reason: '${question.id} : un ensemble avec une fausse affirmation');
            expect(falseCount, 1);
            expect(question.falseStatementIndex, isNotNull);
            expect(question.statements[question.falseStatementIndex!].isTrue, isFalse,
                reason: '${question.id} : l\'index du faux pointe le faux');
          default:
            fail('${question.id} : variation inattendue ${question.variation.name}');
        }

        expect(question.statements.map((s) => s.id).toSet().length,
            question.statements.length);
      }
    });

    test('Fact or Cap covers its three variations', () {
      final variations = questions
          .whereType<FactOrCapQuestion>()
          .map((q) => q.variation)
          .toSet();
      expect(variations, contains(QuestionVariation.factOrCapTrueFalse));
      expect(variations, contains(QuestionVariation.factOrCapTwoTruthsOneLie));
      expect(variations, contains(QuestionVariation.factOrCapIdentifyFalse));
    });

    test('Put in Order stores a complete, consistent sequence', () {
      final orderQuestions = questions.whereType<PutInOrderQuestion>();
      expect(orderQuestions.length, greaterThanOrEqualTo(5));

      for (final question in orderQuestions) {
        expect(question.items.length, greaterThanOrEqualTo(3),
            reason: '${question.id} doit contenir au moins trois éléments');

        // The complete correct sequence is stored: same cardinality, same set.
        expect(question.correctOrderIds.length, question.items.length,
            reason: '${question.id} : la séquence doit couvrir tous les éléments');
        expect(question.correctOrderIds.toSet(),
            question.items.map((i) => i.id).toSet(),
            reason: '${question.id} : identifiants incohérents');

        final itemsById = {for (final item in question.items) item.id: item};

        if (question.variation == QuestionVariation.putInOrderChronological) {
          for (var i = 1; i < question.correctOrderIds.length; i++) {
            final previous = itemsById[question.correctOrderIds[i - 1]]!;
            final current = itemsById[question.correctOrderIds[i]]!;
            expect(previous.referenceValue <= current.referenceValue, isTrue,
                reason: '${question.id} : ordre chronologique incohérent '
                    '(${previous.label} puis ${current.label})');
          }
        } else {
          for (var i = 1; i < question.correctOrderIds.length; i++) {
            final previous = itemsById[question.correctOrderIds[i - 1]]!;
            final current = itemsById[question.correctOrderIds[i]]!;
            expect(previous.referenceValue <= current.referenceValue, isTrue,
                reason: '${question.id} : ordre croissant incohérent '
                    '(${previous.label} puis ${current.label})');
          }
        }
      }
    });

    test('Put in Order covers both chronological and by-property variants', () {
      final variations = questions
          .whereType<PutInOrderQuestion>()
          .map((q) => q.variation)
          .toSet();
      expect(variations, contains(QuestionVariation.putInOrderChronological));
      expect(variations, contains(QuestionVariation.putInOrderByProperty));
    });

    test('How Much answers carry a value, a unit and a scoring rule id', () {
      final estimations = questions.whereType<HowMuchQuestion>();
      expect(estimations.length, greaterThanOrEqualTo(5));

      for (final question in estimations) {
        final answer = question.answer;
        expect(answer.referenceValue.isFinite, isTrue);
        expect(answer.unit.isNotEmpty, isTrue, reason: '${question.id} sans unité');
        expect(answer.scoringRuleId.isNotEmpty, isTrue,
            reason: '${question.id} sans identifiant de règle de score');

        if (answer.acceptedMin != null && answer.acceptedMax != null) {
          expect(answer.acceptedMin!, lessThanOrEqualTo(answer.acceptedMax!),
              reason: '${question.id} : plage inversée');
          expect(answer.referenceValue, inInclusiveRange(answer.acceptedMin!, answer.acceptedMax!),
              reason: '${question.id} : la valeur de référence doit être dans la plage');
        }
      }
    });

    test('How Much covers quantity, date, distance and population variations', () {
      final variations = questions.whereType<HowMuchQuestion>().map((q) => q.variation).toSet();
      expect(variations, contains(QuestionVariation.howMuchQuantity));
      expect(variations, contains(QuestionVariation.howMuchDate));
      expect(variations, contains(QuestionVariation.howMuchDistance));
      expect(variations, contains(QuestionVariation.howMuchPopulation));
    });
  });

  group('Fact groups', () {
    test('fact groups with several questions share one underlying fact', () {
      final shared = <String, List<BaseQuestion>>{};
      for (final question in questions) {
        shared.putIfAbsent(question.factGroupId, () => []).add(question);
      }

      final multiMode = shared.values.where((group) => group.length > 1).toList();
      expect(multiMode.isNotEmpty, isTrue,
          reason: 'la banque doit illustrer le regroupement de faits partagés');

      for (final group in multiMode) {
        // Distinct questions, not duplicates.
        expect(group.map((q) => q.id).toSet().length, group.length);
        for (final question in group) {
          expect(shared[question.factGroupId]!.length, greaterThan(1));
        }
      }
    });

    test('no two questions of the bank are identical', () {
      final signatures = questions.map((q) => '${q.mode.name}|${q.text}').toSet();
      expect(signatures.length, questions.length);
    });
  });

  group('SampleQuestionBank JSON round trip', () {
    test('every question survives a toJson/fromJson round trip', () {
      for (final question in SampleQuestionBank.questions) {
        final BaseQuestion restored;
        switch (question) {
          case WhichCameFirstQuestion():
            restored = WhichCameFirstQuestion.fromJson(question.toJson());
          case GuessTheCountryQuestion():
            restored = GuessTheCountryQuestion.fromJson(question.toJson());
          case FactOrCapQuestion():
            restored = FactOrCapQuestion.fromJson(question.toJson());
          case PutInOrderQuestion():
            restored = PutInOrderQuestion.fromJson(question.toJson());
          case HowMuchQuestion():
            restored = HowMuchQuestion.fromJson(question.toJson());
          default:
            fail('Type de question inattendu : ${question.runtimeType}');
        }
        expect(restored, question, reason: 'aller-retour JSON impossible pour ${question.id}');
        expect(restored.toJson(), question.toJson());
      }
    });
  });

  group('InMemoryQuestionRepository', () {
    final repository = InMemoryQuestionRepository(SampleQuestionBank.questions);

    test('returns every question', () {
      expect(repository.getAllQuestions().length, SampleQuestionBank.questions.length);
    });

    test('filters by mode', () {
      for (final mode in GameMode.values) {
        final filtered = repository.getQuestionsByMode(mode);
        expect(filtered.isNotEmpty, isTrue);
        expect(filtered.every((q) => q.mode == mode), isTrue);
      }
    });

    test('filters by category and difficulty', () {
      final geography = repository.getQuestionsByCategory(QuestionCategory.geography);
      expect(geography.isNotEmpty, isTrue);
      expect(geography.every((q) => q.category == QuestionCategory.geography), isTrue);

      final hard = repository.getQuestionsByDifficulty(Difficulty.hard);
      expect(hard.isNotEmpty, isTrue);
      expect(hard.every((q) => q.difficulty == Difficulty.hard), isTrue);
    });

    test('looks a question up by id', () {
      final first = SampleQuestionBank.questions.first;
      expect(repository.getQuestionById(first.id), first);
      expect(repository.getQuestionById('inconnu'), isNull);
    });

    test('looks questions up by fact group', () {
      final groupIds = repository.getAllFactGroupIds();
      expect(groupIds, isNotEmpty);

      for (final groupId in groupIds) {
        final group = repository.getQuestionsByFactGroupId(groupId);
        expect(group.isNotEmpty, isTrue);
        expect(group.every((q) => q.factGroupId == groupId), isTrue);
      }

      final sharedGroup = groupIds.firstWhere(
        (id) => repository.getQuestionsByFactGroupId(id).length > 1,
      );
      expect(repository.getQuestionsByFactGroupId(sharedGroup).length, greaterThan(1));
    });

    test('returns an empty list for an unknown fact group', () {
      expect(repository.getQuestionsByFactGroupId('inconnu'), isEmpty);
    });

    test('the exposed lists cannot be mutated', () {
      final list = repository.getAllQuestions();
      expect(() => list.add(list.first), throwsUnsupportedError);
    });

    test('the shared repository exposes the sample bank', () {
      expect(sampleQuestionRepository.getAllQuestions().length,
          SampleQuestionBank.questions.length);
    });
  });
}
