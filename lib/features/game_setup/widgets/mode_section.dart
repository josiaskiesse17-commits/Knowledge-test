import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game_setup/widgets/section_title.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// One or several game modes for the session.
class ModeSection extends StatelessWidget {
  final SessionConfig config;
  final SessionSetupNotifier notifier;

  const ModeSection({
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
          title: 'Modes de jeu',
          subtitle: 'Un ou plusieurs modes pour la session.',
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        for (final mode in GameMode.values)
          ModeTile(
            mode: mode,
            isSelected: config.modes.contains(mode),
            onTap: () => notifier.toggleMode(mode),
          ),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}

/// A selectable card describing one game mode.
class ModeTile extends StatelessWidget {
  final GameMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const ModeTile({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: AppCard(
        onTap: onTap,
        color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.4) : null,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              size: AppDimensions.iconMd,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.displayNameFr,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    mode.descriptionFr,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
