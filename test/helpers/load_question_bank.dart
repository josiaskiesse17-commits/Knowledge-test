import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/repositories/asset_question_repository.dart';

/// Loads the question bank exactly the way the app does: the JSON assets.
Future<List<BaseQuestion>> loadQuestionBank() async {
  final repository = await AssetQuestionRepository.load();
  return repository.getAllQuestions();
}
