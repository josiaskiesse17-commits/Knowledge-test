import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// One question of the library, as a tappable summary card.
class QuestionCard extends StatelessWidget {
  final BaseQuestion question;
  final VoidCallback onTap;
  final bool isSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_modeIcon(question.mode),
                  size: AppDimensions.iconSm, color: colorScheme.primary),
              const SizedBox(width: AppDimensions.spacingXs),
              Expanded(
                child: Text(
                  question.mode.displayNameFr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                question.difficulty.displayNameFr,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            question.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingXs,
            runSpacing: AppDimensions.spacingXs,
            children: [
              Text(
                question.category.displayNameFr,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '•',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              Text(
                question.variation.labelFr,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static IconData _modeIcon(GameMode mode) => switch (mode) {
        GameMode.whichCameFirst => Icons.history_outlined,
        GameMode.guessTheCountry => Icons.public_outlined,
        GameMode.factOrCap => Icons.fact_check_outlined,
        GameMode.putInOrder => Icons.sort_outlined,
        GameMode.howMuch => Icons.straighten_outlined,
      };
}
