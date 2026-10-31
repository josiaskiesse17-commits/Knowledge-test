import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_colors.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Live scoreboard: each player can receive one point for the current question.
class Scoreboard extends StatelessWidget {
  final GameState state;
  final void Function(String playerId) onAward;
  final void Function(String playerId) onUndo;

  const Scoreboard({
    super.key,
    required this.state,
    required this.onAward,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final round = state.currentRound;
    final question = state.currentQuestion;
    final isOrdering = question is PutInOrderQuestion;
    final isInvalidated = round?.isInvalidated ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCardHeader(
          title: l10n.gameBoardHeaderTitle,
          subtitle: round == null
              ? null
              : l10n.gameBoardHeaderSubtitle(round.awardedPlayerIds.length),
          leadingIcon: Icons.leaderboard_outlined,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        for (final player in state.players)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingSm,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      _initials(player.name),
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      player.name.isEmpty
                          ? l10n.sessionHistoryPlayerFallback
                          : player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingXs),
                  Text(
                    '${player.score}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingXs),
                  if (round != null && round.awardsPointTo(player.id))
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.undo),
                      tooltip: l10n.gameBoardUndoTooltip,
                      onPressed: () => onUndo(player.id),
                    )
                  else
                    Flexible(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.add, size: AppDimensions.iconSm),
                        label: Text(
                          isOrdering
                              ? l10n.gameBoardAwardOrdering
                              : l10n.gameBarAwardPoint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacingSm,
                          ),
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: isInvalidated || state.isCompleted
                            ? null
                            : () => onAward(player.id),
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (isInvalidated)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
            child: Text(
              l10n.gameBoardInvalidatedMessage,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
        if (isOrdering && !isInvalidated)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
            child: Text(
              l10n.gameBoardOrderExactMessage,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  static String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}

/// Status of the current question, so the quizmaster sees what has been scored.
class QuestionStatusBadge extends StatelessWidget {
  final RoundState? round;
  final int questionNumber;
  final int questionCount;
  final bool isTimed;
  final String remainingTime;

  const QuestionStatusBadge({
    super.key,
    required this.round,
    required this.questionNumber,
    required this.questionCount,
    required this.isTimed,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final (String label, Color color, IconData icon) = _resolveStatus(
      round?.outcome,
      l10n,
      colorScheme,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gameBoardQuestionNumber(questionNumber, questionCount),
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingXs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _StatusPill(label: label, color: color, icon: icon),
            if (isTimed)
              _StatusPill(
                label: l10n.gameBoardTimeRemaining(remainingTime),
                color: colorScheme.secondary,
                icon: Icons.timer_outlined,
              ),
          ],
        ),
      ],
    );
  }

  static (String, Color, IconData) _resolveStatus(
    QuestionOutcome? outcome,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    switch (outcome) {
      case QuestionOutcome.scored:
        return (
          l10n.sessionOutcomeScored,
          AppColors.success,
          Icons.check_circle_outline,
        );
      case QuestionOutcome.skipped:
        return (
          l10n.sessionOutcomeSkipped,
          AppColors.warning,
          Icons.skip_next_outlined,
        );
      case QuestionOutcome.invalidated:
        return (
          l10n.sessionOutcomeInvalidated,
          colorScheme.error,
          Icons.block_outlined,
        );
      default:
        return (
          l10n.gameBoardStatusPending,
          colorScheme.primary,
          Icons.play_circle_outline,
        );
    }
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusPill({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSm, color: color),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Asks the quizmaster for the announced order of an ordering question before a
/// point can be awarded.
class OrderVerificationDialog extends StatefulWidget {
  final List<OrderableItem> items;

  const OrderVerificationDialog({super.key, required this.items});

  static Future<List<String>?> show(
    BuildContext context,
    PutInOrderQuestion question,
  ) {
    return showDialog<List<String>>(
      context: context,
      builder: (_) => OrderVerificationDialog(items: question.items),
    );
  }

  @override
  State<OrderVerificationDialog> createState() =>
      _OrderVerificationDialogState();
}

class _OrderVerificationDialogState extends State<OrderVerificationDialog> {
  final List<String> _picked = [];

  List<OrderableItem> get _remaining =>
      widget.items.where((i) => !_picked.contains(i.id)).toList()
        ..sort((a, b) => a.id.compareTo(b.id));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.gameOrderDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.gameOrderDialogInstruction,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                l10n.gameOrderDialogSelectedTitle,
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              if (_picked.isEmpty)
                Text(
                  l10n.gameOrderDialogNoSelection,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              for (var i = 0; i < _picked.length; i++)
                Builder(
                  builder: (context) {
                    final item = widget.items.firstWhere(
                      (it) => it.id == _picked[i],
                    );
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        '${i + 1}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      title: Text(item.label),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: AppDimensions.iconSm,
                        ),
                        tooltip: l10n.gameOrderDialogRemoveTooltip,
                        onPressed: () => setState(() => _picked.removeAt(i)),
                      ),
                    );
                  },
                ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                l10n.gameOrderDialogRemainingTitle,
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              for (final item in _remaining)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingXs,
                  ),
                  child: OutlinedButton(
                    onPressed: () => setState(() => _picked.add(item.id)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(item.label),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.gameOrderDialogCancel),
        ),
        FilledButton(
          onPressed: _picked.length == widget.items.length
              ? () => Navigator.of(context).pop(_picked)
              : null,
          child: Text(l10n.gameOrderDialogConfirm),
        ),
      ],
    );
  }
}

/// Formats a duration as mm:ss.
String formatClock(int? seconds) => GameRules.formatDuration(seconds);
