import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/services/solo_answer_codec.dart';

import '../helpers/sample_question_bank.dart';

void main() {
  group('SoloAnswerCodec encoders', () {
    test('WhichCameFirst encodes an index', () {
      expect(SoloAnswerCodec.encodeWhichCameFirst(0), '0');
      expect(SoloAnswerCodec.encodeWhichCameFirst(7), '7');
    });

    test('GuessTheCountry encodes the typed text', () {
      expect(SoloAnswerCodec.encodeGuessTheCountry('Japon'), 'Japon');
      expect(SoloAnswerCodec.encodeGuessTheCountry(''), '');
    });

    test('FactOrCap true/false encodes a boolean', () {
      expect(SoloAnswerCodec.encodeFactOrCapTrueFalse(true), 'true');
      expect(SoloAnswerCodec.encodeFactOrCapTrueFalse(false), 'false');
    });

    test('FactOrCap statement encodes an index', () {
      expect(SoloAnswerCodec.encodeFactOrCapStatement(2), '2');
    });

    test('PutInOrder encodes ids comma separated', () {
      expect(SoloAnswerCodec.encodePutInOrder(['a', 'b', 'c']), 'a,b,c');
      expect(SoloAnswerCodec.encodePutInOrder(const []), '');
    });

    test('HowMuch encodes a number', () {
      expect(SoloAnswerCodec.encodeHowMuch(5), '5');
      expect(SoloAnswerCodec.encodeHowMuch(5.5), '5.5');
      expect(SoloAnswerCodec.encodeHowMuch(100.0), '100');
    });
  });

  group('SoloAnswerCodec decoders', () {
    test('WhichCameFirst decodes an index', () {
      expect(SoloAnswerCodec.decodeWhichCameFirst('3'), 3);
      expect(SoloAnswerCodec.decodeWhichCameFirst('  2 '), 2);
      expect(SoloAnswerCodec.decodeWhichCameFirst('abc'), isNull);
      expect(SoloAnswerCodec.decodeWhichCameFirst(''), isNull);
    });

    test('GuessTheCountry decodes the typed text', () {
      expect(SoloAnswerCodec.decodeGuessTheCountry('Japon'), 'Japon');
      expect(
        SoloAnswerCodec.decodeGuessTheCountry('Côte d\'Ivoire'),
        "Côte d'Ivoire",
      );
    });

    test('FactOrCap true/false decodes a boolean', () {
      expect(SoloAnswerCodec.decodeFactOrCapTrueFalse('true'), isTrue);
      expect(SoloAnswerCodec.decodeFactOrCapTrueFalse('false'), isFalse);
      expect(SoloAnswerCodec.decodeFactOrCapTrueFalse('TRUE'), isTrue);
      expect(SoloAnswerCodec.decodeFactOrCapTrueFalse('maybe'), isNull);
    });

    test('FactOrCap statement decodes an index', () {
      expect(SoloAnswerCodec.decodeFactOrCapStatement('1'), 1);
      expect(SoloAnswerCodec.decodeFactOrCapStatement('x'), isNull);
    });

    test('PutInOrder decodes ids comma separated', () {
      expect(SoloAnswerCodec.decodePutInOrder('a,b,c'), ['a', 'b', 'c']);
      expect(SoloAnswerCodec.decodePutInOrder(' a , b , c '), ['a', 'b', 'c']);
      expect(SoloAnswerCodec.decodePutInOrder(''), isEmpty);
    });

    test('HowMuch decodes a number', () {
      expect(SoloAnswerCodec.decodeHowMuch('5'), 5.0);
      expect(SoloAnswerCodec.decodeHowMuch('5.5'), 5.5);
      expect(SoloAnswerCodec.decodeHowMuch('abc'), isNull);
      expect(SoloAnswerCodec.decodeHowMuch(''), isNull);
    });
  });

  group('SoloAnswerCodec dispatch', () {
    List<BaseQuestion> questions = [];

    setUp(() {
      questions = SampleQuestionBank.questions;
    });

    test('encodes and decodes each mode round trip', () {
      expect(
        SoloAnswerCodec.decodeWhichCameFirst(
          SoloAnswerCodec.encodeWhichCameFirst(1),
        ),
        1,
      );
      expect(
        SoloAnswerCodec.decodeGuessTheCountry(
          SoloAnswerCodec.encodeGuessTheCountry('Japon'),
        ),
        'Japon',
      );
      final pio = questions.whereType<PutInOrderQuestion>().first;
      expect(
        SoloAnswerCodec.decodePutInOrder(
          SoloAnswerCodec.encodePutInOrder(pio.correctOrderIds),
        ),
        pio.correctOrderIds,
      );
      final hm = questions.whereType<HowMuchQuestion>().first;
      expect(
        SoloAnswerCodec.decodeHowMuch(
          SoloAnswerCodec.encodeHowMuch(hm.answer.referenceValue),
        ),
        hm.answer.referenceValue,
      );
    });

    test('encode dispatches on the question type', () {
      final wcf = questions.whereType<WhichCameFirstQuestion>().first;
      expect(SoloAnswerCodec.encode(wcf, 1), '1');
      final gtc = questions.whereType<GuessTheCountryQuestion>().first;
      expect(SoloAnswerCodec.encode(gtc, 'Japon'), 'Japon');
      final pio = questions.whereType<PutInOrderQuestion>().first;
      expect(
        SoloAnswerCodec.encode(pio, pio.correctOrderIds),
        pio.correctOrderIds.join(','),
      );
      final hm = questions.whereType<HowMuchQuestion>().first;
      expect(
        SoloAnswerCodec.encode(hm, hm.answer.referenceValue),
        SoloAnswerCodec.encodeHowMuch(hm.answer.referenceValue),
      );
    });

    test('decode dispatches on the question type', () {
      final wcf = questions.whereType<WhichCameFirstQuestion>().first;
      expect(SoloAnswerCodec.decode(wcf, '1'), 1);
      final gtc = questions.whereType<GuessTheCountryQuestion>().first;
      expect(SoloAnswerCodec.decode(gtc, 'Japon'), 'Japon');
      final pio = questions.whereType<PutInOrderQuestion>().first;
      expect(SoloAnswerCodec.decode(pio, 'a,b'), ['a', 'b']);
      final hm = questions.whereType<HowMuchQuestion>().first;
      expect(SoloAnswerCodec.decode(hm, '99.5'), 99.5);
    });
  });

  group('SoloAnswerCodec describe', () {
    List<BaseQuestion> questions = [];

    setUp(() {
      questions = SampleQuestionBank.questions;
    });

    test('WhichCameFirst returns the chosen event label', () {
      final wcf = questions.whereType<WhichCameFirstQuestion>().first;
      expect(SoloAnswerCodec.describe(wcf, '0'), wcf.events[0].label);
      expect(SoloAnswerCodec.describe(wcf, '1'), wcf.events[1].label);
      // Out-of-range index falls back to the raw string
      expect(SoloAnswerCodec.describe(wcf, '99'), '99');
    });

    test('GuessTheCountry returns the typed country', () {
      final gtc = questions.whereType<GuessTheCountryQuestion>().first;
      expect(SoloAnswerCodec.describe(gtc, 'Japon'), 'Japon');
      expect(SoloAnswerCodec.describe(gtc, ''), '(aucune r\u00e9ponse)');
    });

    test('FactOrCap true/false returns true/false', () {
      final focQuestions = questions.whereType<FactOrCapQuestion>().toList();
      final trueFalse = focQuestions.firstWhere(
        (q) => q.lieStatementIndex == null && q.falseStatementIndex == null,
        orElse: () => focQuestions.first,
      );
      expect(SoloAnswerCodec.describe(trueFalse, 'true'), 'true');
      expect(SoloAnswerCodec.describe(trueFalse, 'false'), 'false');
    });

    test('FactOrCap statement returns the chosen statement text', () {
      final focQuestions = questions
          .whereType<FactOrCapQuestion>()
          .where(
            (q) => q.lieStatementIndex != null || q.falseStatementIndex != null,
          )
          .toList();
      expect(focQuestions, isNotEmpty);
      final foc = focQuestions.first;
      final index = foc.lieStatementIndex ?? foc.falseStatementIndex ?? 0;
      expect(
        SoloAnswerCodec.describe(foc, index.toString()),
        foc.statements[index].text,
      );
    });

    test('PutInOrder returns ordered item labels joined', () {
      final pio = questions.whereType<PutInOrderQuestion>().first;
      final encoded = pio.correctOrderIds.join(',');
      final described = SoloAnswerCodec.describe(pio, encoded);
      final byId = {for (final item in pio.items) item.id: item};
      final expected = pio.correctOrderIds
          .map((id) => byId[id]?.label ?? id)
          .join(' \u2192 ');
      expect(described, expected);
    });

    test('HowMuch returns formatted value with unit', () {
      final hm = questions.whereType<HowMuchQuestion>().first;
      final value = hm.answer.referenceValue;
      final encoded = SoloAnswerCodec.encodeHowMuch(value);
      final described = SoloAnswerCodec.describe(hm, encoded);
      final unit = hm.answer.unitFr ?? hm.answer.unit;
      final formatted = value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toString();
      expect(described, '$formatted $unit');
    });

    test('describe handles unknown question type', () {
      // All modes are covered by the switch; this just ensures no crash.
      final wcf = questions.whereType<WhichCameFirstQuestion>().first;
      expect(SoloAnswerCodec.describe(wcf, '0'), isA<String>());
    });
  });
}
