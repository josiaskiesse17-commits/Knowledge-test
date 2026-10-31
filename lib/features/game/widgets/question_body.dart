import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';

/// Renders the body of the current question for every game mode, and the
/// correct answer once the quizmaster reveals it.
class QuestionBody extends StatelessWidget {
  final BaseQuestion question;
  final RoundState round;
  final VoidCallback onRevealAnswer;
  final VoidCallback onToggleExplanation;

  const QuestionBody({
    super.key,
    required this.question,
    required this.round,
    required this.onRevealAnswer,
    required this.onToggleExplanation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingXs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _Badge(
              label: question.mode.title(l10n),
              color: colorScheme.primary,
            ),
            _Badge(
              label: question.category.localizedName(l10n),
              color: colorScheme.secondary,
            ),
            _Badge(
              label: question.difficulty.localizedName(l10n),
              color: colorScheme.tertiary,
            ),
            if (question.variation != QuestionVariation.whichCameFirst &&
                question.variation !=
                    QuestionVariation.guessTheCountryProgressive)
              _Badge(
                label: question.variation.localizedName(l10n),
                color: colorScheme.outline,
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          question.text,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _QuestionContent(question: question, round: round, l10n: l10n),
        const SizedBox(height: AppDimensions.spacingLg),
        if (!round.answerRevealed)
          SecondaryButton(
            label: l10n.questionBodyRevealAnswer,
            icon: Icons.visibility_outlined,
            onPressed: onRevealAnswer,
          ),
        if (round.answerRevealed) AnswerPanel(question: question, l10n: l10n),
        if (round.answerRevealed) ...[
          const SizedBox(height: AppDimensions.spacingSm),
          SecondaryButton(
            label: round.explanationRevealed
                ? l10n.questionBodyHideExplanation
                : l10n.questionBodyShowExplanation,
            icon: round.explanationRevealed
                ? Icons.expand_less
                : Icons.help_outline,
            onPressed: onToggleExplanation,
          ),
          if (round.explanationRevealed) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            _ExplanationCard(
              question: question,
              l10n: l10n,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
        ],
      ],
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final BaseQuestion question;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ExplanationCard({
    required this.question,
    required this.l10n,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: AppDimensions.iconMd,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                l10n.questionBodyExplanationTitle,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(question.explanationFr, style: textTheme.bodyMedium),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            '${l10n.questionBodySource} ${question.sourceReference}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionContent extends StatelessWidget {
  final BaseQuestion question;
  final RoundState round;
  final AppLocalizations l10n;

  const _QuestionContent({
    required this.question,
    required this.round,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final question = this.question;

    switch (question) {
      case WhichCameFirstQuestion():
        return _WhichCameFirstContent(question: question);
      case GuessTheCountryQuestion():
        return _GuessTheCountryContent(
          question: question,
          round: round,
          l10n: l10n,
        );
      case FactOrCapQuestion():
        return _FactOrCapContent(question: question, l10n: l10n);
      case PutInOrderQuestion():
        return _PutInOrderContent(question: question, round: round, l10n: l10n);
      case HowMuchQuestion():
        return _HowMuchContent(question: question, l10n: l10n);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _WhichCameFirstContent extends StatelessWidget {
  final WhichCameFirstQuestion question;

  const _WhichCameFirstContent({required this.question});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.events.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: AppCard(
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
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      question.events[i].label,
                      style: textTheme.bodyLarge,
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

class _GuessTheCountryContent extends StatelessWidget {
  final GuessTheCountryQuestion question;
  final RoundState round;
  final AppLocalizations l10n;

  const _GuessTheCountryContent({
    required this.question,
    required this.round,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (question.imageUrl != null) _QuestionImage(url: question.imageUrl!),
        if (question.imageUrl != null)
          const SizedBox(height: AppDimensions.spacingSm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${l10n.questionBodyCluesRevealed}: ${round.revealedClues} / ${question.clues.length}',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              for (
                var i = 0;
                i < round.revealedClues && i < question.clues.length;
                i++
              )
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingSm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}.',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      Expanded(child: Text(question.clues[i].text)),
                    ],
                  ),
                ),
              if (round.revealedClues == 0)
                Text(
                  l10n.questionBodyNoCluesYet,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FactOrCapContent extends StatelessWidget {
  final FactOrCapQuestion question;
  final AppLocalizations l10n;

  const _FactOrCapContent({required this.question, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.statements.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
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

class _PutInOrderContent extends StatelessWidget {
  final PutInOrderQuestion question;
  final RoundState round;
  final AppLocalizations l10n;

  const _PutInOrderContent({
    required this.question,
    required this.round,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final displayed = [...question.items]..sort((a, b) => a.id.compareTo(b.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.questionBodyElementsToOrder,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              for (final item in displayed)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacingXs,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.drag_handle,
                        size: AppDimensions.iconMd,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      Expanded(child: Text(item.label)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (round.answerRevealed) ...[
          const SizedBox(height: AppDimensions.spacingMd),
          AppCard(
            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.questionBodyCompleteOrder,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                for (var i = 0; i < question.correctOrderIds.length; i++)
                  Builder(
                    builder: (context) {
                      final item = question.items.firstWhere(
                        (it) => it.id == question.correctOrderIds[i],
                        orElse: () => question.items.first,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingXs,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${i + 1}',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            Expanded(child: Text(item.label)),
                            Text(
                              _formattedValue(item),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static String _formattedValue(OrderableItem item) {
    final value = item.referenceValue;
    final display = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
    return '$display ${item.unit ?? ''}'.trim();
  }
}

class _HowMuchContent extends StatelessWidget {
  final HowMuchQuestion question;
  final AppLocalizations l10n;

  const _HowMuchContent({required this.question, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final answer = question.answer;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.questionBodyExpectedAnswer,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            '${_formattedValue(answer.referenceValue)} ${answer.unitFr ?? answer.unit}',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          if (answer.acceptedMin != null && answer.acceptedMax != null) ...[
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              '${l10n.questionBodyAcceptedRange}: ${_formattedValue(answer.acceptedMin!)} \u00e0 ${_formattedValue(answer.acceptedMax!)} ${answer.unitFr ?? answer.unit}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            '${l10n.questionBodyScoringRule}: ${answer.scoringRuleId}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  static String _formattedValue(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }
}

class _QuestionImage extends StatelessWidget {
  final String url;

  const _QuestionImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Image.asset(
        url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const Text('Image indisponible'),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

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
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Correct answer for each mode, shown on request.
class AnswerPanel extends StatelessWidget {
  final BaseQuestion question;
  final AppLocalizations l10n;

  const AnswerPanel({super.key, required this.question, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: colorScheme.primary),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                l10n.questionBodyCorrectAnswer,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          ..._answerLines(context),
        ],
      ),
    );
  }

  List<Widget> _answerLines(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final question = this.question;

    switch (question) {
      case WhichCameFirstQuestion():
        final first = question.events[question.correctFirstIndex];
        final second = question.events[question.correctSecondIndex];
        return [
          _AnswerLine(title: l10n.questionBodyFirst, value: first.label),
          _AnswerLine(title: l10n.questionBodyThen, value: second.label),
        ];

      case GuessTheCountryQuestion():
        final country = question.targetCountry;
        final accepted = question.acceptedAnswers
            .where((a) => a != country)
            .toList();
        return [
          _AnswerLine(title: l10n.questionBodyCountry, value: country),
          _AnswerLine(
            title: l10n.questionBodyCapital,
            value: '${question.capital} (${question.continent})',
          ),
          if (accepted.isNotEmpty)
            _AnswerLine(
              title: l10n.questionBodyAcceptedAnswers,
              value: accepted.join(', '),
            ),
        ];

      case FactOrCapQuestion():
        final falseStatements = question.statements
            .asMap()
            .entries
            .where((e) => !e.value.isTrue)
            .map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value.text}')
            .toList();
        return [
          Text(
            question.variation == QuestionVariation.factOrCapTrueFalse
                ? l10n.questionBodyStatementTrueFalse(
                    question.statements.first.isTrue ? 'true' : 'false',
                  )
                : l10n.questionBodyFalseStatements,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          for (final statement in falseStatements)
            Text(
              statement,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.error,
              ),
            ),
        ];

      case PutInOrderQuestion():
        return [
          Text(
            l10n.questionBodyCorrectOrder,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          for (var i = 0; i < question.correctOrderIds.length; i++)
            Builder(
              builder: (context) {
                final item = question.items.firstWhere(
                  (it) => it.id == question.correctOrderIds[i],
                  orElse: () => question.items.first,
                );
                final value = item.referenceValue;
                final display = value == value.roundToDouble()
                    ? value.toInt().toString()
                    : value.toString();
                return Text(
                  '${i + 1}. ${item.label} \u2014 $display ${item.unit ?? ''}'
                      .trimRight(),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                );
              },
            ),
        ];

      case HowMuchQuestion():
        final answer = question.answer;
        final value = answer.referenceValue;
        final display = value == value.roundToDouble()
            ? value.toInt().toString()
            : value.toString();
        final lines = [
          _AnswerLine(
            title: l10n.questionBodyValue,
            value: '$display ${answer.unitFr ?? answer.unit}',
          ),
        ];
        if (answer.acceptedMin != null && answer.acceptedMax != null) {
          final min = answer.acceptedMin!;
          final max = answer.acceptedMax!;
          final minText = min == min.roundToDouble()
              ? min.toInt().toString()
              : min.toString();
          final maxText = max == max.roundToDouble()
              ? max.toInt().toString()
              : max.toString();
          lines.add(
            _AnswerLine(
              title: l10n.questionBodyAcceptedRange,
              value: '$minText \u2013 $maxText ${answer.unitFr ?? answer.unit}',
            ),
          );
        }
        return lines;

      default:
        return const [SizedBox.shrink()];
    }
  }
}

class _AnswerLine extends StatelessWidget {
  final String title;
  final String value;

  const _AnswerLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
