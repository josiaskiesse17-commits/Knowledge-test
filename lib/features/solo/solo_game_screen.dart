import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/features/solo/widgets/solo_feedback_card.dart';
import 'package:knowledge_test/features/solo/widgets/solo_question_controls.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
import 'package:knowledge_test/services/solo_answer_codec.dart';
import 'package:knowledge_test/services/solo_rules.dart';

/// Solo game screen.
///
/// Shows the current question, the answering controls for the supported
/// modes, and a feedback card after each answer. Quitting keeps the session
/// as in-progress so it can be resumed later.
class SoloGameScreen extends ConsumerStatefulWidget {
  const SoloGameScreen({super.key});

  @override
  ConsumerState<SoloGameScreen> createState() => _SoloGameScreenState();
}

class _SoloGameScreenState extends ConsumerState<SoloGameScreen> {
  int? _selectedIndex;
  bool _showingFeedback = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(soloControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    if (state.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (GoRouter.maybeOf(context) == null) return;
        context.go(AppRoute.soloSummary.path);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = state.currentQuestion;
    if (!state.isInProgress && !state.isCompleted) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.soloSetupTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoute.home.path),
          ),
        ),
        body: const Center(child: Text('Aucune question en cours.')),
      );
    }

    final displayQuestion = state.isCompleted
        ? state.questions.last
        : question!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _confirmQuit(context, l10n);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(displayQuestion.mode.title(l10n)),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.soloQuitDialogTitle,
            onPressed: () => _confirmQuit(context, l10n),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.soloQuestionNumber(
                              state.isCompleted
                                  ? state.questions.length
                                  : state.currentIndex + 1,
                              state.questions.length,
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                l10n.soloScore(state.score),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                l10n.soloStreak(state.streak),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      if (_showingFeedback || state.isCompleted) ...[
                        SoloFeedbackCard(
                          question: displayQuestion,
                          answer: state.answers.last,
                          checkResult: SoloRules.checkAnswer(
                            displayQuestion,
                            state.answers.last.userAnswer,
                          ),
                          isLast: state.isCompleted,
                          onNext: _onNext,
                        ),
                      ] else ...[
                        Text(
                          displayQuestion.text,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SoloQuestionControls(
                          question: displayQuestion,
                          selectedIndex: _selectedIndex,
                          onIndexSelected: _answerIndex,
                          onTextSubmitted: _answerText,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _answerIndex(int index) {
    final question = ref.read(soloControllerProvider).currentQuestion!;
    setState(() {
      _selectedIndex = index;
    });
    _submitAnswer(SoloAnswerCodec.encode(question, index));
  }

  void _answerText(String text) {
    setState(() {
      _selectedIndex = null;
    });
    _submitAnswer(text);
  }

  Future<void> _submitAnswer(String userAnswer) async {
    final controller = ref.read(soloControllerProvider.notifier);
    await controller.answer(userAnswer);
    if (!context.mounted) return;
    setState(() {
      _showingFeedback = true;
      _selectedIndex = null;
    });
  }

  void _onNext() {
    final state = ref.read(soloControllerProvider);
    if (state.isCompleted) {
      if (GoRouter.maybeOf(context) != null) {
        context.go(AppRoute.soloSummary.path);
      }
      return;
    }
    setState(() {
      _showingFeedback = false;
      _selectedIndex = null;
    });
  }

  Future<void> _confirmQuit(BuildContext context, AppLocalizations l10n) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.soloQuitDialogTitle),
        content: Text(l10n.soloQuitDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.soloQuitDialogStay),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.soloQuitDialogQuit),
          ),
        ],
      ),
    );

    if (leave != true || !context.mounted) return;
    final soloController = ref.read(soloControllerProvider.notifier);
    await soloController.abandon();
    if (context.mounted) {
      context.go(AppRoute.home.path);
    }
  }
}
