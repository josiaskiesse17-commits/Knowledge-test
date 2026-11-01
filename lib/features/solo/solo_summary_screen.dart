import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
import 'package:knowledge_test/services/solo_answer_codec.dart';
import 'package:knowledge_test/services/solo_rules.dart';

/// Real solo results screen.
///
/// Works from the just-finished session (no [sessionId]: reads the controller
/// state) and from a stored session opened from history ([sessionId] set:
/// reads [soloHistoryProvider]). Never displays raw encoded answers: player and
/// correct answers are rendered through [SoloAnswerCodec.describe].
class SoloSummaryScreen extends ConsumerWidget {
  final String? sessionId;

  const SoloSummaryScreen({super.key, this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final controllerState = ref.watch(soloControllerProvider);
    final history = ref.watch(soloHistoryProvider);

    SoloSession? session;
    bool fromHistory = false;
    final historySessionId = sessionId;
    if (historySessionId != null && historySessionId.isNotEmpty) {
      session = _sessionById(history.sessions, historySessionId);
      fromHistory = session != null;
    } else if (controllerState.isCompleted) {
      session = controllerState;
    }

    if (history.isLoading && session == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.soloSummaryTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoute.home.path),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (session == null) {
      return _MissingSession(l10n: l10n, fromHistory: fromHistory);
    }

    final mistakes = SoloRules.mistakes(session);
    final accuracy = SoloRules.overallAccuracy(session);
    final byCategory = SoloRules.accuracyByCategory(session);
    final config = session.config;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.soloSummaryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.soloBackHome,
          onPressed: () => context.go(AppRoute.home.path),
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
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.assessment_outlined,
                      size: 72,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      l10n.soloSummaryTitle,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),
                    _StatCard(
                      title: l10n.soloScore(session.score),
                      subtitle: l10n.soloSummaryMaxStreak(session.maxStreak),
                      icon: Icons.scoreboard_outlined,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _StatCard(
                      title: l10n.soloSummaryQuestionsPlayed(
                        session.answeredCount,
                      ),
                      subtitle: l10n.soloSummaryOverallAccuracy,
                      value: '${accuracy.toInt()}%',
                      icon: Icons.analytics_outlined,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),
                    _SectionTitle(title: l10n.soloSummaryPerCategory),
                    const SizedBox(height: AppDimensions.spacingSm),
                    if (byCategory.isEmpty)
                      Text(
                        l10n.soloSummaryNoMistakes,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else
                      ...byCategory.values.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spacingSm,
                          ),
                          child: _CategoryAccuracyRow(
                            entry: entry,
                            l10n: l10n,
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                        );
                      }),
                    const SizedBox(height: AppDimensions.spacingLg),
                    if (mistakes.isEmpty) ...[
                      Icon(
                        Icons.emoji_events,
                        size: 56,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      Text(
                        l10n.soloSummaryNoMistakes,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      _SectionTitle(title: l10n.soloSummaryMistakes),
                      const SizedBox(height: AppDimensions.spacingSm),
                      for (final mistake in mistakes)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spacingSm,
                          ),
                          child: _MistakeCard(
                            mistake: mistake,
                            session: session,
                            l10n: l10n,
                            textTheme: textTheme,
                            colorScheme: colorScheme,
                          ),
                        ),
                    ],
                    const SizedBox(height: AppDimensions.spacingLg),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: l10n.soloSummaryPlayAgain,
                            icon: Icons.replay,
                            onPressed: () => _playAgain(context, ref, config),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: SecondaryButton(
                            label: l10n.soloSummaryNewSoloSetup,
                            icon: Icons.tune,
                            onPressed: () =>
                                context.go(AppRoute.soloSetup.path),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    PrimaryButton(
                      label: l10n.soloBackHome,
                      icon: Icons.home,
                      onPressed: () => context.go(AppRoute.home.path),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _playAgain(BuildContext context, WidgetRef ref, SoloConfig config) {
    final notifier = ref.read(soloControllerProvider.notifier);
    notifier.start(config);
    if (GoRouter.maybeOf(context) == null) return;
    context.go(AppRoute.soloGame.path);
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? value;
  final IconData icon;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatCard({
    required this.title,
    required this.subtitle,
    this.value,
    required this.icon,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: AppDimensions.iconMd,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (value != null)
                    Text(
                      value!,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                    ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryAccuracyRow extends StatelessWidget {
  final SoloCategoryAccuracy entry;
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _CategoryAccuracyRow({
    required this.entry,
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = entry.category.localizedName(l10n);
    final percentage = entry.percentage.toInt();
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoryName,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              '${entry.correct}/${entry.total} ${l10n.soloHistoryQuestions(entry.total)}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: LinearProgressIndicator(
                value: entry.percentage / 100,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  final SoloMistake mistake;
  final SoloSession session;
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _MistakeCard({
    required this.mistake,
    required this.session,
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final question = _questionById(session.questions, mistake.questionId);
    final readableAnswer = question != null
        ? SoloAnswerCodec.describe(question, mistake.userAnswer)
        : mistake.userAnswer;

    return AppCard(
      color: colorScheme.errorContainer.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorScheme.error,
                  size: AppDimensions.iconMd,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mistake.questionText,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${mistake.difficulty.localizedName(l10n)} \u2022 ${mistake.category.localizedName(l10n)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _InfoRow(
              title: l10n.soloYourAnswer,
              value: readableAnswer.isEmpty
                  ? l10n.soloNoAnswer
                  : readableAnswer,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            _InfoRow(
              title: l10n.soloCorrectAnswer,
              value: mistake.correctAnswer,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                  size: AppDimensions.iconSm,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.soloExplanation,
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        question?.explanationFr ?? l10n.soloSummaryNoMistakes,
                        style: textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              '${l10n.soloSource} ${question?.sourceReference ?? ''}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _InfoRow({
    required this.title,
    required this.value,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MissingSession extends StatelessWidget {
  final AppLocalizations l10n;
  final bool fromHistory;

  const _MissingSession({required this.l10n, required this.fromHistory});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.soloSummaryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.home.path),
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
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 56,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  Text(
                    fromHistory
                        ? l10n.sessionDetailMissingTitle
                        : l10n.soloSummaryNoMistakes,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    fromHistory
                        ? l10n.sessionDetailMissingMessage
                        : l10n.emptySessionNoSession,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  PrimaryButton(
                    label: l10n.soloBackHome,
                    icon: Icons.home,
                    onPressed: () => context.go(AppRoute.home.path),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Finds a stored session by id, returning null when it is not in the list
/// (for instance after it was deleted or the history failed to load).
SoloSession? _sessionById(List<SoloSession> sessions, String id) {
  for (final s in sessions) {
    if (s.id == id) return s;
  }
  return null;
}

/// Finds a question by id within a session's stored questions. Stored sessions
/// keep the full question JSON, so questions that no longer exist in the bank
/// are still renderable; returns null when truly absent.
BaseQuestion? _questionById(List<BaseQuestion> questions, String id) {
  for (final q in questions) {
    if (q.id == id) return q;
  }
  return null;
}
