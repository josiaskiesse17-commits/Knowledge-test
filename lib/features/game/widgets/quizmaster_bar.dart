import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Always-visible quizmaster controls on a phone: scores, question actions and
/// progression.
class QuizmasterBar extends StatelessWidget {
  final GameState state;
  final GameController controller;
  final void Function(String playerId) onAward;

  const QuizmasterBar({
    super.key,
    required this.state,
    required this.controller,
    required this.onAward,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final round = state.currentRound;
    final resolved = round?.isComplete ?? false;
    final isInvalidated = round?.isInvalidated ?? false;
    final isCompleted = state.isCompleted;

    return Material(
      elevation: 8,
      color: colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Scores — total ${state.totalScore}',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${state.resolvedQuestionCount}/${state.questions.length} notées',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              // The player cards scroll sideways, so the bar keeps a usable
              // height whatever the number of players.
              SizedBox(
                height: 76,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.players.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppDimensions.spacingSm),
                  itemBuilder: (context, index) {
                    final player = state.players[index];
                    final awarded = round?.awardsPointTo(player.id) ?? false;
                    return SizedBox(
                      width: 132,
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingSm,
                          vertical: AppDimensions.spacingXs,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    player.name.isEmpty
                                        ? 'Joueur'
                                        : player.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.labelMedium,
                                  ),
                                ),
                                Text(
                                  '${player.score}',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingXs),
                            if (awarded)
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () =>
                                    controller.undoAward(player.id),
                                child: const Text('Annuler'),
                              )
                            else
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: isInvalidated || isCompleted
                                    ? null
                                    : () => onAward(player.id),
                                child: const Text('Point'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.skip_next_outlined),
                      label: const Text('Passer'),
                      onPressed:
                          (resolved || isCompleted) ? null : controller.skip,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.block_outlined),
                      label: const Text('Invalider'),
                      onPressed: isCompleted ? null : controller.invalidate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              PrimaryButton(
                label: state.canEndSession
                    ? 'Terminer la session'
                    : 'Question suivante',
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
                              content: const Text(
                                'Notez, passez ou invalidez cette question '
                                'avant de continuer.',
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
      ),
    );
  }
}
