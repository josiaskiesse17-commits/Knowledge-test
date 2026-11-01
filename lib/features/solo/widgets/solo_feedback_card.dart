import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/services/solo_answer_codec.dart';

/// Feedback card shown right after the player answers a solo question.
///
/// Shows whether the answer was correct, the correct answer, the explanation
/// and the source, plus the points earned and the current streak.
class SoloFeedbackCard extends StatelessWidget {
  final BaseQuestion question;
  final SoloAnswer answer;
  final SoloCheckResult checkResult;
  final bool isLast;
  final VoidCallback onNext;

  const SoloFeedbackCard({
    super.key,
    required this.question,
    required this.answer,
    required this.checkResult,
    required this.isLast,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCorrect = answer.isCorrect;

    final describedAnswer = SoloAnswerCodec.describe(
      question,
      answer.userAnswer,
    );
    final displayedAnswer = describedAnswer == 'true'
        ? l10n.soloTrue
        : describedAnswer == 'false'
        ? l10n.soloFalse
        : describedAnswer;

    return AppCard(
      color: isCorrect
          ? colorScheme.primaryContainer.withValues(alpha: 0.2)
          : colorScheme.errorContainer.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? colorScheme.primary : colorScheme.error,
                  size: AppDimensions.iconLg,
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: Text(
                    isCorrect ? l10n.soloCorrect : l10n.soloIncorrect,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isCorrect
                          ? colorScheme.primary
                          : colorScheme.error,
                    ),
                  ),
                ),
                Text(
                  l10n.soloPointsEarned(answer.pointsEarned),
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (!isCorrect) ...[
              _InfoRow(
                title: l10n.soloYourAnswer,
                value: answer.userAnswer.isEmpty
                    ? l10n.soloNoAnswer
                    : displayedAnswer,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
              _InfoRow(
                title: l10n.soloCorrectAnswer,
                value: checkResult.canonicalAnswer,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
            ],
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
                      Text(question.explanationFr, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              '${l10n.soloSource} ${question.sourceReference}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            PrimaryButton(
              label: isLast ? l10n.soloSeeResults : l10n.soloNextQuestion,
              icon: isLast ? Icons.assessment_outlined : Icons.skip_next,
              onPressed: onNext,
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
