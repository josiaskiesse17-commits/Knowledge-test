import 'package:knowledge_test/models/questions/index.dart';

abstract class QuestionRepository {
  List<BaseQuestion> getAllQuestions();
  List<BaseQuestion> getQuestionsByMode(GameMode mode);
  List<BaseQuestion> getQuestionsByCategory(QuestionCategory category);
  List<BaseQuestion> getQuestionsByDifficulty(Difficulty difficulty);
  BaseQuestion? getQuestionById(String id);
  List<String> getAllFactGroupIds();
  List<BaseQuestion> getQuestionsByFactGroupId(String factGroupId);
}