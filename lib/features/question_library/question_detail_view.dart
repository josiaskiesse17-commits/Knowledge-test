import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_colors.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game/widgets/question_body.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MetaRow(question: question),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(question.text, style: textTheme.titleMedium),
        const SizedBox(height: AppDimensions.spacingMd),
        _QuestionPayload(question: question),
        const SizedBox(height: AppDimensions.spacingMd),
        AnswerPanel(question: question),
        const SizedBox(height: AppDimensions.spacingMd),
        AppCard(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: AppDimensions.iconMd, color: colorScheme.primary),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Text(
                    'Explication',
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
                'Source : ${question.sourceReference}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                'Identifiant : ${question.id} • Groupe de fait : ${question.factGroupId}',
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
  const _QuestionPayload({required this.question});

  final BaseQuestion question;

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
                  _formatDate(question.events[i].date),
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
                    'Indices',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  for (var i = 0; i < question.clues.length; i++)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppDimensions.spacingXs),
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
                  color:
                      question.statements[i].isTrue ? successColor : errorColor,
                ),
              ),
          ],
        );

      case PutInOrderQuestion():
        final items = [...question.items]
          ..sort((a, b) => a.id.compareTo(b.id));
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
                  'Estimation ${question.variation.labelFr.toLowerCase()}',
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

  static String _formatDate(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year}';
  }
}

/// Small badges with mode, category, difficulty and variation.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.question});

  final BaseQuestion question;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingXs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _Badge(
          label: question.mode.displayNameFr,
          color: colorScheme.primary,
        ),
        _Badge(
          label: question.category.displayNameFr,
          color: colorScheme.secondary,
        ),
        _Badge(
          label: question.difficulty.displayNameFr,
          color: colorScheme.tertiary,
        ),
        _Badge(
          label: question.variation.labelFr,
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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
