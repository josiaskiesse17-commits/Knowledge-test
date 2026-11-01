import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/services/solo_answer_codec.dart';

import 'solo_guess_the_country_controls.dart';
import 'solo_how_much_controls.dart';
import 'solo_put_in_order_controls.dart';

/// Answering controls for every mode supported in solo.
///
/// Each control encodes the player's answer with [SoloAnswerCodec] and reports
/// it through [onAnswer] as the string that [SoloRules.checkAnswer] expects.
class SoloQuestionControls extends StatelessWidget {
  final BaseQuestion question;
  final List<BaseQuestion> bank;
  final void Function(String encodedAnswer) onAnswer;

  const SoloQuestionControls({
    super.key,
    required this.question,
    required this.bank,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    switch (question) {
      case WhichCameFirstQuestion():
        return _WhichCameFirstControls(
          question: question as WhichCameFirstQuestion,
          onAnswer: onAnswer,
        );
      case FactOrCapQuestion():
        return _FactOrCapControls(
          question: question as FactOrCapQuestion,
          onAnswer: onAnswer,
        );
      case GuessTheCountryQuestion():
        return SoloGuessTheCountryControls(
          question: question as GuessTheCountryQuestion,
          bank: bank,
          onAnswer: onAnswer,
        );
      case PutInOrderQuestion():
        return SoloPutInOrderControls(
          question: question as PutInOrderQuestion,
          onAnswer: onAnswer,
        );
      case HowMuchQuestion():
        return SoloHowMuchControls(
          question: question as HowMuchQuestion,
          onAnswer: onAnswer,
        );
      default:
        return _UnsupportedControls(question);
    }
  }
}

/// Two tappable event cards for WhichCameFirst.
class _WhichCameFirstControls extends StatelessWidget {
  final WhichCameFirstQuestion question;
  final void Function(String encodedAnswer) onAnswer;

  const _WhichCameFirstControls({
    required this.question,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.events.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: _SelectableCard(
              onTap: () => onAnswer(SoloAnswerCodec.encodeWhichCameFirst(i)),
              colorScheme: colorScheme,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      question.events[i].label,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// True/false buttons or tappable statements for FactOrCap.
class _FactOrCapControls extends StatelessWidget {
  final FactOrCapQuestion question;
  final void Function(String encodedAnswer) onAnswer;

  const _FactOrCapControls({required this.question, required this.onAnswer});

  bool get _isTrueFalse =>
      question.lieStatementIndex == null &&
      question.falseStatementIndex == null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isTrueFalse) {
      final isTrue = question.statements.isNotEmpty
          ? question.statements.first.isTrue
          : false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.statements.isNotEmpty
                ? question.statements.first.text
                : '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              Expanded(
                child: _SelectableCard(
                  onTap: () => onAnswer(
                    SoloAnswerCodec.encodeFactOrCapTrueFalse(isTrue),
                  ),
                  colorScheme: colorScheme,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    child: Row(
                      children: [
                        Icon(
                          isTrue ? Icons.check_circle : Icons.circle_outlined,
                          color: isTrue
                              ? colorScheme.primary
                              : colorScheme.outline,
                          size: AppDimensions.iconMd,
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: Text(
                            'Vrai',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: _SelectableCard(
                  onTap: () => onAnswer(
                    SoloAnswerCodec.encodeFactOrCapTrueFalse(!isTrue),
                  ),
                  colorScheme: colorScheme,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    child: Row(
                      children: [
                        Icon(
                          !isTrue ? Icons.check_circle : Icons.circle_outlined,
                          color: !isTrue
                              ? colorScheme.primary
                              : colorScheme.outline,
                          size: AppDimensions.iconMd,
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: Text(
                            'Faux',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Statement modes: tap the statement that is false (or the lie).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.statements.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: _SelectableCard(
              onTap: () =>
                  onAnswer(SoloAnswerCodec.encodeFactOrCapStatement(i)),
              colorScheme: colorScheme,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      question.statements[i].text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A tappable card.
class _SelectableCard extends StatelessWidget {
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final Widget child;

  const _SelectableCard({
    required this.onTap,
    required this.colorScheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(onTap: onTap, child: child);
  }
}

/// Placeholder for modes not yet supported in solo.
///
/// Kept as a safety net: every mode in [GameMode] is handled above, so this
/// branch is only reachable for a future mode that has not been wired yet.
class _UnsupportedControls extends StatelessWidget {
  final BaseQuestion question;

  const _UnsupportedControls(this.question);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.help_outline,
              color: colorScheme.onSurfaceVariant,
              size: AppDimensions.iconLg,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.soloNotSupportedYet,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButtonWidget(label: l10n.soloSkipQuestion, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
