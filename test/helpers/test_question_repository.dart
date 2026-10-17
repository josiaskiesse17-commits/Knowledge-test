import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/repositories/in_memory_question_repository.dart';
import 'package:knowledge_test/repositories/question_repository.dart';

import 'sample_question_bank.dart';

/// In-memory repository loaded with the sample question bank for tests.
final QuestionRepository sampleQuestionRepository =
    InMemoryQuestionRepository(SampleQuestionBank.questions);

/// Shared provider override for tests that need a question repository.
final Override testQuestionRepositoryOverride =
    questionRepositoryProvider.overrideWithValue(sampleQuestionRepository);
