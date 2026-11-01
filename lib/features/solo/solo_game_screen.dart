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
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/solo_providers.dart';
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
  bool _showingFeedback = false;
  bool _answering = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(soloControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final bank = ref.watch(questionRepositoryProvider).getAllQuestions();

    if (state.isCompleted) {
      // Resolve the feedback question from the last answered question, never
      // from currentIndex (recordAnswer advances it immediately).
      BaseQuestion? feedbackQuestion;
      if (state.answers.isNotEmpty) {
        for (final q in state.questions) {
          if (q.id == state.answers.last.questionId) {
            feedbackQuestion = q;
            break;
          }
        }
      }
      // When the player just answered the last question (this screen session
      // recorded it), show the feedback card for that question. Navigation to
      // the summary only happens when the player taps "See results".
      // Storage can be slow on device, so _answering covers the in-flight
      // window between recording the answer and the state rebuild.
      if (feedbackQuestion != null && (_showingFeedback || _answering)) {
        return SingleChildScrollView(
          child: _feedbackCard(feedbackQuestion, true),
        );
      }
      // A completed session opened directly (for instance resumed after the
      // app was closed on the last feedback) has nothing left to answer: send
      // the player to the summary instead of an empty screen.
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

    // Resolve the feedback question from the last answered question, never
    // from currentIndex (recordAnswer advances it immediately, which would
    // show the next question's explanation as a spoiler).
    BaseQuestion? feedbackQuestion;
    if (state.answers.isNotEmpty) {
      for (final q in state.questions) {
        if (q.id == state.answers.last.questionId) {
          feedbackQuestion = q;
          break;
        }
      }
    }

    final isFeedback = _showingFeedback && feedbackQuestion != null;
    final displayQuestion = isFeedback ? feedbackQuestion : question!;

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
                      if (isFeedback) ...[
                        _feedbackCard(displayQuestion, state.isCompleted),
                      ] else ...[
                        Text(
                          displayQuestion.text,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SoloQuestionControls(
                          question: displayQuestion,
                          bank: bank,
                          onAnswer: _submitAnswer,
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

  Widget _feedbackCard(BaseQuestion question, bool isLast) {
    final state = ref.read(soloControllerProvider);
    return SoloFeedbackCard(
      question: question,
      answer: state.answers.last,
      checkResult: SoloRules.checkAnswer(
        question,
        state.answers.last.userAnswer,
      ),
      isLast: isLast,
      onNext: _onNext,
    );
  }

  Future<void> _submitAnswer(String userAnswer) async {
    _answering = true;
    final controller = ref.read(soloControllerProvider.notifier);
    await controller.answer(userAnswer);
    if (!context.mounted) return;
    setState(() {
      _showingFeedback = true;
      _answering = false;
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
