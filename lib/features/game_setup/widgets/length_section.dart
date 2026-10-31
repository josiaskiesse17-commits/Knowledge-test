import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game_setup/widgets/section_title.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// Session length: a duration or a number of questions.
class LengthSection extends StatelessWidget {
  final SessionConfig config;
  final SessionSetupNotifier notifier;

  const LengthSection({
    super.key,
    required this.config,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: l10n.gameSetupLengthTitle,
          subtitle: config.isTimed
              ? l10n.gameSetupLengthSubtitleTimed
              : l10n.gameSetupLengthSubtitleQuestions,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment<bool>(
              value: false,
              label: Text(l10n.gameSetupLengthQuestions),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text(l10n.gameSetupLengthDuration),
            ),
          ],
          selected: {config.isTimed},
          onSelectionChanged: (selection) {
            final timed = selection.first;
            notifier.setSessionDurationMinutes(timed ? 15 : null);
          },
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (config.isTimed)
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.sessionSettingsDurationLabel(
                      config.sessionDurationMinutes!,
                    ),
                    style: textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => notifier.setSessionDurationMinutes(
                    (config.sessionDurationMinutes! - 1).clamp(1, 180),
                  ),
                  tooltip: l10n.gameSetupDecreaseDurationTooltip,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => notifier.setSessionDurationMinutes(
                    (config.sessionDurationMinutes! + 1).clamp(1, 180),
                  ),
                  tooltip: l10n.gameSetupIncreaseDurationTooltip,
                ),
              ],
            ),
          )
        else
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.sessionSettingsQuestionCountLabel(
                      config.questionCount,
                    ),
                    style: textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => notifier.setQuestionCount(
                    (config.questionCount - 1).clamp(1, 30),
                  ),
                  tooltip: l10n.gameSetupDecreaseQuestionsTooltip,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => notifier.setQuestionCount(
                    (config.questionCount + 1).clamp(1, 30),
                  ),
                  tooltip: l10n.gameSetupIncreaseQuestionsTooltip,
                ),
              ],
            ),
          ),
        const SizedBox(height: AppDimensions.spacingSm),
      ],
    );
  }
}
