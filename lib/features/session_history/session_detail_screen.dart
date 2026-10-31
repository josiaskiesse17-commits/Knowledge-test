import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_colors.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/repositories/question_repository.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Details of one saved session: settings, final ranking and questions played.
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(sessionHistoryProvider);
    final repository = ref.watch(questionRepositoryProvider);
    final session = history.sessions
        .where((s) => s.id == sessionId)
        .firstOrNull;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sessionDetailTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.sessionDetailBackTooltip,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppBreakpoints.contentMaxWidth(
                AppBreakpoints.sizeOf(MediaQuery.sizeOf(context).width),
              ),
            ),
            child: session == null
                ? const _MissingSession()
                : _SessionDetailContent(
                    session: session,
                    repository: repository,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SessionDetailContent extends StatelessWidget {
  final GameSession session;
  final QuestionRepository repository;

  const _SessionDetailContent({
    required this.session,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final settings = session.settings;
    final rankings = GameRules.rankingsOf(session.players);

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.DateFormat.yMd(l10n.localeName)
                    .add_jm()
                    .format(session.createdAt),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                _settingsSummary(l10n, settings),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        AppCardHeader(
          title: l10n.sessionDetailFinalRanking,
          subtitle: l10n.sessionHistoryPlayers(session.players.length),
          leadingIcon: Icons.leaderboard_outlined,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        for (final entry in rankings)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: AppCard(
              color: entry.rank == 1
                  ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                  : null,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingSm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: entry.rank == 1
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      '${entry.rank}',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: entry.rank == 1
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: Text(
                      entry.player.name.isEmpty
                          ? l10n.sessionHistoryPlayerFallback
                          : entry.player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    l10n.sessionHistoryScore(entry.player.score),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (session.rounds.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
            child: Text(
              l10n.sessionDetailNoQuestions,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else ...[
          const SizedBox(height: AppDimensions.spacingMd),
          AppCardHeader(
            title: l10n.sessionDetailQuestionsPlayed,
            subtitle: l10n.sessionDetailQuestionCount(session.rounds.length),
            leadingIcon: Icons.quiz_outlined,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          for (final round in session.rounds)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: _PlayedQuestionRow(
                round: round,
                players: session.players,
                text: repository.getQuestionById(round.questionId)?.text ?? '',
                l10n: l10n,
              ),
            ),
        ],
        const SizedBox(height: AppDimensions.spacingMd),
        PrimaryButton(
          label: l10n.sessionDetailBackToHistory,
          icon: Icons.history_outlined,
          onPressed: () => context.go(AppRoute.sessionHistory.path),
        ),
      ],
    );
  }

  static String _settingsSummary(AppLocalizations l10n, GameSettings settings) {
    final parts = <String>[
      if (settings.timePerQuestion > 0)
        l10n.sessionSettingsTimed(settings.timePerQuestion)
      else
        l10n.sessionSettingsQuestions(settings.questionCount),
      l10n.sessionSettingsDifficulty(settings.difficulty),
      if (settings.category.isNotEmpty)
        l10n.sessionSettingsCategories(settings.category),
      if (settings.randomizeQuestions)
        l10n.sessionSettingsShuffled
      else
        l10n.sessionSettingsNotShuffled,
    ];
    return parts.join(' • ');
  }
}

class _PlayedQuestionRow extends StatelessWidget {
  final RoundResult round;
  final List<Player> players;
  final String text;
  final AppLocalizations l10n;

  const _PlayedQuestionRow({
    required this.round,
    required this.players,
    required this.text,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final winners = players
        .where((p) => round.awardedPlayerIds.contains(p.id))
        .map((p) => p.name.isEmpty ? l10n.sessionHistoryPlayerFallback : p.name)
        .toList();
    final (label, color) = _outcomeStyle(round.outcome, l10n, context);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${round.roundNumber}.',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  text.isEmpty ? l10n.sessionDetailQuestionRemoved : text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Wrap(
            spacing: AppDimensions.spacingSm,
            runSpacing: AppDimensions.spacingXs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (winners.isNotEmpty)
                Text(
                  l10n.sessionDetailPointsFor(winners.join(', ')),
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Outcome label with a color taken from the active theme, so it keeps its
  /// contrast in both light and dark mode.
  static (String, Color) _outcomeStyle(
    QuestionOutcome outcome,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    switch (outcome) {
      case QuestionOutcome.scored:
        return (l10n.sessionOutcomeScored, context.successColor);
      case QuestionOutcome.skipped:
        return (l10n.sessionOutcomeSkipped, context.warningColor);
      case QuestionOutcome.invalidated:
        return (l10n.sessionOutcomeInvalidated, context.errorColor);
      case QuestionOutcome.pending:
        return (
          l10n.sessionOutcomePending,
          Theme.of(context).colorScheme.onSurfaceVariant,
        );
    }
  }
}

class _MissingSession extends StatelessWidget {
  const _MissingSession();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.sessionDetailMissingTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              l10n.sessionDetailMissingMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            PrimaryButton(
              label: l10n.sessionDetailBackToHistory,
              icon: Icons.history_outlined,
              onPressed: () => context.go(AppRoute.sessionHistory.path),
            ),
          ],
        ),
      ),
    );
  }
}
