import 'package:knowledge_test/models/questions/index.dart';

/// Encodes a user interaction into the answer string understood by
/// [SoloRules.checkAnswer], and decodes a stored answer string back into a
/// typed value.
///
/// The UI never builds these strings by hand: it calls the encoder that
/// matches the current question mode, and the decoder when restoring an
/// answered question from history.
class SoloAnswerCodec {
  const SoloAnswerCodec._();

  // ---------------------------------------------------------------------------
  // Encoders: user interaction -> answer string
  // ---------------------------------------------------------------------------

  /// WhichCameFirst: index of the event the player thinks came first.
  static String encodeWhichCameFirst(int index) => index.toString();

  /// FactOrCap true/false: whether the single statement is true.
  static String encodeFactOrCapTrueFalse(bool isTrue) =>
      isTrue ? 'true' : 'false';

  /// FactOrCap statement modes: index of the statement the player marks false.
  static String encodeFactOrCapStatement(int index) => index.toString();

  /// PutInOrder: the question ids in the player's order, comma separated.
  static String encodePutInOrder(List<String> orderedIds) =>
      orderedIds.join(',');

  /// GuessTheCountry: the country name typed by the player.
  static String encodeGuessTheCountry(String text) => text;

  /// HowMuch: the numeric value typed by the player.
  static String encodeHowMuch(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  // ---------------------------------------------------------------------------
  // Decoders: answer string -> typed value (null when unreadable)
  // ---------------------------------------------------------------------------

  static int? decodeWhichCameFirst(String s) => int.tryParse(s.trim());

  static bool? decodeFactOrCapTrueFalse(String s) {
    final u = s.trim().toLowerCase();
    if (u == 'true') return true;
    if (u == 'false') return false;
    return null;
  }

  static int? decodeFactOrCapStatement(String s) => int.tryParse(s.trim());

  static List<String> decodePutInOrder(String s) =>
      s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  static String decodeGuessTheCountry(String s) => s;

  static double? decodeHowMuch(String s) => double.tryParse(s.trim());

  /// Encodes the answer for any mode, dispatching on [question].
  static String encode(BaseQuestion question, Object value) {
    switch (question) {
      case WhichCameFirstQuestion():
        return encodeWhichCameFirst(value as int);
      case GuessTheCountryQuestion():
        return encodeGuessTheCountry(value as String);
      case FactOrCapQuestion():
        if (question.lieStatementIndex != null ||
            question.falseStatementIndex != null) {
          return encodeFactOrCapStatement(value as int);
        }
        return encodeFactOrCapTrueFalse(value as bool);
      case PutInOrderQuestion():
        return encodePutInOrder(value as List<String>);
      case HowMuchQuestion():
        return encodeHowMuch(value as double);
    }
    throw ArgumentError('Unsupported question type: ${question.runtimeType}');
  }

  /// Decodes the stored answer string for [question] into a typed value.
  static Object? decode(BaseQuestion question, String s) {
    switch (question) {
      case WhichCameFirstQuestion():
        return decodeWhichCameFirst(s);
      case GuessTheCountryQuestion():
        return decodeGuessTheCountry(s);
      case FactOrCapQuestion():
        if (question.lieStatementIndex != null ||
            question.falseStatementIndex != null) {
          return decodeFactOrCapStatement(s);
        }
        return decodeFactOrCapTrueFalse(s);
      case PutInOrderQuestion():
        return decodePutInOrder(s);
      case HowMuchQuestion():
        return decodeHowMuch(s);
    }
    throw ArgumentError('Unsupported question type: ${question.runtimeType}');
  }
}
