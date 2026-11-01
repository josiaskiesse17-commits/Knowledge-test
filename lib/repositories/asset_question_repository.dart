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
/// Loading is defensive about individual questions: one unreadable entry, or
/// one whose review status is not served, is skipped and recorded in
/// [loadErrors] instead of taking the whole library down. A missing or
/// unreadable file is different: the caller cannot serve a question list that
/// silently lost a whole mode, so [load] throws and the UI shows its error
/// state.
///
/// Only [ContentReviewStatus.approved] and [ContentReviewStatus.reviewed]
/// questions are served: `draft` and `deprecated` questions are skipped and
/// reported, so unreviewed facts never reach a game.
class AssetQuestionRepository extends InMemoryQuestionRepository {
  AssetQuestionRepository._(super.questions, this.loadErrors);

  /// Questions skipped while loading, with the asset path and the reason, so
  /// tests (and the startup UI) can assert that no question disappears silently.
  final List<QuestionLoadError> loadErrors;

  /// Reads every question asset and decodes it into a repository.
  ///
  /// [bundle] can be replaced in tests to read the assets from another source.
  static Future<AssetQuestionRepository> load({AssetBundle? bundle}) async {
    final assets = bundle ?? rootBundle;
    final questions = <BaseQuestion>[];
    final errors = <QuestionLoadError>[];

    for (final path in questionAssetPaths) {
      final entries = await _decodeFile(assets, path);
      for (final entry in entries) {
        try {
          final question = BaseQuestion.fromJson(entry);
          if (_isServable(question)) {
            questions.add(question);
          } else {
            errors.add(
              QuestionLoadError(
                path,
                question.id,
                'review status ${question.reviewStatus.name} is not served',
              ),
            );
          }
        } catch (error, stack) {
          final failedId = entry['id'] as String?;
          errors.add(
            QuestionLoadError(path, failedId ?? '<unknown>', '$error'),
          );
          debugPrint('Question ignorée dans $path : $error\n$stack');
        }
      }
    }

    return AssetQuestionRepository._(questions, errors);
  }

  /// Whether a question may be served to players: approved or reviewed only.
  static bool _isServable(BaseQuestion question) =>
      question.reviewStatus == ContentReviewStatus.approved ||
      question.reviewStatus == ContentReviewStatus.reviewed;

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

    return decoded.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}

/// One question skipped while loading the bank.
class QuestionLoadError {
  /// The asset file the entry was read from.
  final String path;

  /// The question id, when it could be read, otherwise `'<unknown>'`.
  final String id;

  /// Why the entry was skipped.
  final String reason;

  const QuestionLoadError(this.path, this.id, this.reason);

  @override
  String toString() =>
      'QuestionLoadError(path: $path, id: $id, reason: $reason)';
}

/// Asset path of every question file, in the order the game modes are declared.
///
/// The `type` field of each entry decides which model decodes it, so a file
/// could hold several modes without a change here.
///
/// Adding a file here is the single source of truth for batch loading: every
/// file in `assets/questions/` must be listed, and a test asserts exactly that.
const List<String> questionAssetPaths = [
  'assets/questions/which_came_first.json',
  'assets/questions/guess_the_country.json',
  'assets/questions/fact_or_cap.json',
  'assets/questions/put_in_order.json',
  'assets/questions/how_much.json',
];
