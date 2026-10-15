import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game_setup/widgets/section_title.dart';
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: 'Durée ou nombre de questions',
          subtitle: config.isTimed
              ? 'Session minutée : la question en cours est toujours terminée.'
              : 'Session limitée en nombre de questions.',
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: false,
              label: Text('Questions'),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text('Durée'),
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
                    'Durée : ${config.sessionDurationMinutes} min',
                    style: textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => notifier.setSessionDurationMinutes(
                    (config.sessionDurationMinutes! - 1).clamp(1, 180),
                  ),
                  tooltip: 'Réduire la durée',
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => notifier.setSessionDurationMinutes(
                    (config.sessionDurationMinutes! + 1).clamp(1, 180),
                  ),
                  tooltip: 'Augmenter la durée',
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
                    'Nombre de questions : ${config.questionCount}',
                    style: textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => notifier.setQuestionCount(
                    (config.questionCount - 1).clamp(1, 30),
                  ),
                  tooltip: 'Moins de questions',
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => notifier.setQuestionCount(
                    (config.questionCount + 1).clamp(1, 30),
                  ),
                  tooltip: 'Plus de questions',
                ),
              ],
            ),
          ),
        const SizedBox(height: AppDimensions.spacingSm),
      ],
    );
  }
}
