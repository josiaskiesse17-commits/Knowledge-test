import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/features/game_setup/widgets/section_title.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart'
    show CategoryLocalizations;
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// Categories the questions are drawn from.
class CategoriesSection extends StatelessWidget {
  final SessionConfig config;
  final SessionSetupNotifier notifier;

  const CategoriesSection({
    super.key,
    required this.config,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.gameSetupCategoriesTitle,
          subtitle: config.categories.isEmpty
              ? l10n.gameSetupCategoriesSubtitleAll
              : l10n.gameSetupCategoriesSubtitleSelected(
                  config.categories.length,
                ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Wrap(
          spacing: AppDimensions.spacingSm,
          runSpacing: AppDimensions.spacingSm,
          children: [
            for (final category in QuestionCategory.values)
              FilterChip(
                label: Text(category.localizedName(l10n)),
                selected: config.categories.contains(category),
                onSelected: (_) => notifier.toggleCategory(category),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}
