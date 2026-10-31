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
}
