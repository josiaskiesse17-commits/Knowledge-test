import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:knowledge_test/core/constants/app_colors.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game/widgets/question_body.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Read-only details of a question from the library.
///
/// Reuses the game widgets so the library shows exactly the same question data
/// as the quiz master sees during a session.
class QuestionDetailView extends StatelessWidget {
  const QuestionDetailView({super.key, required this.question});

  final BaseQuestion question;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MetaRow(question: question, l10n: l10n),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(question.text, style: textTheme.titleMedium),
        const SizedBox(height: AppDimensions.spacingMd),
        _QuestionPayload(question: question, l10n: l10n),
        const SizedBox(height: AppDimensions.spacingMd),
        AnswerPanel(question: question, l10n: l10n),
        const SizedBox(height: AppDimensions.spacingMd),
        AppCard(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: AppDimensions.iconMd,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Text(
                    l10n.questionDetailExplanation,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(question.explanationFr, style: textTheme.bodyMedium),
              const SizedBox(height: AppDimensions.spacingMd),
              Divider(color: colorScheme.outlineVariant),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                '${l10n.questionDetailSource} ${question.sourceReference}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                '${l10n.questionDetailId}: ${question.id} \u2022 ${l10n.questionDetailFactGroup}: ${question.factGroupId}',
                style: textTheme.bodySmall?.copyWith(
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

/// Question elements: events, clues, statements, ordered items.
class _QuestionPayload extends StatelessWidget {
  const _QuestionPayload({required this.question, required this.l10n});

  final BaseQuestion question;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Local alias so the switch promotes the question type.
    final question = this.question;

    switch (question) {
      case WhichCameFirstQuestion():
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < question.events.length; i++)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(question.events[i].label),
                subtitle: Text(
                  _formatDate(question.events[i].date, l10n),
                  style: textTheme.bodySmall,
                ),
              ),
          ],
        );

      case GuessTheCountryQuestion():
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.questionDetailClues,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  for (var i = 0; i < question.clues.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingXs,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${i + 1}.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingSm),
                          Expanded(child: Text(question.clues[i].text)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );

      case FactOrCapQuestion():
        final successColor = context.successColor;
        final errorColor = context.errorColor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < question.statements.length; i++)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: question.statements[i].isTrue
                      ? successColor.withValues(alpha: 0.15)
                      : errorColor.withValues(alpha: 0.15),
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: textTheme.labelMedium?.copyWith(
                      color: question.statements[i].isTrue
                          ? successColor
                          : errorColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(question.statements[i].text),
                trailing: Icon(
                  question.statements[i].isTrue
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  color: question.statements[i].isTrue
                      ? successColor
                      : errorColor,
                ),
              ),
          ],
        );

      case PutInOrderQuestion():
        final items = [...question.items]..sort((a, b) => a.id.compareTo(b.id));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in items)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.drag_indicator, size: 20),
                title: Text(item.label),
                trailing: Text(
                  item.referenceValue.toString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        );

      case HowMuchQuestion():
        return AppCard(
          child: Row(
            children: [
              Icon(Icons.straighten_outlined, color: colorScheme.primary),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  '${l10n.questionDetailEstimation} ${question.variation.labelFr.toLowerCase()}',
                  style: textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  static String _formatDate(DateTime date, AppLocalizations l10n) {
    return intl.DateFormat.yMd(l10n.localeName).format(date);
  }
}

/// Small badges with mode, category, difficulty and variation.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.question, required this.l10n});

  final BaseQuestion question;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingXs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _Badge(label: question.mode.title(l10n), color: colorScheme.primary),
        _Badge(
          label: question.category.localizedName(l10n),
          color: colorScheme.secondary,
        ),
        _Badge(
          label: question.difficulty.localizedName(l10n),
          color: colorScheme.tertiary,
        ),
        _Badge(
          label: question.variation.localizedName(l10n),
          color: colorScheme.outline,
        ),
      ],
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
