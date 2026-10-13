import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';
import 'package:knowledge_test/features/game/widgets/question_body.dart';
import 'package:knowledge_test/features/game/widgets/scoreboard.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    if (state.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // The router may be absent when the screen is hosted on its own.
        if (GoRouter.maybeOf(context) == null) return;
        context.go(AppRoute.finalRanking.path);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = state.currentQuestion;
    final round = state.currentRound;
    if (!state.hasQuestions || question == null || round == null) {
      return _EmptySession(onBack: () => context.go(AppRoute.gameSetup.path));
    }

    // A desktop window is wide enough to show the question next to the scores;
    // a phone or a tablet keeps the controls under the question so they stay
    // reachable with a thumb.
    final isWide = AppBreakpoints.sizeOf(MediaQuery.sizeOf(context).width) ==
        ScreenSize.desktop;

    Future<void> awardTo(String playerId) =>
        _awardPoint(context, controller, question, playerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(question.mode.displayNameFr),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Quitter la session',
          onPressed: () => _confirmQuit(context, controller),
        ),
        actions: [
          if (state.isPaused)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Reprendre',
              onPressed: controller.resume,
            )
          else if (state.isActive)
            IconButton(
              icon: const Icon(Icons.pause),
              tooltip: 'Mettre en pause',
              onPressed: controller.pause,
            ),
        ],
      ),
      body: SafeArea(
        child: isWide
            ? _WideGameLayout(
                state: state,
                controller: controller,
                onAward: awardTo,
              )
            : _PhoneGameLayout(
                state: state,
                controller: controller,
              ),
      ),
      bottomNavigationBar: isWide
          ? null
          : _QuizmasterBar(
              state: state,
              controller: controller,
              onAward: awardTo,
            ),
    );
  }

  Future<void> _awardPoint(
    BuildContext context,
    GameController controller,
    BaseQuestion question,
    String playerId,
  ) async {
    List<String>? announcedOrder;
    if (question is PutInOrderQuestion) {
      announcedOrder = await OrderVerificationDialog.show(context, question);
      if (announcedOrder == null) return;
    }

    final result = controller.awardPoint(playerId, announcedOrder: announcedOrder);
    if (!context.mounted) return;
    if (result != AwardResult.awarded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.messageFr),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _confirmQuit(BuildContext context, GameController controller) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quitter la session ?'),
        content: const Text('La progression et les scores seront perdus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Rester'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );

    if (leave != true || !context.mounted) return;
    // A session left behind is abandoned: it must not appear in the history as
    // a completed one.
    controller.abandon();
    context.go(AppRoute.home.path);
  }
}

/// Phone and tablet layout: the question scrolls above the controls.
class _PhoneGameLayout extends StatelessWidget {
  final GameState state;
  final GameController controller;

  const _PhoneGameLayout({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion!;
    final round = state.currentRound!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
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
          if (state.isPaused) _PausedNotice(state: state),
          if (state.timeExpired) const _TimeExpiredNotice(),
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
      ),
    );
  }
}

/// Desktop layout: question on the left, scores and controls on the right.
class _WideGameLayout extends StatelessWidget {
  final GameState state;
  final GameController controller;
  final ValueChanged<String> onAward;

  const _WideGameLayout({
    required this.state,
    required this.controller,
    required this.onAward,
  });

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion!;
    final round = state.currentRound!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    // A very wide window keeps the panel at a readable width instead of
    // stretching it across the screen.
    final panelWidth = screenWidth > 1600 ? 420.0 : 360.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Column(
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
                if (state.isPaused) _PausedNotice(state: state),
                if (state.timeExpired) const _TimeExpiredNotice(),
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
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        SizedBox(
          width: panelWidth,
          child: _QuizmasterPanel(
            state: state,
            controller: controller,
            onAward: onAward,
          ),
        ),
      ],
    );
  }
}

/// Session notices shown above the question.
class _PausedNotice extends StatelessWidget {
  final GameState state;

  const _PausedNotice({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: AppCard(
        color: colorScheme.tertiaryContainer,
        child: Row(
          children: [
            Icon(Icons.pause_circle_outlined,
                color: colorScheme.onTertiaryContainer),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                state.isTimedSession
                    ? 'Session en pause. Le chronomètre est arrêté.'
                    : 'Session en pause.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeExpiredNotice extends StatelessWidget {
  const _TimeExpiredNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: AppCard(
        color: colorScheme.errorContainer,
        child: Row(
          children: [
            Icon(Icons.timer_off_outlined,
                color: colorScheme.onErrorContainer),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                'Temps écoulé. Terminez cette question, puis la session s\'arrêtera.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical quizmaster controls for a wide window.
class _QuizmasterPanel extends StatelessWidget {
  final GameState state;
  final GameController controller;
  final ValueChanged<String> onAward;

  const _QuizmasterPanel({
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
                icon: state.canEndSession ? Icons.flag_outlined : Icons.arrow_forward,
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
      ],
    );
  }
}

/// Always-visible quizmaster controls on a phone: scores, question actions and
/// progression.
class _QuizmasterBar extends StatelessWidget {
  final GameState state;
  final GameController controller;
  final void Function(String playerId) onAward;

  const _QuizmasterBar({
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

class _EmptySession extends StatelessWidget {
  final VoidCallback onBack;

  const _EmptySession({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              Text(
                'Aucune session en cours.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              PrimaryButton(
                label: 'Configurer une partie',
                icon: Icons.settings_outlined,
                onPressed: onBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
