import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/solo_providers.dart';

/// Stored solo sessions, most recent first, with score, accuracy and question
/// count. Tap a session to open its summary; delete one or clear all with
/// confirmation.
class SoloHistoryScreen extends ConsumerWidget {
  const SoloHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(soloHistoryProvider);
    final notifier = ref.read(soloHistoryProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    // Load once on first read: the notifier keeps the list in memory
    // afterwards (guarded by hasLoaded so it does not re-trigger on rebuild).
    if (history.sessions.isEmpty &&
        !history.isLoading &&
        !history.loadFailed &&
        !notifier.hasLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.load();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.soloHistoryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.soloHistoryBackTooltip,
          onPressed: () => context.go(AppRoute.home.path),
        ),
        actions: [
          if (history.sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: l10n.soloHistoryClearTooltip,
              onPressed: () => _confirmClear(context, notifier, l10n),
            ),
        ],
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
              child: _buildBody(context, ref, history, notifier, l10n),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SoloHistoryState history,
    SoloHistoryNotifier notifier,
    AppLocalizations l10n,
  ) {
    if (history.isLoading && history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (history.isEmpty) {
      return _EmptyHistory(failed: history.loadFailed, l10n: l10n);
    }

    return RefreshIndicator(
      onRefresh: () => notifier.load(),
      child: ListView.separated(
        itemCount: history.sessions.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppDimensions.spacingSm),
        itemBuilder: (context, index) {
          final session = history.sessions[index];
          return _SessionTile(
            session: session,
            onTap: () =>
                context.push('${AppRoute.soloSummary.path}?id=${session.id}'),
            onDelete: () => _confirmDelete(context, notifier, session.id, l10n),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SoloHistoryNotifier notifier,
    String sessionId,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.soloHistoryDeleteDialogTitle),
        content: Text(l10n.soloHistoryDeleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.soloHistoryDeleteDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.soloHistoryDeleteDialogConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await notifier.deleteSoloSession(sessionId);
    }
  }

  Future<void> _confirmClear(
    BuildContext context,
    SoloHistoryNotifier notifier,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.soloHistoryClearDialogTitle),
        content: Text(l10n.soloHistoryClearDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.soloHistoryClearDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.soloHistoryClearDialogConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await notifier.clearSoloSessions();
    }
  }
}

class _SessionTile extends StatelessWidget {
  final SoloSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionTile({
    required this.session,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final accuracy = SoloRulesAccuracy.accuracy(session);

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              '${session.answeredCount}',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.DateFormat.yMd(l10n.localeName)
                      .add_jm()
                      .format(session.completedAt ?? DateTime.now()),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.soloScore(session.score)} \u2022 ${l10n.soloHistoryAccuracy} ${accuracy.toInt()}% \u2022 ${l10n.soloHistoryQuestions(session.answeredCount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.soloHistoryDeleteSessionTooltip,
            onPressed: onDelete,
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
            size: AppDimensions.iconMd,
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool failed;
  final AppLocalizations l10n;

  const _EmptyHistory({required this.failed, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            ),
            child: Icon(
              Icons.history_outlined,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            failed ? l10n.soloHistoryUnavailable : l10n.soloHistoryNoSessions,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            failed
                ? l10n.soloHistoryUnavailableMessage
                : l10n.soloHistoryEmptyMessage,
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
    );
  }
}

/// Computes the overall accuracy of a [SoloSession] without importing
/// [SoloRules] into the tile (keeps the tile a pure StatelessWidget).
class SoloRulesAccuracy {
  SoloRulesAccuracy._();

  static int accuracy(SoloSession session) {
    if (session.answeredCount == 0) return 0;
    return (session.correctCount / session.answeredCount * 100).round();
  }
}
