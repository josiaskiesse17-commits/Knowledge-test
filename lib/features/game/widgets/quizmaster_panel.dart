import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/features/game/widgets/scoreboard.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Vertical quizmaster controls for a wide window.
class QuizmasterPanel extends StatelessWidget {
  final GameState state;
  final GameController controller;
  final ValueChanged<String> onAward;

  const QuizmasterPanel({
    super.key,
    required this.state,
    required this.controller,
    required this.onAward,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final round = state.currentRound;
    final resolved = round?.isComplete ?? false;
    final isCompleted = state.isCompleted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.gameBarScoresTotal(state.totalScore),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                l10n.gameBarQuestionsResolved(
                  state.resolvedQuestionCount,
                  state.questions.length,
                ),
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Scoreboard(
            state: state,
            onAward: onAward,
            onUndo: controller.undoAward,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.skip_next_outlined),
                      label: Text(l10n.gameBarSkip),
                      onPressed: (resolved || isCompleted)
                          ? null
                          : controller.skip,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.block_outlined),
                      label: Text(l10n.gameBarInvalidate),
                      onPressed: isCompleted ? null : controller.invalidate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              PrimaryButton(
                label: state.canEndSession
                    ? l10n.gameBarEndSession
                    : l10n.gameBarNextQuestion,
                icon: state.canEndSession
                    ? Icons.flag_outlined
                    : Icons.arrow_forward,
                onPressed: isCompleted
                    ? null
                    : () {
                        final result = controller.next();
                        if (result == NextResult.roundIncomplete &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.gameBarSnackBarRoundIncomplete,
                              ),
                              backgroundColor: colorScheme.error,
                            ),
                          );
                        }
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
