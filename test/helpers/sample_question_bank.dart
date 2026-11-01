import 'dart:convert';
import 'dart:io';

import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/repositories/asset_question_repository.dart';

/// Single source of truth for the question bank.
///
/// This helper no longer hand-mirrors the JSON assets: every question is
/// decoded from the files in `assets/questions/`, so a bank change is made in
/// one place only (the JSON assets, listed in [questionAssetPaths]).
///
/// The getter is synchronous so existing tests keep using
/// `SampleQuestionBank.questions` without `await`: the assets are read once,
/// on first access, and cached.
class SampleQuestionBank {
  SampleQuestionBank._();

  static List<BaseQuestion>? _cache;

  /// Every question decoded from the JSON assets, in asset-file order.
  static List<BaseQuestion> get questions {
    _cache ??= _loadAll();
    return _cache!;
  }

  static List<BaseQuestion> _loadAll() {
    final questions = <BaseQuestion>[];
    for (final path in questionAssetPaths) {
      final file = File(path);
      if (!file.existsSync()) {
        throw StateError('Question asset missing: $path');
      }
      final entries = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      for (final entry in entries) {
        if (entry is Map<String, dynamic>) {
          questions.add(BaseQuestion.fromJson(entry));
        }
      }
    }
    return questions;
  }
}
