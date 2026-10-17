import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/repositories/asset_question_repository.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';

import '../helpers/load_question_bank.dart';
import '../helpers/sample_question_bank.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<BaseQuestion> questions;

  setUpAll(() async {
    questions = await loadQuestionBank();
  });

  group('Comparison with in-memory sample bank', () {
    test('same count, same ids and identical content', () {
      final sampleQuestions = SampleQuestionBank.questions;
      expect(questions.length, sampleQuestions.length);
      expect(questions.length, 117);

      final sampleById = {for (final q in sampleQuestions) q.id: q};
      final loadedById = {for (final q in questions) q.id: q};

      expect(loadedById.keys.toSet(), sampleById.keys.toSet());

      for (final sample in sampleQuestions) {
        final loaded = loadedById[sample.id];
        expect(loaded, isNotNull);
        expect(loaded, equals(sample));
      }
    });

    test('every sample question round-trips through toJson/fromJson with equal results', () {
      for (final question in SampleQuestionBank.questions) {
        final json = question.toJson();
        final restored = BaseQuestion.fromJson(json);
        expect(restored, equals(question));
        expect(restored.toJson(), equals(json));
      }
    });
  });

  group('Question bank assets', () {
    test('the assets hold exactly the questions of the shipped bank', () {
      expect(questions.length, 117);
    });

    test('every game mode has its own file and its own questions', () {
      expect(
        questions.where((q) => q.mode == GameMode.whichCameFirst).length,
        22,
      );
      expect(
        questions.where((q) => q.mode == GameMode.guessTheCountry).length,
        20,
      );
      expect(questions.where((q) => q.mode == GameMode.factOrCap).length, 25);
      expect(questions.where((q) => q.mode == GameMode.putInOrder).length, 22);
      expect(questions.where((q) => q.mode == GameMode.howMuch).length, 28);
    });

    test('every category keeps the coverage of the shipped bank', () {
      expect(
        questions.where((q) => q.category == QuestionCategory.history).length,
        11,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.science).length,
        24,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.geography).length,
        24,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.arts).length,
        7,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.sports).length,
        7,
      );
      expect(
        questions
            .where((q) => q.category == QuestionCategory.technology)
            .length,
        11,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.nature).length,
        8,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.general).length,
        3,
      );
      expect(
        questions.where((q) => q.category == QuestionCategory.africa).length,
        22,
      );
    });

    test('difficulties stay balanced as in the shipped bank', () {
      expect(
        questions.where((q) => q.difficulty == Difficulty.easy).length,
        35,
      );
      expect(
        questions.where((q) => q.difficulty == Difficulty.medium).length,
        60,
      );
      expect(
        questions.where((q) => q.difficulty == Difficulty.hard).length,
        22,
      );
    });

    test('question ids are unique and stable across the load', () async {
      final ids = questions.map((q) => q.id).toList();
      expect(ids.toSet().length, ids.length);
      expect(ids.every((id) => id.isNotEmpty), isTrue);

      // Session history stores question ids, so the bank must keep handing out
      // the very same ids on every load.
      final second = await loadQuestionBank();
      expect(second.map((q) => q.id).toList(), ids);
    });

    test('nested ids (events, clues, statements, items) are unique', () {
      final ids = <String>{};
      void collect(String id, String scope) {
        expect(
          ids.add(id),
          isTrue,
          reason: 'Identifiant dupliqué dans $scope : $id',
        );
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
        expect(
          question.text.trim().isNotEmpty,
          isTrue,
          reason: '${question.id} sans texte',
        );
        expect(
          question.explanationFr.trim().isNotEmpty,
          isTrue,
          reason: '${question.id} sans explication',
        );
      }
    });

    test('every question carries a source reference', () {
      for (final question in questions) {
        expect(
          question.sourceReference.trim().isNotEmpty,
          isTrue,
          reason: '${question.id} sans source',
        );
      }
    });

    test('every question has a non-empty fact group id', () {
      for (final question in questions) {
        expect(
          question.factGroupId.trim().isNotEmpty,
          isTrue,
          reason: '${question.id} sans factGroupId',
        );
      }
    });

    test('the bank covers several categories and all difficulties', () {
      expect(
        questions.map((q) => q.category).toSet().length,
        greaterThanOrEqualTo(5),
      );
      expect(
        questions.map((q) => q.difficulty).toSet().length,
        Difficulty.values.length,
      );
    });

    test('every question language is French', () {
      expect(questions.every((q) => q.language == Language.french), isTrue);
    });

    test('every question is marked playable', () {
      expect(questions.every((q) => q.isPlayable), isTrue);
    });

    test('no image references point at missing assets', () {
      // No image assets ship with the app yet, so the bank must stay image-free
      // while the models keep supporting images.
      expect(questions.every((q) => q.imageUrl == null), isTrue);
    });
  });

  group('Answer structures', () {
    test('Which Came First answer indexes match the event dates', () {
      final chronology = questions.whereType<WhichCameFirstQuestion>();
      expect(chronology.length, greaterThanOrEqualTo(5));

      for (final question in chronology) {
        expect(
          question.events.length,
          greaterThanOrEqualTo(2),
          reason: '${question.id} doit proposer au moins deux événements',
        );
        expect(
          question.correctFirstIndex != question.correctSecondIndex,
          isTrue,
        );

        final first = question.events[question.correctFirstIndex];
        final second = question.events[question.correctSecondIndex];
        expect(
          first.date.isBefore(second.date) ||
              first.date.isAtSameMomentAs(second.date),
          isTrue,
          reason:
              '${question.id} : le premier indiqué (${first.date}) doit précéder le second',
        );
        expect(
          question.events.map((e) => e.id).toSet().length,
          question.events.length,
        );
      }
    });

    test(
      'Guess the Country has clues, accepted answers, capital and continent',
      () {
        final countries = questions.whereType<GuessTheCountryQuestion>();
        expect(countries.length, greaterThanOrEqualTo(5));

        for (final question in countries) {
          expect(
            question.clues.length,
            greaterThanOrEqualTo(2),
            reason: '${question.id} doit fournir des indices progressifs',
          );
          expect(question.acceptedAnswers.isNotEmpty, isTrue);
          expect(
            question.acceptedAnswers.contains(question.targetCountry),
            isTrue,
            reason: '${question.id} doit accepter son nom officiel',
          );
          expect(question.capital.isNotEmpty, isTrue);
          expect(question.continent.isNotEmpty, isTrue);
          expect(question.targetCountryCode.length, 2);
        }
      },
    );

    test('Guess the Country clues are ordered progressively without gaps', () {
      for (final question in questions.whereType<GuessTheCountryQuestion>()) {
        final orders = question.clues.map((c) => c.order).toList()..sort();
        expect(
          orders.first,
          1,
          reason: '${question.id} : le premier indice vaut 1',
        );
        for (var i = 1; i < orders.length; i++) {
          expect(
            orders[i],
            orders[i - 1] + 1,
            reason: '${question.id} : les indices doivent se suivre',
          );
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
            expect(
              question.statements.length,
              1,
              reason: '${question.id} : une affirmation unique',
            );
            expect(question.lieStatementIndex, isNull);
            expect(question.falseStatementIndex, isNull);
          case QuestionVariation.factOrCapTwoTruthsOneLie:
            expect(
              question.statements.length,
              3,
              reason: '${question.id} : deux vérités et un mensonge',
            );
            expect(falseCount, 1);
            expect(question.lieStatementIndex, isNotNull);
            expect(
              question.statements[question.lieStatementIndex!].isTrue,
              isFalse,
              reason: '${question.id} : l\'index du mensonge pointe le faux',
            );
          case QuestionVariation.factOrCapIdentifyFalse:
            expect(
              question.statements.length,
              greaterThanOrEqualTo(3),
              reason:
                  '${question.id} : un ensemble avec une fausse affirmation',
            );
            expect(falseCount, 1);
            expect(question.falseStatementIndex, isNotNull);
            expect(
              question.statements[question.falseStatementIndex!].isTrue,
              isFalse,
              reason: '${question.id} : l\'index du faux pointe le faux',
            );
          default:
            fail(
              '${question.id} : variation inattendue ${question.variation.name}',
            );
        }

        expect(
          question.statements.map((s) => s.id).toSet().length,
          question.statements.length,
        );
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
        expect(
          question.items.length,
          greaterThanOrEqualTo(3),
          reason: '${question.id} doit contenir au moins trois éléments',
        );

        // The complete correct sequence is stored: same cardinality, same set.
        expect(
          question.correctOrderIds.length,
          question.items.length,
          reason: '${question.id} : la séquence doit couvrir tous les éléments',
        );
        expect(
          question.correctOrderIds.toSet(),
          question.items.map((i) => i.id).toSet(),
          reason: '${question.id} : identifiants incohérents',
        );

        final itemsById = {for (final item in question.items) item.id: item};

        for (var i = 1; i < question.correctOrderIds.length; i++) {
          final previous = itemsById[question.correctOrderIds[i - 1]]!;
          final current = itemsById[question.correctOrderIds[i]]!;
          expect(
            previous.referenceValue <= current.referenceValue,
            isTrue,
            reason:
                '${question.id} : ordre incohérent '
                '(${previous.label} puis ${current.label})',
          );
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
        expect(
          answer.unit.isNotEmpty,
          isTrue,
          reason: '${question.id} sans unité',
        );
        expect(
          answer.scoringRuleId.isNotEmpty,
          isTrue,
          reason: '${question.id} sans identifiant de règle de score',
        );

        if (answer.acceptedMin != null && answer.acceptedMax != null) {
          expect(
            answer.acceptedMin!,
            lessThanOrEqualTo(answer.acceptedMax!),
            reason: '${question.id} : plage inversée',
          );
          expect(
            answer.referenceValue,
            inInclusiveRange(answer.acceptedMin!, answer.acceptedMax!),
            reason:
                '${question.id} : la valeur de référence doit être dans la plage',
          );
        }
      }
    });

    test(
      'How Much covers quantity, date, distance and population variations',
      () {
        final variations = questions
            .whereType<HowMuchQuestion>()
            .map((q) => q.variation)
            .toSet();
        expect(variations, contains(QuestionVariation.howMuchQuantity));
        expect(variations, contains(QuestionVariation.howMuchDate));
        expect(variations, contains(QuestionVariation.howMuchDistance));
        expect(variations, contains(QuestionVariation.howMuchPopulation));
      },
    );
  });

  group('Fact groups', () {
    test('fact groups with several questions share one underlying fact', () {
      final shared = <String, List<BaseQuestion>>{};
      for (final question in questions) {
        shared.putIfAbsent(question.factGroupId, () => []).add(question);
      }

      final multiMode = shared.values
          .where((group) => group.length > 1)
          .toList();
      expect(
        multiMode.isNotEmpty,
        isTrue,
        reason: 'la banque doit illustrer le regroupement de faits partagés',
      );

      for (final group in multiMode) {
        // Distinct questions, not duplicates.
        expect(group.map((q) => q.id).toSet().length, group.length);
        for (final question in group) {
          expect(shared[question.factGroupId]!.length, greaterThan(1));
        }
      }
    });

    test('no two questions of the bank are identical', () {
      final signatures = questions
          .map((q) => '${q.mode.name}|${q.text}')
          .toSet();
      expect(signatures.length, questions.length);
    });

    test('a reused fact group always pairs two different modes', () {
      final shared = <String, List<BaseQuestion>>{};
      for (final question in questions) {
        shared.putIfAbsent(question.factGroupId, () => []).add(question);
      }

      for (final entry in shared.entries.where((e) => e.value.length > 1)) {
        final modes = entry.value.map((q) => q.mode).toSet();
        expect(
          modes.length,
          greaterThan(1),
          reason: 'le groupe ${entry.key} regroupe deux questions du même mode',
        );
      }
    });
  });

  group('Bank size and distribution', () {
    test('the bank holds more than one hundred questions', () {
      expect(questions.length, greaterThanOrEqualTo(100));
      expect(questions.length, lessThanOrEqualTo(130));
    });

    test('every mode holds a substantial set of questions', () {
      for (final mode in GameMode.values) {
        final count = questions.where((q) => q.mode == mode).length;
        expect(
          count,
          greaterThanOrEqualTo(15),
          reason: 'le mode ${mode.name} ne compte que $count questions',
        );
      }
    });

    test('every category is represented, Africa included', () {
      for (final category in QuestionCategory.values) {
        final count = questions.where((q) => q.category == category).length;
        expect(
          count,
          greaterThanOrEqualTo(3),
          reason:
              'la catégorie ${category.name} ne compte que $count questions',
        );
      }
      expect(
        questions.any((q) => q.category == QuestionCategory.africa),
        isTrue,
      );
    });

    test('Africa is well represented across the modes', () {
      for (final mode in GameMode.values) {
        final count = questions
            .where(
              (q) => q.category == QuestionCategory.africa && q.mode == mode,
            )
            .length;
        expect(
          count,
          greaterThanOrEqualTo(2),
          reason:
              'le mode ${mode.name} n\'a que $count question(s) africaine(s)',
        );
      }
    });

    test('difficulties stay balanced', () {
      for (final difficulty in Difficulty.values) {
        final count = questions.where((q) => q.difficulty == difficulty).length;
        expect(
          count,
          greaterThanOrEqualTo(20),
          reason:
              'la difficulté ${difficulty.name} ne compte que $count questions',
        );
      }
    });

    test('every mode uses at least one variation, the bank many', () {
      for (final mode in GameMode.values) {
        final variations = questions
            .where((q) => q.mode == mode)
            .map((q) => q.variation)
            .toSet();
        expect(
          variations,
          isNotEmpty,
          reason: 'le mode ${mode.name} n\'a aucune variation',
        );
      }

      // The library variation filter has something to offer in every mode.
      for (final mode in const [
        GameMode.factOrCap,
        GameMode.putInOrder,
        GameMode.howMuch,
      ]) {
        final variations = questions
            .where((q) => q.mode == mode)
            .map((q) => q.variation)
            .toSet();
        expect(
          variations.length,
          greaterThanOrEqualTo(2),
          reason:
              'le mode ${mode.name} n\'a que ${variations.length} variations',
        );
      }
      expect(
        questions.map((q) => q.variation).toSet().length,
        greaterThanOrEqualTo(6),
      );
    });
  });

  group('Question library filters', () {
    test('the Africa category filters every mode', () {
      final repository = InMemoryQuestionRepository(questions);
      for (final mode in GameMode.values) {
        final filtered = repository
            .getQuestionsByMode(mode)
            .where((q) => q.category == QuestionCategory.africa)
            .toList();
        expect(
          filtered,
          isNotEmpty,
          reason: 'aucune question africaine dans le mode ${mode.name}',
        );
      }
    });

    test('filtering by one category never returns another', () {
      for (final category in QuestionCategory.values) {
        final filtered = questions
            .where((q) => q.category == category)
            .toList();
        expect(filtered.every((q) => q.category == category), isTrue);
      }
    });
  });

  group('Question bank JSON round trip', () {
    test('every question survives a toJson/fromJson round trip', () {
      for (final question in questions) {
        final restored = BaseQuestion.fromJson(question.toJson());

        expect(
          restored,
          question,
          reason: 'aller-retour JSON impossible pour ${question.id}',
        );
        expect(
          restored.toJson(),
          question.toJson(),
          reason: 'JSON réécrit différemment pour ${question.id}',
        );
        expect(restored.runtimeType, question.runtimeType);
      }
    });

    test('the type discriminator selects the right model', () {
      for (final question in questions) {
        final json = question.toJson();
        expect(json['type'], isA<String>());

        // Without the discriminator, the mode still decodes the question: a bank
        // written before the field trusted the mode alone.
        final jsonWithoutType = Map<String, dynamic>.from(json)..remove('type');
        expect(BaseQuestion.fromJson(jsonWithoutType), question);
      }
    });
  });

  group('InMemoryQuestionRepository', () {
    // Built on first use: the bank is only read once setUpAll has run.
    late final repository = InMemoryQuestionRepository(questions);

    test('returns every question', () {
      expect(repository.getAllQuestions().length, questions.length);
    });

    test('filters by mode', () {
      for (final mode in GameMode.values) {
        final filtered = repository.getQuestionsByMode(mode);
        expect(filtered.isNotEmpty, isTrue);
        expect(filtered.every((q) => q.mode == mode), isTrue);
      }
    });

    test('filters by category and difficulty', () {
      final geography = repository.getQuestionsByCategory(
        QuestionCategory.geography,
      );
      expect(geography.isNotEmpty, isTrue);
      expect(
        geography.every((q) => q.category == QuestionCategory.geography),
        isTrue,
      );

      final hard = repository.getQuestionsByDifficulty(Difficulty.hard);
      expect(hard.isNotEmpty, isTrue);
      expect(hard.every((q) => q.difficulty == Difficulty.hard), isTrue);
    });

    test('looks a question up by id', () {
      final first = questions.first;
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
      expect(
        repository.getQuestionsByFactGroupId(sharedGroup).length,
        greaterThan(1),
      );
    });

    test('returns an empty list for an unknown fact group', () {
      expect(repository.getQuestionsByFactGroupId('inconnu'), isEmpty);
    });

    test('the exposed lists cannot be mutated', () {
      final list = repository.getAllQuestions();
      expect(() => list.add(list.first), throwsUnsupportedError);
    });
  });

  group('AssetQuestionRepository', () {
    test('loads the bank through the same path as the app', () async {
      final repository = await AssetQuestionRepository.load();

      expect(repository.getAllQuestions(), questions);
      for (final mode in GameMode.values) {
        expect(
          repository.getQuestionsByMode(mode).map((q) => q.id),
          questions.where((q) => q.mode == mode).map((q) => q.id).toList(),
        );
      }
    });

    test('skips an unreadable question instead of failing the load', () async {
      final valid = questions.firstWhere(
        (q) => q.mode == GameMode.whichCameFirst,
      );
      // A malformed entry: it carries no text, so it cannot be decoded. The
      // rest of the file is still served.
      final bundle = _StubAssetBundle({
        'assets/questions/which_came_first.json':
            '['
            '${jsonEncode({'type': 'whichCameFirst', 'id': 'cassée'})},'
            '${jsonEncode(valid.toJson())}]',
        'assets/questions/guess_the_country.json': '[]',
        'assets/questions/fact_or_cap.json': '[]',
        'assets/questions/put_in_order.json': '[]',
        'assets/questions/how_much.json': '[]',
      });

      final repository = await AssetQuestionRepository.load(bundle: bundle);

      expect(repository.getAllQuestions(), [valid]);
      expect(bundle.requested, containsAll(questionAssetPaths));
    });

    test('reports a missing file instead of serving a partial bank', () async {
      final bundle = _StubAssetBundle({
        'assets/questions/which_came_first.json': '[]',
      });

      await expectLater(
        AssetQuestionRepository.load(bundle: bundle),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}

/// Asset bundle that serves [contents] and throws for anything else, so the
/// loader can be exercised without the real assets.
class _StubAssetBundle extends CachingAssetBundle {
  final Map<String, String> contents;
  final List<String> requested = [];

  _StubAssetBundle(this.contents);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    requested.add(key);
    final content = contents[key];
    if (content == null) {
      throw FlutterError('Absent de la banque de test : $key');
    }
    return content;
  }

  @override
  Future<ByteData> load(String key) =>
      throw FlutterError('Absent de la banque de test : $key');
}
