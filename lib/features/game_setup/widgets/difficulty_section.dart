import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/features/game_setup/widgets/section_title.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// Preferred difficulty of the session.
class DifficultySection extends StatelessWidget {
  final SessionConfig config;
  final SessionSetupNotifier notifier;

  const DifficultySection({
    super.key,
    required this.config,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          title: 'Difficulté',
          subtitle: 'Les questions de ce niveau sont privilégiées.',
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        SegmentedButton<Difficulty>(
          segments: [
            for (final difficulty in Difficulty.values)
              ButtonSegment<Difficulty>(
                value: difficulty,
                label: Text(difficulty.displayNameFr),
              ),
          ],
          selected: {config.difficulty},
          onSelectionChanged: (selection) => notifier.setDifficulty(selection.first),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}
