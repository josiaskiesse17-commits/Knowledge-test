import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/features/game/widgets/empty_session.dart';
import 'package:knowledge_test/features/game/widgets/game_layouts.dart';
import 'package:knowledge_test/features/game/widgets/quizmaster_bar.dart';
import 'package:knowledge_test/features/game/widgets/scoreboard.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

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
      return EmptySession(onBack: () => context.go(AppRoute.gameSetup.path));
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
            ? WideGameLayout(
                state: state,
                controller: controller,
                onAward: awardTo,
              )
            : PhoneGameLayout(
                state: state,
                controller: controller,
              ),
      ),
      bottomNavigationBar: isWide
          ? null
          : QuizmasterBar(
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
