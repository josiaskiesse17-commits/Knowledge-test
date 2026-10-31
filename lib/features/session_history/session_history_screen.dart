import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/game_models.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';
import 'package:knowledge_test/services/session_history_service.dart';

/// Saved sessions, most recent first, with their final ranking.
class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(sessionHistoryProvider);
    final notifier = ref.read(sessionHistoryProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sessionHistoryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.sessionHistoryBackTooltip,
          onPressed: () => context.go(AppRoute.home.path),
        ),
        actions: [
          if (history.sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: l10n.sessionHistoryClearTooltip,
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
              child: _buildBody(context, ref, history),
            ),
          ),
        ),
      ),
      bottomNavigationBar: history.isEmpty || history.isLoading
          ? null
          : const _HistoryFooter(),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SessionHistoryState history,
  ) {
    if (history.isLoading && history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (history.isEmpty) {
      return _EmptyHistory(failed: history.loadFailed);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(sessionHistoryProvider.notifier).load(),
      child: ListView.separated(
        itemCount: history.sessions.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spacingSm),
        itemBuilder: (context, index) {
          final session = history.sessions[index];
          return _SessionTile(
            session: session,
            onTap: () => context.push(
              '${AppRoute.sessionDetail.path}?id=${session.id}',
            ),
            onDelete: () =>
                ref.read(sessionHistoryProvider.notifier).deleteSession(session.id),
          );
        },
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    SessionHistoryNotifier notifier,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sessionHistoryClearDialogTitle),
        content: Text(l10n.sessionHistoryClearDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.sessionHistoryClearDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.sessionHistoryClearDialogConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true) await notifier.clearHistory();
  }
}

class _SessionTile extends StatelessWidget {
  final GameSession session;
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
    final rankings = GameRules.rankingsOf(session.players);
    final winner = rankings.isEmpty ? null : rankings.first;

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
              '${session.rounds.length}',
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
                  SessionHistoryService.formatSessionDate(session.createdAt),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  winner == null
                      ? l10n.sessionHistoryNoPlayer
                      : '${winner.player.name.isEmpty
                              ? l10n.sessionHistoryPlayerFallback
                              : winner.player.name}'
                            ' — ${l10n.sessionHistoryScore(winner.player.score)}'
                            ' • ${l10n.sessionHistoryPlayers(session.players.length)}',
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
            tooltip: l10n.sessionHistoryDeleteSessionTooltip,
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

  const _EmptyHistory({required this.failed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
            failed
                ? l10n.sessionHistoryUnavailable
                : l10n.sessionHistoryNoSessions,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            failed
                ? l10n.sessionHistoryUnavailableMessage
                : l10n.sessionHistoryEmptyMessage,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistoryFooter extends StatelessWidget {
  const _HistoryFooter();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Text(
          l10n.sessionHistoryFooter,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
