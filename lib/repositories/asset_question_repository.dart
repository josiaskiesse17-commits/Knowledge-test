import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';
import 'package:knowledge_test/repositories/question_repository.dart';

/// [QuestionRepository] backed by the JSON question bank shipped in the assets.
///
/// The questions are loaded once, when the repository is created: everything
/// after that is served from memory like [InMemoryQuestionRepository], which
/// this class reuses for its indexes.
///
/// Loading is defensive about individual questions: one unreadable entry is
/// skipped and reported instead of taking the whole library down, which is what
/// keeps a hand-edited bank from bricking the app. A missing or unreadable file
/// is different: the caller cannot serve a question list that silently lost a
/// whole mode, so [load] throws and the UI shows its error state.
class AssetQuestionRepository extends InMemoryQuestionRepository {
  AssetQuestionRepository._(super.questions);

  /// Reads every question asset and decodes it into a repository.
  ///
  /// [bundle] can be replaced in tests to read the assets from another source.
  static Future<AssetQuestionRepository> load({AssetBundle? bundle}) async {
    final assets = bundle ?? rootBundle;
    final questions = <BaseQuestion>[];

    for (final path in questionAssetPaths) {
      final entries = await _decodeFile(assets, path);
      for (final entry in entries) {
        try {
          questions.add(BaseQuestion.fromJson(entry));
        } catch (error, stack) {
          debugPrint('Question ignorée dans $path : $error\n$stack');
        }
      }
    }

    return AssetQuestionRepository._(questions);
  }

  /// Decodes one asset file, failing loudly when the file itself is unreadable.
  static Future<List<Map<String, dynamic>>> _decodeFile(
    AssetBundle assets,
    String path,
  ) async {
    final raw = await assets.loadString(path);
    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw FormatException('$path ne contient pas une liste de questions.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }
}

/// Asset path of every question file, in the order the game modes are declared.
///
/// The `type` field of each entry decides which model decodes it, so a file
/// could hold several modes without a change here.
const List<String> questionAssetPaths = [
  'assets/questions/which_came_first.json',
  'assets/questions/guess_the_country.json',
  'assets/questions/fact_or_cap.json',
  'assets/questions/put_in_order.json',
  'assets/questions/how_much.json',
];
