import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';

class FinalRankingScreen extends ConsumerStatefulWidget {
  const FinalRankingScreen({super.key});

  @override
  ConsumerState<FinalRankingScreen> createState() => _FinalRankingScreenState();
}

class _FinalRankingScreenState extends ConsumerState<FinalRankingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigating here right after the completion is a second trigger for the
    // same session: the write stays exactly once through the shared id guard.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(gameControllerProvider);
      if (state.isCompleted) {
        ref.read(sessionHistoryProvider.notifier).persistCompleted(state);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final rankings = GameRules.rankings(state);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final maxScore = rankings.isEmpty
        ? 1
        : rankings.map((e) => e.player.score).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classement final'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = AppBreakpoints.sizeOf(constraints.maxWidth);
            // A wide window is allowed a wider measure so the podium cards are
            // not squeezed in the middle of the screen.
            final contentWidth = AppBreakpoints.contentMaxWidth(size);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: EdgeInsets.all(AppBreakpoints.pagePadding(
                    constraints.maxWidth,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Partie terminée',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        '${state.questions.length} questions jouées',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      Expanded(
                        // On a desktop window the rankings are laid out in
                        // columns instead of one long centered card.
                        child: AppBreakpoints.supportsTwoPane(constraints.maxWidth)
                            ? GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 420,
                                  crossAxisSpacing: AppDimensions.spacingSm,
                                  mainAxisSpacing: AppDimensions.spacingSm,
                                  mainAxisExtent: 84,
                                ),
                                itemCount: rankings.length,
                                itemBuilder: (context, index) => _RankCard(
                                  entry: rankings[index],
                                  maxScore: maxScore,
                                ),
                              )
                            : ListView.separated(
                                itemCount: rankings.length,
                                separatorBuilder: (_, _) => const SizedBox(
                                  height: AppDimensions.spacingSm,
                                ),
                                itemBuilder: (context, index) => _RankCard(
                                  entry: rankings[index],
                                  maxScore: maxScore,
                                ),
                              ),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      // Wrapped so the buttons stack on a narrow phone instead
                      // of overflowing.
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppDimensions.spacingMd,
                        runSpacing: AppDimensions.spacingSm,
                        children: [
                          TextButton(
                            onPressed: () =>
                                context.go(AppRoute.gameSetup.path),
                            child: const Text(
                                'Configurer une nouvelle partie'),
                          ),
                          PrimaryButton(
                            label: 'Retour à l\'accueil',
                            icon: Icons.home_outlined,
                            onPressed: () => context.go(AppRoute.home.path),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// One ranking row: position, name, tie note and score.
class _RankCard extends StatelessWidget {
  final FinalRankingEntry entry;
  final int maxScore;

  const _RankCard({required this.entry, required this.maxScore});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isWinner = entry.rank == 1 && maxScore > 0;

    return AppCard(
      color: isWinner
          ? colorScheme.primaryContainer.withValues(alpha: 0.4)
          : null,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isWinner
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              _rankLabelOf(entry.rank),
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color:
                    isWinner ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.player.name.isEmpty ? 'Joueur' : entry.player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.isTied)
                  Text(
                    'À égalité avec un autre joueur',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            '${entry.player.score} pt${entry.player.score == 1 ? '' : 's'}',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  static String _rankLabelOf(int rank) {
    switch (rank) {
      case 1:
        return '1er';
      case 2:
        return '2e';
      case 3:
        return '3e';
      default:
        return '${rank}e';
    }
  }
}
