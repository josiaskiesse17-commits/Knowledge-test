import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game/widgets/question_body.dart';
import 'package:knowledge_test/features/game/widgets/session_notices.dart';
import 'package:knowledge_test/features/game/widgets/scoreboard.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Everything the quizmaster reads about the current question: its status, the
/// session notices, the next clue and the question body itself.
class QuestionColumn extends StatelessWidget {
  final GameState state;
  final GameController controller;

  const QuestionColumn({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion!;
    final round = state.currentRound!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionStatusBadge(
          round: round,
          questionNumber: state.questionNumber,
          questionCount: state.questions.length,
          isTimed: state.isTimedSession,
          remainingTime: controller.formatRemainingTime(),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (state.isPaused) SessionNotices(state: state),
        if (state.timeExpired) const TimeExpiredNotice(),
        if (question is GuessTheCountryQuestion &&
            round.revealedClues < question.clues.length) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          SecondaryButton(
            label: 'Indice suivant (${round.revealedClues + 1}'
                '/${question.clues.length})',
            icon: Icons.lightbulb_outline,
            onPressed: controller.revealNextClue,
          ),
        ],
        QuestionBody(
          question: question,
          round: round,
          onRevealAnswer: controller.revealAnswer,
          onToggleExplanation: controller.revealExplanation,
        ),
      ],
    );
  }
}
